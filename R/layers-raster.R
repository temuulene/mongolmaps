#' Elevation and hillshade
#'
#' Terrain rasters for Mongolia from the Copernicus DEM GLO-90.
#'
#' * `resolution = "1km"` (default): a national grid in the Albers
#'   projection, downloaded once (about 5 MB) and cached.
#' * `resolution = "90m"`: the original 90 m data, read directly from the
#'   cloud for the area in `within` (an aimag or smaller). Nothing is cached.
#'
#' `mn_hillshade()` computes shaded relief from the elevation, for a
#' background under other layers.
#'
#' @param resolution `"1km"` or `"90m"`.
#' @param within Area to return (names or codes). Required for `"90m"`.
#' @param mask If `TRUE` (default), cells outside Mongolia (or outside
#'   `within`) are set to `NA`.
#' @param angle,direction Sun elevation and direction (degrees) for the
#'   hillshade.
#' @inheritParams mn_admin
#'
#' @return A `terra` SpatRaster: elevation in metres, or hillshade values
#'   between 0 and 1.
#' @section Source:
#' Copernicus DEM GLO-90, (c) DLR e.V. 2010-2014 and (c) Airbus Defence and
#' Space GmbH 2014-2018, provided under COPERNICUS by the European Union and
#' ESA. Free to use with attribution.
#' @family raster layers
#' @export
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet() && rlang::is_installed("terra")
#' elev <- mn_elevation()
#' terra::plot(elev)
#' ub <- mn_elevation("90m", within = "Ulaanbaatar")
#' terra::plot(mn_hillshade(within = "Khovd"), col = grey.colors(100), legend = FALSE)
mn_elevation <- function(resolution = c("1km", "90m"), within = NULL, mask = TRUE, crs = NULL) {
  .mm_need_terra()
  resolution <- rlang::arg_match(resolution)
  if (resolution == "1km") {
    r <- terra::rast(.mm_asset("elevation_1km"))
    names(r) <- "elevation"
    return(.mm_raster_area(r, within, mask, crs))
  }
  targets <- .mm_need_within(within, "90 m elevation")
  area <- .mm_target_geometry(targets)
  bb <- sf::st_bbox(area)
  grid <- expand.grid(lat = floor(bb[["ymin"]]):floor(bb[["ymax"]]), lon = floor(bb[["xmin"]]):floor(bb[["xmax"]]))
  .mm_check_tiles(nrow(grid), 16, "90 m elevation")
  names <- sprintf("Copernicus_DSM_COG_30_N%02d_00_E%03d_00_DEM", grid$lat, grid$lon)
  urls <- sprintf("https://copernicus-dem-90m.s3.amazonaws.com/%s/%s.tif", names, names)
  r <- .mm_remote_mosaic(urls, area, "elevation")
  .mm_raster_area(r, within, mask, crs, targets = targets)
}

#' @rdname mn_elevation
#' @export
mn_hillshade <- function(resolution = c("1km", "90m"), within = NULL, mask = TRUE, angle = 40, direction = 315, crs = NULL) {
  elev <- mn_elevation(resolution, within = within, mask = FALSE, crs = crs)
  slope <- terra::terrain(elev, "slope", unit = "radians")
  aspect <- terra::terrain(elev, "aspect", unit = "radians")
  shade <- terra::shade(slope, aspect, angle = angle, direction = direction)
  names(shade) <- "hillshade"
  if (mask) shade <- .mm_raster_area(shade, within %||% "MN", TRUE, NULL)
  shade
}

#' Land cover
#'
#' Land cover from ESA WorldCover 2021, in 11 classes such as grassland,
#' bare ground, cropland and built-up areas. The result is a categorical
#' raster with class names and the official colours, so `terra::plot()`
#' draws it with a legend.
#'
#' * `resolution = "1km"` (default): national grid, majority class of each
#'   square kilometre, downloaded once (about 2 MB).
#' * `resolution = "10m"`: the original 10 m data for the area in
#'   `within` (a soum, district or smaller aimag), read from the cloud.
#'
#' @param resolution `"1km"` or `"10m"`.
#' @inheritParams mn_elevation
#' @return A categorical `terra` SpatRaster.
#' @section Source:
#' ESA WorldCover 10 m 2021 v200, (c) ESA WorldCover project / contains
#' modified Copernicus Sentinel data (2021) processed by the ESA WorldCover
#' consortium. CC BY 4.0.
#' @family raster layers
#' @export
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet() && rlang::is_installed("terra")
#' lc <- mn_landcover()
#' terra::plot(lc)
#' terra::plot(mn_landcover("10m", within = "Nalaikh"))
mn_landcover <- function(resolution = c("1km", "10m"), within = NULL, mask = TRUE, crs = NULL) {
  .mm_need_terra()
  resolution <- rlang::arg_match(resolution)
  if (resolution == "1km") {
    r <- terra::rast(.mm_asset("landcover_1km"))
    r <- .mm_raster_area(r, within, mask, crs, method = "near")
  } else {
    targets <- .mm_need_within(within, "10 m land cover")
    area <- .mm_target_geometry(targets)
    bb <- sf::st_bbox(area)
    lat <- seq(3 * floor(bb[["ymin"]] / 3), 3 * floor(bb[["ymax"]] / 3), by = 3)
    lon <- seq(3 * floor(bb[["xmin"]] / 3), 3 * floor(bb[["xmax"]] / 3), by = 3)
    grid <- expand.grid(lat = lat, lon = lon)
    .mm_check_area(area, 6000, "10 m land cover")
    urls <- sprintf(
      "https://esa-worldcover.s3.eu-central-1.amazonaws.com/v200/2021/map/ESA_WorldCover_10m_2021_v200_N%02dE%03d_Map.tif",
      grid$lat, grid$lon
    )
    r <- .mm_remote_mosaic(urls, area, "landcover")
    r <- .mm_raster_area(r, within, mask, crs, targets = targets, method = "near")
  }
  .mm_landcover_classes(r)
}

.mm_landcover_legend <- data.frame(
  value = c(10L, 20L, 30L, 40L, 50L, 60L, 70L, 80L, 90L, 95L, 100L),
  class = c(
    "Tree cover", "Shrubland", "Grassland", "Cropland", "Built-up", "Bare / sparse vegetation",
    "Snow and ice", "Permanent water", "Herbaceous wetland", "Mangroves", "Moss and lichen"
  ),
  colour = c(
    "#006400", "#ffbb22", "#ffff4c", "#f096ff", "#fa0000", "#b4b4b4",
    "#f0f0f0", "#0064c8", "#0096a0", "#00cf75", "#fae6a0"
  )
)

.mm_landcover_classes <- function(r) {
  leg <- .mm_landcover_legend
  levels(r) <- leg[c("value", "class")]
  terra::coltab(r) <- data.frame(value = leg$value, col = leg$colour)
  names(r) <- "landcover"
  r
}

#' Population grids
#'
#' Estimated population per grid cell from WorldPop (2015 to 2030, constrained
#' to built-up areas), at 1 km or 100 m. The national file for the year is
#' downloaded once from WorldPop (0.4 MB at 1 km, 11 MB at 100 m) and cached.
#' Use [mn_zonal()] to sum it over aimags, soums or khoroos.
#'
#' @param year A year from 2015 to 2030 (years after the last census are
#'   projections).
#' @param resolution `"1km"` or `"100m"`.
#' @inheritParams mn_elevation
#' @return A `terra` SpatRaster of people per cell.
#' @section Source:
#' WorldPop (www.worldpop.org), Global 2015-2030 constrained population
#' counts, release R2025A. CC BY 4.0.
#' @family raster layers
#' @export
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet() && rlang::is_installed("terra")
#' pop <- mn_population(2025)
#' terra::plot(log10(pop))
#' mn_zonal(pop, mn_aimags())
mn_population <- function(year = 2025, resolution = c("1km", "100m"), within = NULL, mask = TRUE, crs = NULL) {
  .mm_need_terra()
  resolution <- rlang::arg_match(resolution)
  if (!rlang::is_scalar_integerish(year) || year < 2015 || year > 2030) {
    .mm_abort("{.arg year} must be a single year from 2015 to 2030.", "input")
  }
  r <- terra::rast(.mm_asset_row(.mm_worldpop_row(as.integer(year), resolution)))
  names(r) <- paste0("population_", year)
  .mm_raster_area(r, within, mask, crs)
}

.mm_worldpop_row <- function(year, resolution) {
  file <- if (resolution == "1km") {
    sprintf("mng_pop_%d_CN_1km_R2025A_UA_v1.tif", year)
  } else {
    sprintf("mng_pop_%d_CN_100m_R2025A_v1.tif", year)
  }
  folder <- if (resolution == "1km") "1km_ua" else "100m"
  tibble::tibble(
    id = paste0("worldpop_", year, "_", resolution),
    title = paste0("WorldPop population ", year, " (", resolution, ")"),
    delivery = "upstream",
    data_version = "upstream",
    file = file,
    url = sprintf("https://data.worldpop.org/GIS/Population/Global_2015_2030/R2025A/%d/MNG/v1/%s/constrained/%s", year, folder, file),
    fallback_url = NA_character_,
    sha256 = NA_character_,
    bytes = NA_character_
  )
}

#' Protected areas
#'
#' National parks, nature reserves and other protected and conserved areas
#' of Mongolia from the World Database on Protected Areas (WDPA). The data are
#' downloaded from UNEP-WCMC the first time and refreshed after 90 days; they
#' may not be redistributed, so they never ship with the package.
#'
#' @param refresh If `TRUE`, download again now.
#' @inheritParams mn_admin
#' @param within Keep only areas inside these places (names or codes).
#' @return An `sf` tibble with the WDPA attributes, including `name_eng`,
#'   `desig_eng` (designation), `iucn_cat` and `status_yr`.
#' @section Terms of use:
#' UNEP-WCMC and IUCN, Protected Planet: The World Database on Protected
#' Areas (WDPA), Cambridge, UK. See <https://www.protectedplanet.net/en/legal>.
#' The WDPA may be used for non-commercial purposes with attribution; it
#' may not be redistributed.
#' @family thematic layers
#' @export
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' pa <- mn_protected_areas()
#' mn_map(pa, fill = desig_eng)
mn_protected_areas <- function(within = NULL, refresh = FALSE, crs = NULL) {
  row <- .mm_manifest_row("wdpa")
  dest <- file.path(mn_cache_dir(), row$data_version, row$file)
  stale <- !file.exists(dest) || difftime(Sys.time(), file.mtime(dest), units = "days") > 90
  if (refresh || stale) {
    unlink(c(dest, paste0(dest, ".sha256")))
    .mm_inform(
      c("i" = "The WDPA is for non-commercial use with attribution and may not be redistributed; see {.help mongolmaps::mn_protected_areas}."),
      class = "terms",
      .frequency = "once",
      .frequency_id = "mongolmaps_wdpa_terms"
    )
  }
  x <- sf::st_read(.mm_asset_row(row), quiet = TRUE)
  x <- sf::st_make_valid(sf::st_as_sf(tibble::as_tibble(x)))
  sf::st_geometry(x) <- "geometry"
  targets <- .mm_resolve_within(within)
  if (!is.null(targets)) x <- .mm_clip(x, .mm_target_geometry(targets))
  .mm_transform(x, crs)
}

#' Summarise a raster over map units
#'
#' Adds a column to `x` with a summary of the raster cells in each unit, for
#' example the total population of every soum or the mean elevation of every
#' aimag.
#'
#' @param r A `terra` SpatRaster (one layer), such as from [mn_population()].
#' @param x An `sf` object of polygons, such as [mn_soums()]. Defaults to the
#'   aimags.
#' @param fun Summary function name: `"sum"` (default), `"mean"`, `"min"`,
#'   `"max"` or `"median"`.
#' @param name Name of the new column.
#' @return `x` with a new column.
#' @family raster layers
#' @export
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet() && rlang::is_installed("terra")
#' soum_pop <- mn_zonal(mn_population(2025), mn_soums(), name = "population")
#' mn_map(soum_pop, fill = population / area_km2, trans = "log10")
mn_zonal <- function(r, x = NULL, fun = c("sum", "mean", "min", "max", "median"), name = "value") {
  .mm_need_terra()
  fun <- rlang::arg_match(fun)
  x <- x %||% mn_aimags()
  if (!inherits(r, "SpatRaster")) {
    .mm_abort("{.arg r} must be a {.cls SpatRaster}, not {.obj_type_friendly {r}}.", "input")
  }
  if (!inherits(x, "sf")) {
    .mm_abort("{.arg x} must be an {.cls sf} object, not {.obj_type_friendly {x}}.", "input")
  }
  v <- terra::vect(sf::st_transform(x, terra::crs(r)))
  f <- switch(fun,
    sum = sum,
    mean = mean,
    min = min,
    max = max,
    median = stats::median
  )
  vals <- terra::extract(r[[1]], v, fun = f, na.rm = TRUE, ID = FALSE)
  x[[name]] <- vals[[1]]
  x
}

.mm_need_terra <- function(call = rlang::caller_env()) {
  rlang::check_installed("terra", reason = "for raster layers.", call = call)
}

.mm_need_within <- function(within, what, call = rlang::caller_env()) {
  if (is.null(within)) {
    .mm_abort(
      c("{what} is read for one area at a time: give {.arg within}.", "i" = "For the whole country, use {.code resolution = \"1km\"}."),
      "input",
      call = call
    )
  }
  .mm_resolve_within(within, call = call)
}

.mm_check_tiles <- function(n, max, what, call = rlang::caller_env()) {
  if (n > max) {
    .mm_abort(
      c(
        "The area is too large for {what} ({n} tiles; the limit is {max}).",
        "i" = "Choose a smaller {.arg within} or use {.code resolution = \"1km\"}."
      ),
      "input",
      call = call
    )
  }
}

.mm_check_area <- function(area, max_km2, what, call = rlang::caller_env()) {
  km2 <- sum(as.numeric(sf::st_area(sf::st_transform(sf::st_as_sf(area), .mm_albers)))) / 1e6
  if (km2 > max_km2) {
    .mm_abort(
      c(
        "The area is too large for {what} ({round(km2)} km2; the limit is {max_km2} km2).",
        "i" = "Choose a soum or district for {.arg within}, or use {.code resolution = \"1km\"}."
      ),
      "input",
      call = call
    )
  }
}

# Reads cloud-optimised GeoTIFFs over HTTP, cropped to `area`.
.mm_remote_mosaic <- function(urls, area, name, call = rlang::caller_env()) {
  if (isTRUE(getOption("mongolmaps.offline", FALSE)) || !curl::has_internet()) {
    .mm_abort("Can't read {name} data: no internet connection or offline mode is on.", "offline", call = call)
  }
  old <- terra::getGDALconfig(c("GDAL_DISABLE_READDIR_ON_OPEN", "GDAL_HTTP_MULTIRANGE"))
  terra::setGDALconfig("GDAL_DISABLE_READDIR_ON_OPEN", "EMPTY_DIR")
  terra::setGDALconfig("GDAL_HTTP_MULTIRANGE", "YES")
  on.exit({
    terra::setGDALconfig("GDAL_DISABLE_READDIR_ON_OPEN", old[[1]])
    terra::setGDALconfig("GDAL_HTTP_MULTIRANGE", old[[2]])
  })
  sources <- paste0("/vsicurl/", urls)
  ok <- purrr::map_lgl(sources, \(u) !inherits(try(terra::rast(u), silent = TRUE), "try-error"))
  if (!any(ok)) {
    .mm_abort("Can't reach the {name} data online.", "http", call = call)
  }
  r <- terra::vrt(sources[ok])
  r <- terra::crop(r, terra::ext(sf::st_bbox(area)[c("xmin", "xmax", "ymin", "ymax")]))
  names(r) <- name
  r
}

# Crops and masks a raster to Mongolia or `within`, then projects it.
.mm_raster_area <- function(r, within, mask, crs, targets = NULL, method = "bilinear", call = rlang::caller_env()) {
  targets <- targets %||% .mm_resolve_within(within, call = call)
  area <- if (!is.null(targets)) .mm_target_geometry(targets, call = call) else if (mask) sf::st_geometry(mn_country())
  if (!is.null(area)) {
    v <- terra::vect(sf::st_transform(sf::st_as_sf(area), terra::crs(r)))
    r <- terra::crop(r, v, snap = "out")
    if (mask) r <- terra::mask(r, v)
  }
  crs <- .mm_resolve_crs(crs, call = call)
  if (!is.null(crs)) r <- terra::project(r, crs$wkt, method = method)
  r
}
