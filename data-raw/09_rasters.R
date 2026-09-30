# National 1 km rasters in the Albers projection, built from cloud-optimised
# GeoTIFFs read over HTTP (only the overview levels needed are fetched):
# * elevation from the Copernicus DEM GLO-90 (free, attribution required);
# * land cover from ESA WorldCover 2021 v200 (CC BY 4.0), by majority.

source("data-raw/00_config.R")
library(terra)
setGDALconfig("GDAL_DISABLE_READDIR_ON_OPEN", "EMPTY_DIR")
setGDALconfig("GDAL_HTTP_MULTIRANGE", "YES")
setGDALconfig("GDAL_HTTP_MAX_RETRY", "5")
setGDALconfig("VSI_CACHE", "TRUE")
terraOptions(progress = 0)

layers <- readRDS(build_path("layers.rds"))
country <- layers$high$country
bb <- st_bbox(st_transform(st_buffer(st_transform(country, crs_albers), 10000), 4326))

# A 1 km grid snapped to whole kilometres, covering Mongolia plus 10 km.
alb <- st_bbox(st_buffer(st_transform(country, crs_albers), 10000))
snap <- \(v, f) f(v / 1000) * 1000
template <- rast(
  xmin = snap(alb$xmin, floor), xmax = snap(alb$xmax, ceiling),
  ymin = snap(alb$ymin, floor), ymax = snap(alb$ymax, ceiling),
  resolution = 1000, crs = crs_albers
)

cop_tile <- function(lat, lon) {
  nm <- sprintf("Copernicus_DSM_COG_30_N%02d_00_E%03d_00_DEM", lat, lon)
  sprintf("/vsicurl/https://copernicus-dem-90m.s3.amazonaws.com/%s/%s.tif", nm, nm)
}
wc_tile <- function(lat, lon) {
  sprintf(
    "/vsicurl/https://esa-worldcover.s3.eu-central-1.amazonaws.com/v200/2021/map/ESA_WorldCover_10m_2021_v200_N%02dE%03d_Map.tif",
    lat, lon
  )
}
exists_remote <- function(u) {
  !inherits(try(rast(u), silent = TRUE), "try-error")
}

release_dir <- build_path("release")
dir.create(release_dir, showWarnings = FALSE)
cog <- function(r, file, datatype) {
  out <- file.path(release_dir, file)
  unlink(out)
  writeRaster(r, out, filetype = "COG", datatype = datatype, gdal = c("COMPRESS=DEFLATE", "PREDICTOR=2", "OVERVIEWS=AUTO"))
  message(sprintf("%s: %.1f MB", file, file.size(out) / 1024^2))
  out
}

# Elevation.
if (!file.exists(file.path(release_dir, "elevation_1km.tif"))) {
grid <- expand.grid(lat = floor(bb$ymin):floor(bb$ymax), lon = floor(bb$xmin):floor(bb$xmax))
dem_urls <- cop_tile(grid$lat, grid$lon)
dem_urls <- dem_urls[map_lgl(dem_urls, exists_remote)]
message("Copernicus tiles: ", length(dem_urls))
dem <- project(vrt(dem_urls), template, method = "bilinear")
names(dem) <- "elevation"
cog(round(dem), "elevation_1km.tif", "INT2S")
}

# Land cover: 3-degree tiles aligned on multiples of 3. Each tile is read at
# its fifth overview (about 250 m), which GDAL does not pick by itself for
# mode resampling, then the majority class of each 1 km cell is taken.
lat3 <- seq(3 * floor(bb$ymin / 3), 3 * floor(bb$ymax / 3), by = 3)
lon3 <- seq(3 * floor(bb$xmin / 3), 3 * floor(bb$xmax / 3), by = 3)
g3 <- expand.grid(lat = lat3, lon = lon3)
wc_urls <- wc_tile(g3$lat, g3$lon)
tiles <- compact(map(wc_urls, function(u) {
  r <- try(rast(u, opts = "OVERVIEW_LEVEL=4"), silent = TRUE)
  if (inherits(r, "try-error")) NULL else toMemory(r)
}))
message("WorldCover tiles: ", length(tiles))
lc <- project(merge(sprc(tiles)), template, method = "mode")
names(lc) <- "landcover"
cog(lc, "landcover_1km.tif", "INT1U")
