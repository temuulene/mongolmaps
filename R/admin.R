#' Administrative boundaries of Mongolia at any level
#'
#' The engine behind [mn_country()], [mn_regions()], [mn_aimags()],
#' [mn_soums()], [mn_khoroos()] and [mn_bags()]. Every function returns the
#' same columns, so maps from different levels can be combined and joined
#' in the same way.
#'
#' @param level The level to return:
#'   * `"country"`: Mongolia.
#'   * `"region"`: the five economic regions used by NSO (Western, Khangai,
#'     Central, Eastern, Ulaanbaatar).
#'   * `"aimag"`: the 21 aimags (provinces) and the capital, Ulaanbaatar.
#'   * `"soum"`: the 330 soums and the 9 districts (duureg) of Ulaanbaatar.
#'   * `"bag"`: the 204 khoroos of Ulaanbaatar, plus rural bags if you have
#'     registered a bag boundary file (see [mn_bags()]).
#'
#'   Synonyms such as `"province"`, `"district"`, `"adm1"` or `"khoroo"`
#'   also work.
#' @param within Keep only units inside these places, or these places
#'   themselves: names or codes of any level, such as `"Khovd"`, `"MN84"` or
#'   `"Western region"`.
#' @param resolution `"low"` (default) uses simplified boundaries that ship
#'   with the package and suit most maps. `"high"` uses full-resolution
#'   boundaries, downloaded once (about 10 MB) and cached; see
#'   [mn_cache_dir()].
#' @param lang Language of the `name` column: `"en"` (English, as in NSO
#'   tables), `"mn"` (Cyrillic) or `"mns"` (Latin with diacritics, MNS
#'   5217). Defaults to `getOption("mongolmaps.lang", "en")`.
#' @param crs Coordinate reference system of the result. `NULL` (default)
#'   keeps longitude/latitude (EPSG:4326). Use `"albers"`, `"lcc"` or
#'   `"utm"` for a projection suited to Mongolia (see [mn_crs()]), or any
#'   value accepted by [sf::st_crs()].
#'
#' @return An `sf` tibble with one row per unit and the columns:
#'   \describe{
#'     \item{pcode}{Unique code (see [mn_codes()]).}
#'     \item{name}{Name in the language chosen with `lang`.}
#'     \item{name_en, name_mn, name_mns}{English, Cyrillic and MNS
#'       Latin names.}
#'     \item{level, type}{Level (`"aimag"`, `"soum"`, ...) and type
#'       (`"capital"`, `"district"`, `"khoroo"`, ...).}
#'     \item{number}{Bag or khoroo number within its soum or district.}
#'     \item{iso_code}{ISO 3166-2 code (aimags only).}
#'     \item{nso_code}{Code used in NSO statistical tables.}
#'     \item{parent_pcode, region_pcode, aimag_pcode, soum_pcode}{Codes of
#'       the units that contain this one.}
#'     \item{area_km2}{Area in square kilometres, computed from the
#'       full-resolution boundary.}
#'     \item{geometry}{Multipolygon boundary.}
#'   }
#' @family admin boundaries
#' @export
#' @examples
#' mn_admin("aimag")
#' mn_admin("soum", within = "Khovd")
#' mn_admin("aimag", within = c("Khovd", "Uvs"), lang = "mn")
mn_admin <- function(level = "aimag", within = NULL, resolution = c("low", "high"), lang = NULL, crs = NULL) {
  level <- .mm_arg_level(level)
  resolution <- .mm_arg_resolution(resolution)
  lang <- .mm_arg_lang(lang)
  targets <- .mm_resolve_within(within)
  layer <- c(country = "country", region = "region", aimag = "aimag", soum = "soum", bag = "khoroo")[[level]]
  geom <- .mm_geom(layer, resolution)
  if (level == "bag") {
    geom <- .mm_add_bags(geom, targets)
  }
  .mm_finish(geom, targets, lang, crs)
}

# Filters by `targets`, attaches attributes and projects.
.mm_finish <- function(geom, targets, lang, crs, units = .mm_units, call = rlang::caller_env()) {
  if (!is.null(targets)) {
    geom <- geom[.mm_in_targets(geom$pcode, targets, units = units), ]
  }
  out <- .mm_as_mn_sf(geom, lang, units = units)
  .mm_transform(out, crs, call = call)
}

.mm_geom <- function(layer, resolution) {
  if (resolution == "low") {
    return(.mm_low[[layer]])
  }
  .mm_high_layer(layer)
}

.mm_env <- new.env(parent = emptyenv())

.mm_high_layer <- function(layer) {
  key <- paste0("high_", layer)
  if (is.null(.mm_env[[key]])) {
    path <- .mm_asset("admin_high")
    x <- sf::st_read(path, layer = layer, quiet = TRUE)
    x <- sf::st_set_geometry(x, "geometry")
    .mm_env[[key]] <- x[c("pcode", "geometry")]
  }
  .mm_env[[key]]
}
