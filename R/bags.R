#' Bags: the smallest rural units
#'
#' Bags (baga) are the subdivisions of soums; there are about 1,650 of them.
#' Their codes and names are built in (see `mn_codes("bag")`), but **their
#' boundaries are not openly published**: the National Statistics Office of
#' Mongolia (NSO) shares them on request. Once you have a bag boundary file,
#' `mn_bags()` and every other function in the package can use it.
#'
#' @section Getting bag boundaries:
#' Write to NSO (<international@nso.mn>) and ask for the bag boundaries as a
#' shapefile or GeoPackage, with each bag's NSO code. Then either pass the
#' file to `mn_bags(path = ...)`, or register it once per session with
#' `options(mongolmaps.bags_path = "path/to/bags.gpkg")` (put that line in
#' your `.Rprofile` to make it permanent). Registered bags are also returned
#' by `mn_admin("bag")` and used by [mn_join()].
#'
#' `mn_read_bags()` checks the file: every bag must have a known code and
#' sit inside its soum.
#'
#' @param aimag,soum Keep only bags in these aimags or soums (names or
#'   codes).
#' @param path Path to a bag boundary file readable by [sf::st_read()].
#'   Defaults to `getOption("mongolmaps.bags_path")`.
#' @param code_col Name of the column holding bag codes: 7-digit NSO codes
#'   (`"1830151"`) or P-codes (`"MN830151"`). `NULL` detects it.
#' @param check_nesting If `TRUE` (default), stop when a bag lies outside
#'   its soum. Up to `nesting_tolerance` of its area may fall outside the
#'   simplified parent boundary.
#' @param nesting_tolerance Maximum fraction of bag area outside its parent,
#'   from 0 to 1. Defaults to 0.001 (0.1%). Duplicate codes are dissolved.
#' @param resolution Validated for consistency with other getters; the
#'   supplied bag geometry is retained at both settings.
#' @inheritParams mn_admin
#' @return An `sf` tibble; see [mn_admin()] for the columns.
#' @family admin boundaries
#' @export
#' @examples
#' # Codes and names of all bags, without boundaries:
#' mn_codes("bag", within = "Khovd")
#'
#' # Without a bag boundary file, mn_bags() explains how to get one:
#' try(mn_bags())
#'
#' # With the file from NSO (not run, as the file is not public):
#' \dontrun{
#' mn_bags(aimag = "Khovd", path = "bags_from_nso.gpkg")
#' }
mn_bags <- function(aimag = NULL, soum = NULL, path = getOption("mongolmaps.bags_path"),
                    resolution = c("low", "high"), lang = NULL, crs = NULL) {
  .mm_arg_resolution(resolution)
  lang <- .mm_arg_lang(lang)
  if (is.null(path)) {
    .mm_abort(
      c(
        "Bag boundaries are not openly published, so they are not included.",
        "i" = "Ask NSO for them (international@nso.mn), then use {.code mn_bags(path = \"bags.gpkg\")}.",
        "i" = "Bag codes and names are available now: {.code mn_codes(\"bag\")}.",
        "i" = "Khoroos of Ulaanbaatar are available now: {.fn mn_khoroos}."
      ),
      "data_unavailable"
    )
  }
  aimag_targets <- .mm_resolve_within(aimag, levels = c("aimag", "region"), arg = "aimag")
  soum_parent <- if (length(aimag_targets) == 1) unname(aimag_targets)
  soum_targets <- .mm_resolve_within(soum, levels = "soum", parent = soum_parent, arg = "soum")
  targets <- soum_targets %||% aimag_targets
  bags <- .mm_bags_cached(path)
  .mm_finish(bags, targets, lang, crs)
}

#' @rdname mn_bags
#' @export
mn_read_bags <- function(path, code_col = NULL, check_nesting = TRUE, nesting_tolerance = 0.001) {
  .mm_check_string(path)
  if (!is.numeric(nesting_tolerance) || length(nesting_tolerance) != 1 || is.na(nesting_tolerance) ||
        nesting_tolerance < 0 || nesting_tolerance > 1) {
    .mm_abort("{.arg nesting_tolerance} must be a number from 0 to 1.", "input")
  }
  if (!file.exists(path)) {
    .mm_abort("Can't find the bag file {.path {path}}.", "input")
  }
  x <- sf::st_read(path, quiet = TRUE)
  here <- rlang::current_env()
  no_crs <- function(e = NULL) {
    .mm_abort(
      c(
        "The bag file {.path {path}} has no usable coordinate reference system.",
        "i" = "Set one with {.fn sf::st_set_crs} and save the file again."
      ),
      "input",
      parent = e,
      call = here
    )
  }
  x <- tryCatch(suppressWarnings(sf::st_transform(x, 4326)), error = no_crs)
  x <- sf::st_make_valid(x)
  code_col <- code_col %||% .mm_detect_code_col(x)
  if (is.null(code_col) || !code_col %in% names(x)) {
    .mm_abort(
      c(
        "Can't find a column of bag codes in {.path {path}}.",
        "i" = "Bag codes are 7-digit NSO codes ({.val 1830151}) or P-codes ({.val MN830151}).",
        "i" = "Name the column with {.arg code_col}."
      ),
      "input"
    )
  }
  raw <- trimws(as.character(x[[code_col]]))
  pcode <- ifelse(grepl("^[0-9]{7}$", raw), paste0("MN", substring(raw, 2)), toupper(raw))
  bag_codes <- .mm_units$pcode[.mm_units$level == "bag"]
  unknown <- unique(raw[!pcode %in% bag_codes])
  if (length(unknown)) {
    .mm_abort(
      c("{length(unknown)} value{?s} {?is/are} not known NSO bag code{?s} (column {.field {code_col}}):", .mm_bullets(unknown)),
      "input"
    )
  }
  if (any(sf::st_is_empty(x)) || !all(sf::st_geometry_type(x) %in% c("POLYGON", "MULTIPOLYGON"))) {
    .mm_abort("Bag boundaries must be nonempty polygons.", "input")
  }
  geom <- sf::st_sf(pcode = pcode, geometry = sf::st_geometry(x)) |>
    sf::st_transform(.mm_albers) |>
    dplyr::group_by(.data$pcode) |>
    dplyr::summarise(.groups = "drop") |>
    sf::st_cast("MULTIPOLYGON") |>
    sf::st_transform(4326)
  if (check_nesting) .mm_check_bag_nesting(geom, tolerance = nesting_tolerance)
  .mm_tag_bags(geom, path)
}

.mm_detect_code_col <- function(x) {
  bags <- .mm_units[.mm_units$level == "bag", ]
  cols <- setdiff(names(x), attr(x, "sf_column"))
  share <- purrr::map_dbl(cols, function(col) {
    v <- trimws(as.character(x[[col]]))
    mean(v %in% bags$nso_code | toupper(v) %in% bags$pcode)
  })
  if (!length(share) || max(share) < 0.5) {
    return(NULL)
  }
  cols[which.max(share)]
}

.mm_check_bag_nesting <- function(geom, tolerance = 0.001, call = rlang::caller_env()) {
  soum_pcode <- .mm_units$soum_pcode[match(geom$pcode, .mm_units$pcode)]
  soums <- sf::st_transform(.mm_bundled(.mm_low$soum), .mm_albers)
  bags <- sf::st_transform(geom, .mm_albers)
  share <- purrr::map_dbl(seq_len(nrow(bags)), function(i) {
    parent <- soums[soums$pcode %in% soum_pcode[i], ]
    if (!nrow(parent)) return(1)
    outside <- suppressWarnings(sf::st_difference(sf::st_geometry(bags)[i], sf::st_geometry(parent)))
    sum(as.numeric(sf::st_area(outside))) / as.numeric(sf::st_area(bags[i, ]))
  })
  bad <- geom$pcode[!is.finite(share) | share > tolerance]
  if (length(bad)) {
    .mm_abort(
      c(
        "{length(bad)} bag{?s} lie{?s/} outside {?its/their} soum beyond the area tolerance:",
        .mm_bullets(.mm_describe_each(bad)),
        "i" = "Check codes and boundary vintages, or use {.code check_nesting = FALSE}."
      ),
      "input", call = call
    )
  }
  invisible(TRUE)
}

.mm_bags_cached <- function(path) {
  key <- paste0("bags_", normalizePath(path, mustWork = FALSE))
  info <- file.info(path)
  fingerprint <- paste(info$size, as.numeric(info$mtime))
  cached <- .mm_env[[key]]
  if (is.null(cached) || !identical(attr(cached, "file_fingerprint"), fingerprint)) {
    cached <- mn_read_bags(path)
    attr(cached, "file_fingerprint") <- fingerprint
    .mm_env[[key]] <- cached
  }
  cached
}

# Adds registered bags to the khoroo layer for mn_admin("bag").
.mm_add_bags <- function(geom, targets) {
  path <- getOption("mongolmaps.bags_path")
  if (is.null(path)) {
    wants_rural <- is.null(targets) || !all(.mm_in_targets(targets, "MN11"))
    if (wants_rural) {
      cli_inform(
        c(
          "Only Ulaanbaatar khoroos have boundaries at the bag level.",
          "i" = "Rural bag boundaries come from NSO on request; see {.help mongolmaps::mn_bags}."
        ),
        .frequency = "once",
        .frequency_id = "mongolmaps_no_bags",
        class = "mongolmaps_message"
      )
    }
    return(geom)
  }
  bags <- .mm_bags_cached(path)
  out <- rbind(geom, bags[!bags$pcode %in% geom$pcode, names(geom)])
  .mm_set_provenance(out, .mm_combine_provenance(geom, bags))
}
