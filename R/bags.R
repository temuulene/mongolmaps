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
#'   its soum.
#' @inheritParams mn_admin
#' @return An `sf` tibble; see [mn_admin()] for the columns.
#' @family admin boundaries
#' @export
#' @examples
#' # Codes and names of all bags, without boundaries:
#' mn_codes("bag", within = "Khovd")
#'
#' \dontrun{
#' bags <- mn_bags(path = "bags_from_nso.gpkg")
#' options(mongolmaps.bags_path = "bags_from_nso.gpkg")
#' mn_bags(aimag = "Khovd")
#' }
mn_bags <- function(aimag = NULL, soum = NULL, path = getOption("mongolmaps.bags_path"),
                    resolution = c("low", "high"), lang = NULL, crs = NULL) {
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
mn_read_bags <- function(path, code_col = NULL, check_nesting = TRUE) {
  .mm_check_string(path)
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
  geom <- sf::st_sf(pcode = pcode, geometry = sf::st_cast(sf::st_geometry(x), "MULTIPOLYGON"))
  geom <- geom[!duplicated(geom$pcode), ]
  if (check_nesting) .mm_check_bag_nesting(geom)
  geom
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

.mm_check_bag_nesting <- function(geom, call = rlang::caller_env()) {
  soum_pcode <- .mm_units$soum_pcode[match(geom$pcode, .mm_units$pcode)]
  soums <- .mm_low$soum
  pts <- suppressWarnings(sf::st_point_on_surface(sf::st_geometry(geom)))
  poly <- sf::st_geometry(soums)[match(soum_pcode, soums$pcode)]
  has_poly <- !is.na(match(soum_pcode, soums$pcode))
  inside <- rep(TRUE, length(pts))
  inside[has_poly] <- purrr::map_lgl(which(has_poly), \(i) lengths(sf::st_intersects(pts[i], poly[i])) > 0)
  if (!all(inside)) {
    bad <- geom$pcode[!inside]
    .mm_abort(
      c(
        "{length(bad)} bag{?s} lie{?s/} outside {?its/their} soum:",
        .mm_bullets(.mm_describe_each(bad)),
        "i" = "Check the codes, or skip this check with {.code check_nesting = FALSE}."
      ),
      "input",
      call = call
    )
  }
  invisible(TRUE)
}

.mm_bags_cached <- function(path) {
  key <- paste0("bags_", normalizePath(path, mustWork = FALSE))
  if (is.null(.mm_env[[key]])) {
    .mm_env[[key]] <- mn_read_bags(path)
  }
  .mm_env[[key]]
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
  rbind(geom, bags[!bags$pcode %in% geom$pcode, names(geom)])
}
