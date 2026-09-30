#' Settlements: the capital, aimag centres and soum centres
#'
#' Points for Ulaanbaatar, the 21 aimag centres and the soum centres, handy
#' for labelling maps. Locations come from Wikidata; a few soums without
#' coordinates there use a point inside the soum (see `location_source`).
#'
#' @param type Which settlements to return: any of `"capital"`,
#'   `"aimag_centre"` and `"soum_centre"`. By default, all.
#' @param within Keep only settlements inside these places (names or
#'   codes).
#' @inheritParams mn_admin
#' @return An `sf` tibble of points with columns `admin_pcode` (the aimag
#'   or soum the settlement is the centre of), `soum_pcode`, `aimag_pcode`,
#'   `type`, `name`, `name_en`, `name_mn`, `name_mns` and `location_source`.
#' @family thematic layers
#' @export
#' @examples
#' mn_settlements(type = c("capital", "aimag_centre"))
#' mn_settlements(within = "Khovd")
mn_settlements <- function(type = c("capital", "aimag_centre", "soum_centre"), within = NULL, lang = NULL, crs = NULL) {
  type <- rlang::arg_match(type, multiple = TRUE)
  lang <- .mm_arg_lang(lang)
  targets <- .mm_resolve_within(within)
  x <- .mm_bundled(.mm_settlements[.mm_settlements$type %in% type, ])
  if (!is.null(targets)) {
    x <- x[.mm_in_targets(x$admin_pcode, targets) | .mm_in_targets(x$soum_pcode, targets), ]
  }
  x$name <- .mm_name_for_lang(x, lang)
  x <- x[c("admin_pcode", "soum_pcode", "aimag_pcode", "type", "name", "name_en", "name_mn", "name_mns", "location_source", "geometry")]
  .mm_transform(x, crs)
}

#' Map context: neighbouring countries, rivers and lakes
#'
#' Layers that give a map of Mongolia its surroundings and water.
#'
#' * `mn_neighbours()`: the neighbouring parts of Russia, China and
#'   Kazakhstan (Natural Earth, public domain), clipped to a frame 300 km
#'   around Mongolia.
#' * `mn_rivers()` and `mn_lakes()`: with `detail = "major"` (default),
#'   major rivers and lakes from Natural Earth, bundled with the package.
#'   With `detail = "all"`, every river, stream, canal and water body mapped
#'   in OpenStreetMap (ODbL), downloaded once (about 20 MB) and cached.
#'
#' @param detail `"major"` for the main rivers and lakes (bundled), or
#'   `"all"` for everything in OpenStreetMap (downloaded).
#' @param within Keep only features inside these places (names or codes).
#' @inheritParams mn_admin
#' @return An `sf` tibble. Natural Earth layers have `name_en` and
#'   `scalerank` (lower is more important). OpenStreetMap layers have
#'   `osm_id`, `name`, `name_en`, `name_mn` and `class` (for example
#'   `"river"`, `"stream"`, `"lake"` or `"reservoir"`).
#' @family thematic layers
#' @export
#' @examples
#' mn_neighbours()
#' mn_rivers()
#' mn_lakes(within = "Khuvsgul")
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' mn_rivers(detail = "all", within = "Ulaanbaatar")
mn_neighbours <- function(crs = NULL) {
  .mm_transform(.mm_bundled(.mm_context$neighbours), crs)
}

#' @rdname mn_neighbours
#' @export
mn_rivers <- function(detail = c("major", "all"), within = NULL, crs = NULL) {
  detail <- rlang::arg_match(detail)
  if (detail == "all") {
    return(.mm_osm_read("osm_water", "waterways", within = within, crs = crs))
  }
  .mm_context_layer(.mm_bundled(.mm_context$rivers), within, crs)
}

#' @rdname mn_neighbours
#' @export
mn_lakes <- function(detail = c("major", "all"), within = NULL, crs = NULL) {
  detail <- rlang::arg_match(detail)
  if (detail == "all") {
    return(.mm_osm_read("osm_water", "water", within = within, crs = crs))
  }
  .mm_context_layer(.mm_bundled(.mm_context$lakes), within, crs)
}

.mm_context_layer <- function(x, within, crs, call = rlang::caller_env()) {
  targets <- .mm_resolve_within(within, call = call)
  if (!is.null(targets)) {
    x <- .mm_clip(x, .mm_target_geometry(targets, call = call))
  }
  .mm_transform(x, crs, call = call)
}
