skip_if_not_installed("terra")

# A synthetic 20 km raster in Albers over all of Mongolia, saved to a file
# that stands in for a downloaded asset. `values` is a function of the
# number of cells.
local_raster_file <- function(values = seq_len, env = parent.frame()) {
  r <- terra::rast(
    xmin = -1200000, xmax = 1220000, ymin = -620000, ymax = 600000,
    resolution = 20000, crs = mongolmaps:::.mm_albers
  )
  terra::values(r) <- values(terra::ncell(r))
  path <- withr::local_tempfile(fileext = ".tif", .local_envir = env)
  terra::writeRaster(r, path)
  path
}

test_that("mn_elevation() reads the national grid and masks it to a place", {
  path <- local_raster_file()
  local_mocked_bindings(.mm_asset = function(id, ...) path)
  khovd <- mn_elevation(within = "Khovd")
  expect_s4_class(khovd, "SpatRaster")
  expect_true(anyNA(terra::values(khovd)))
  whole <- mn_elevation(mask = FALSE)
  expect_equal(terra::ncell(whole), 121 * 61)
  expect_true(terra::is.lonlat(mn_elevation(within = "Khovd", crs = "wgs84")))
})

test_that("90 m elevation needs a small area", {
  expect_snapshot(mn_elevation("90m"), error = TRUE)
  expect_snapshot(.mm_check_tiles(40, 16, "90 m elevation"), error = TRUE)
  expect_snapshot(mn_landcover("10m", within = "Khovd"), error = TRUE)
})

test_that("90 m elevation is read from cloud tiles", {
  path <- local_raster_file()
  local_mocked_bindings(.mm_remote_mosaic = function(urls, area, name, ...) {
    expect_match(urls, "Copernicus_DSM_COG_30_N4[78]_00_E09[12]_00_DEM", all = FALSE)
    terra::project(terra::rast(path), "EPSG:4326")
  })
  expect_s4_class(mn_elevation("90m", within = "MN8401"), "SpatRaster")
})

test_that("remote reads stop cleanly when offline", {
  withr::local_options(mongolmaps.offline = TRUE)
  expect_snapshot(.mm_remote_mosaic("https://example.org/a.tif", NULL, "elevation"), error = TRUE)
})

test_that("mn_hillshade() shades the elevation", {
  path <- local_raster_file(values = \(n) runif(n, 1000, 3000))
  local_mocked_bindings(.mm_asset = function(id, ...) path)
  hs <- mn_hillshade(within = "Uvs")
  expect_equal(names(hs), "hillshade")
  expect_true(all(terra::values(hs) >= 0 & terra::values(hs) <= 1, na.rm = TRUE))
})

test_that("mn_landcover() returns classes with colours", {
  path <- local_raster_file(values = \(n) sample(c(10, 20, 30, 60), n, replace = TRUE))
  local_mocked_bindings(.mm_asset = function(id, ...) path)
  lc <- mn_landcover(within = "Khovd")
  expect_true(terra::is.factor(lc))
  expect_true("Grassland" %in% terra::levels(lc)[[1]]$class)
  expect_equal(nrow(terra::coltab(lc)[[1]]), 11)
})

test_that("mn_population() checks the year and downloads the right file", {
  expect_snapshot(mn_population(2014), error = TRUE)
  row <- .mm_worldpop_row(2020L, "100m")
  expect_match(row$url, "R2025A/2020/MNG/v1/100m/constrained/mng_pop_2020_CN_100m_R2025A_v1.tif", fixed = TRUE)
  expect_equal(row$delivery, "upstream")
  path <- local_raster_file()
  local_mocked_bindings(.mm_asset_row = function(row, ...) path)
  pop <- mn_population(2025, within = "Uvs")
  expect_equal(names(pop), "population_2025")
})

test_that("mn_zonal() summarises a raster over polygons", {
  path <- local_raster_file(values = \(n) rep(1, n))
  local_mocked_bindings(.mm_asset = function(id, ...) path)
  r <- mn_elevation(mask = FALSE)
  out <- mn_zonal(r, mn_aimags(region = "Western"), fun = "sum", name = "cells")
  expect_true("cells" %in% names(out))
  expect_gt(out$cells[out$pcode == "MN84"], 100)
  expect_equal(mn_zonal(r, mn_aimags(region = "Western"), fun = "mean")$value[out$pcode == "MN84"], 1)
  expect_equal(mn_zonal(r, mn_aimags(region = "Western"), fun = "median")$value[out$pcode == "MN84"], 1)
  expect_snapshot(mn_zonal("r"), error = TRUE)
  expect_snapshot(mn_zonal(r, data.frame(a = 1)), error = TRUE)
})

test_that("mn_protected_areas() downloads, caches and clips", {
  withr::local_options(mongolmaps.cache_dir = withr::local_tempdir())
  geo <- withr::local_tempfile(fileext = ".geojson")
  pa <- sf::st_sf(
    name_eng = c("Khovd park", "UB park"), desig_eng = "National Park",
    geometry = sf::st_buffer(sf::st_sfc(sf::st_point(c(91.65, 48.0)), sf::st_point(c(106.9, 47.9)), crs = 4326), 5000)
  )
  sf::st_write(pa, geo, quiet = TRUE)
  local_mocked_bindings(.mm_asset_row = function(row, ...) geo)
  rlang::reset_message_verbosity("mongolmaps_wdpa_terms")
  expect_snapshot(x <- mn_protected_areas())
  expect_equal(nrow(x), 2)
  expect_equal(mn_protected_areas(within = "Khovd", refresh = FALSE)$name_eng, "Khovd park")
})

test_that("mn_map() draws rasters with the right scale", {
  skip_if_not_installed("ggplot2")
  path <- local_raster_file(values = \(n) sample(c(10, 30, 60), n, replace = TRUE))
  local_mocked_bindings(.mm_asset = function(id, ...) path)
  p <- mn_map(mn_landcover(within = "Khovd"))
  expect_s3_class(p, "ggplot")
  expect_s3_class(p$scales$get_scales("fill"), "ScaleDiscrete")
  expect_match(p$labels$caption, "WorldCover")
  p <- mn_map(mn_elevation(within = "Khovd"), trans = "sqrt")
  expect_s3_class(p$scales$get_scales("fill"), "ScaleContinuous")
  expect_match(p$labels$caption, "Copernicus")
  p <- mn_map(mn_hillshade(within = "Khovd"), caption = FALSE)
  expect_null(p$labels$fill)
  expect_match(sf::st_crs(p$coordinates$crs)$proj4string, "+proj=aea", fixed = TRUE)
  p2 <- suppressMessages(p + ggplot2::geom_sf(data = mn_aimags(), fill = NA))
  expect_s3_class(p2, "ggplot")
})

test_that("10 m land cover is read from cloud tiles for small areas", {
  path <- local_raster_file(values = \(n) sample(c(10, 30), n, replace = TRUE))
  local_mocked_bindings(.mm_remote_mosaic = function(urls, area, name, ...) {
    expect_match(urls, "ESA_WorldCover_10m_2021_v200_N45E105_Map.tif", all = FALSE)
    terra::project(terra::rast(path), "EPSG:4326", method = "near")
  })
  lc <- mn_landcover("10m", within = "MN1104")
  expect_true(terra::is.factor(lc))
  expect_equal(.mm_worldpop_row(2025L, "1km")$file, "mng_pop_2025_CN_1km_R2025A_UA_v1.tif")
})

test_that("mn_map() handles longitude/latitude, large and uncoloured rasters", {
  skip_if_not_installed("ggplot2")
  path <- local_raster_file(values = \(n) sample(c(10, 30), n, replace = TRUE))
  ll <- terra::project(terra::rast(path), "EPSG:4326", method = "near")
  names(ll) <- "population_2025"
  p <- mn_map(ll)
  expect_match(p$labels$caption, "WorldPop")
  expect_s3_class(.mm_map_raster(ll, "identity", NULL, FALSE, NULL, max_cells = 100), "ggplot")
  cat_r <- terra::as.factor(terra::rast(path))
  levels(cat_r) <- data.frame(value = c(10, 30), class = c("Tree cover", "Grassland"))
  expect_s3_class(mn_map(cat_r, caption = FALSE)$scales$get_scales("fill"), "ScaleDiscrete")
  names(cat_r) <- "something"
  expect_null(mn_map(cat_r)$labels$caption)
})
