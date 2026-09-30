#' Roads, railways, airports and places from OpenStreetMap
#'
#' Transport and settlement layers from OpenStreetMap, prepared from the
#' Humanitarian OpenStreetMap Team exports. Each layer is downloaded once
#' (roads about 30 MB, the others smaller) and cached; see [mn_download()].
#'
#' Use `within` to get a layer for one place: only the features in that
#' place's bounding box are read from disk, then lines are cut at its
#' border.
#'
#' @param class Road classes to keep: `"main"` (motorways to tertiary
#'   roads, the default), `"minor"` (residential, service and unclassified
#'   streets), `"track"`, `"path"`, or `"all"`.
#' @param within Keep only features inside these places (names or codes of
#'   any level with a boundary, such as `"Ulaanbaatar"` or `"Khovd"`).
#' @param stations If `TRUE`, `mn_railways()` returns railway stations as
#'   points instead of the lines.
#' @param type Place types for `mn_places()`: any of `"city"`, `"town"`,
#'   `"village"`, `"hamlet"`, `"suburb"` and `"isolated_dwelling"`.
#' @inheritParams mn_admin
#'
#' @return An `sf` tibble with `osm_id`, `name` (in the chosen language,
#'   where OpenStreetMap has it), `name_en`, `name_mn` and layer-specific
#'   columns: `highway`, `class` and `surface` for roads; `railway` for
#'   railways; `place` and `population` for places.
#' @section Licence:
#' OpenStreetMap data are available under the Open Database Licence (ODbL).
#' Credit "(c) OpenStreetMap contributors" when you publish maps;
#' `mn_citation("osm_roads")` gives the text.
#' @family thematic layers
#' @export
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' ub_roads <- mn_roads(class = c("main", "minor"), within = "Ulaanbaatar")
#' mn_railways()
#' mn_airports()
#' mn_places(within = "Khovd")
mn_roads <- function(class = "main", within = NULL, crs = NULL) {
  class <- rlang::arg_match(class, c("main", "minor", "track", "path", "all"), multiple = TRUE)
  where <- if (!"all" %in% class) sprintf("class IN (%s)", paste0("'", class, "'", collapse = ", "))
  .mm_osm_read("osm_roads", "roads", where = where, within = within, crs = crs)
}

#' @rdname mn_roads
#' @export
mn_railways <- function(stations = FALSE, within = NULL, crs = NULL) {
  .mm_osm_read("osm_transport", if (isTRUE(stations)) "stations" else "railways", within = within, crs = crs)
}

#' @rdname mn_roads
#' @export
mn_airports <- function(within = NULL, crs = NULL) {
  .mm_osm_read("osm_transport", "airports", within = within, crs = crs)
}

#' @rdname mn_roads
#' @export
mn_places <- function(type = c("city", "town", "village"), within = NULL, lang = NULL, crs = NULL) {
  type <- rlang::arg_match(type, c("city", "town", "village", "hamlet", "suburb", "isolated_dwelling"), multiple = TRUE)
  lang <- .mm_arg_lang(lang)
  where <- sprintf("place IN (%s)", paste0("'", type, "'", collapse = ", "))
  x <- .mm_osm_read("osm_places", "places", where = where, within = within, crs = crs)
  x$name <- switch(lang,
    en = x$name_en,
    mn = x$name_mn,
    mns = ifelse(is.na(x$name_mn), x$name_en, mn_translit(x$name_mn, "mns"))
  )
  x[c("osm_id", "name", setdiff(names(x), c("osm_id", "name")))]
}

# Reads one layer of an OSM asset, optionally limited to places.
.mm_osm_read <- function(id, layer, where = NULL, within = NULL, crs = NULL, call = rlang::caller_env()) {
  targets <- .mm_resolve_within(within, call = call)
  path <- .mm_asset(id, call = call)
  query <- if (!is.null(where)) sprintf("SELECT * FROM \"%s\" WHERE %s", layer, where)
  area <- if (!is.null(targets)) .mm_target_geometry(targets, call = call)
  wkt <- if (!is.null(area)) sf::st_as_text(sf::st_as_sfc(sf::st_bbox(area))) else character(0)
  x <- if (is.null(query)) {
    sf::st_read(path, layer = layer, wkt_filter = wkt, quiet = TRUE)
  } else {
    sf::st_read(path, query = query, wkt_filter = wkt, quiet = TRUE)
  }
  if (!is.null(area)) x <- .mm_clip(x, area)
  x <- sf::st_as_sf(tibble::as_tibble(x))
  sf::st_geometry(x) <- "geometry"
  x$name <- x$name_en
  x <- x[c("osm_id", "name", setdiff(names(x), c("osm_id", "name")))]
  .mm_transform(x, crs, call = call)
}

# The union of the (simplified) boundaries of `targets`.
.mm_target_geometry <- function(targets, call = rlang::caller_env()) {
  u <- .mm_units[match(targets, .mm_units$pcode), ]
  layer <- c(country = "country", region = "region", aimag = "aimag", soum = "soum", bag = "khoroo")[u$level]
  geoms <- purrr::map2(targets, layer, function(p, l) {
    g <- .mm_bundled(.mm_low[[l]])
    sf::st_geometry(g)[g$pcode == p]
  })
  geoms <- geoms[lengths(geoms) > 0]
  if (!length(geoms)) {
    .mm_abort("{.arg within} names places without a boundary: {.val {targets}}.", "input", call = call)
  }
  sf::st_union(do.call(c, geoms))
}

# Keeps the features of `x` inside `area`: points by filtering, lines and
# polygons by cutting at the border (keeping one geometry type).
.mm_clip <- function(x, area) {
  types <- unique(as.character(sf::st_geometry_type(x)))
  if (all(types %in% "POINT")) {
    return(x[lengths(sf::st_intersects(x, area)) > 0, ])
  }
  base <- if (any(grepl("POLYGON", types))) "POLYGON" else "LINESTRING"
  x <- suppressWarnings(sf::st_intersection(x, area))
  x <- suppressWarnings(sf::st_collection_extract(x, base))
  sf::st_cast(x, paste0("MULTI", base))
}
