#' Remove water from display geometry
#'
#' Return a new polygon layer with water removed. The input object and its
#' `area_km2` field are unchanged; `land_area_km2` describes the new
#' geometry. Land area is not inhabited area. Water source/resolution affects
#' this cartographic operation and any land-only density interpretation.
#'
#' @param x An sf polygon object.
#' @param water An sf polygon water layer, defaulting to [mn_lakes()].
#' @param min_area_km2 Ignore water polygons smaller than this area.
#' @return An sf object with `land_area_km2`, preserving one row per input
#'   unit, including empty geometry for entirely water-covered units.
#' @family mapping helpers
#' @export
#' @examples
#' land <- mn_erase_water(mn_aimags())
#' head(land$land_area_km2)
mn_erase_water <- function(x, water = NULL, min_area_km2 = 0) {
  .mm_check_inset_data(x)
  water <- water %||% mn_lakes()
  .mm_check_inset_data(water)
  if (!is.numeric(min_area_km2) || length(min_area_km2) != 1 ||
        !is.finite(min_area_km2) || min_area_km2 < 0) {
    .mm_abort("{.arg min_area_km2} must be a nonnegative number.", "input")
  }
  crs <- sf::st_crs(x)
  area <- sf::st_transform(sf::st_make_valid(x), .mm_albers)
  wet <- sf::st_transform(sf::st_make_valid(water), .mm_albers)
  wet <- wet[as.numeric(sf::st_area(wet)) / 1e6 >= min_area_km2, ]
  if (nrow(wet)) {
    wet <- wet[lengths(sf::st_intersects(wet, area)) > 0, ]
    if (nrow(wet)) {
      mask <- sf::st_union(sf::st_geometry(wet))
      geom <- lapply(sf::st_geometry(area), function(g) {
        d <- suppressWarnings(sf::st_difference(sf::st_sfc(g, crs = sf::st_crs(area)), mask))
        if (!length(d) || all(sf::st_is_empty(d))) return(sf::st_multipolygon())
        sf::st_cast(d, "MULTIPOLYGON")[[1]]
      })
      sf::st_geometry(area) <- sf::st_sfc(geom, crs = sf::st_crs(area))
    }
  }
  area$land_area_km2 <- as.numeric(sf::st_area(area)) / 1e6
  .mm_set_provenance(sf::st_transform(area, crs), .mm_combine_provenance(x, water))
}
