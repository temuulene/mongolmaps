#' Mongolia and its economic regions
#'
#' `mn_country()` returns the outline of Mongolia. `mn_regions()` returns the
#' five economic regions used in NSO statistics: Western, Khangai, Central,
#' Eastern and Ulaanbaatar.
#'
#' @inheritParams mn_admin
#' @return An `sf` tibble; see [mn_admin()] for the columns.
#' @family admin boundaries
#' @export
#' @examples
#' mn_country()
#' mn_regions()
mn_country <- function(resolution = c("low", "high"), lang = NULL, crs = NULL) {
  mn_admin("country", resolution = resolution, lang = lang, crs = crs)
}

#' @rdname mn_country
#' @export
mn_regions <- function(resolution = c("low", "high"), lang = NULL, crs = NULL) {
  mn_admin("region", resolution = resolution, lang = lang, crs = crs)
}

#' Aimags (provinces) of Mongolia
#'
#' Returns the 21 aimags and the capital, Ulaanbaatar, which has aimag
#' status (`type = "capital"`).
#'
#' @param region Keep only aimags in these economic regions, such as
#'   `"Western"` or `"Khangai region"`. You can also name aimags here to
#'   select them directly.
#' @inheritParams mn_admin
#' @return An `sf` tibble; see [mn_admin()] for the columns.
#' @family admin boundaries
#' @export
#' @examples
#' aimags <- mn_aimags()
#' aimags
#' mn_aimags(region = "Western")
#' mn_aimags(lang = "mn")
mn_aimags <- function(region = NULL, resolution = c("low", "high"), lang = NULL, crs = NULL) {
  mn_admin("aimag", within = region, resolution = resolution, lang = lang, crs = crs)
}

#' Soums of Mongolia and districts of Ulaanbaatar
#'
#' Returns the 330 soums (rural districts) together with the 9 districts
#' (duureg) of Ulaanbaatar, which sit at the same level (`type` is
#' `"soum"` or `"district"`).
#'
#' @param aimag Keep only soums in these aimags (names or codes).
#' @inheritParams mn_admin
#' @return An `sf` tibble; see [mn_admin()] for the columns.
#' @family admin boundaries
#' @export
#' @examples
#' mn_soums()
#' mn_soums(aimag = "Khovd")
#' mn_soums(aimag = c("Uvs", "Zavkhan"), lang = "mn")
mn_soums <- function(aimag = NULL, resolution = c("low", "high"), lang = NULL, crs = NULL) {
  targets <- .mm_resolve_within(aimag, levels = c("aimag", "region", "country"), arg = "aimag")
  resolution <- .mm_arg_resolution(resolution)
  .mm_finish(.mm_geom("soum", resolution), targets, .mm_arg_lang(lang), crs)
}

#' Ulaanbaatar: city, districts and khoroos
#'
#' Maps of the capital at three levels:
#' * `mn_ub()`: the city boundary;
#' * `mn_ub_districts()`: its 9 districts (duureg);
#' * `mn_khoroos()`: its 204 khoroos (subdistricts).
#'
#' The three layers share borders exactly: khoroos tile their districts and
#' districts tile the city.
#'
#' @section Data source:
#' Khoroo boundaries come from the open khoroo-map project
#' (<https://github.com/Tuvshin-Level/khoroo-map>, 0BSD licence), which does
#' not state where its data come from, so treat them as **unofficial**.
#' They were fitted to the official Ulaanbaatar outline, with small gaps and
#' overlaps between khoroos resolved: 0.6% of the city area was reassigned,
#' and 97% of khoroos changed area by less than 1%. Khoroo codes and names
#' follow NSO.
#'
#' The district lines are the unions of their khoroos. They follow the
#' current city layout and can differ slightly from the 2020 district lines
#' in [mn_soums()].
#'
#' @param district Keep only khoroos in these districts (names or codes,
#'   such as `"Bayangol"`, `"BGD"` or `"MN1107"`).
#' @inheritParams mn_admin
#' @return An `sf` tibble; see [mn_admin()] for the columns. For khoroos,
#'   `number` holds the khoroo number within its district.
#' @family admin boundaries
#' @export
#' @examples
#' mn_ub()
#' mn_ub_districts()
#' mn_khoroos(district = "Bayangol")
#' mn_khoroos(lang = "mn", crs = "utm")
mn_ub <- function(resolution = c("low", "high"), lang = NULL, crs = NULL) {
  resolution <- .mm_arg_resolution(resolution)
  .mm_finish(.mm_geom("ub", resolution), NULL, .mm_arg_lang(lang), crs)
}

#' @rdname mn_ub
#' @export
mn_ub_districts <- function(resolution = c("low", "high"), lang = NULL, crs = NULL) {
  resolution <- .mm_arg_resolution(resolution)
  .mm_finish(.mm_geom("ub_district", resolution), NULL, .mm_arg_lang(lang), crs)
}

#' @rdname mn_ub
#' @export
mn_khoroos <- function(district = NULL, resolution = c("low", "high"), lang = NULL, crs = NULL) {
  targets <- .mm_resolve_within(district, levels = "soum", parent = "MN11", arg = "district")
  resolution <- .mm_arg_resolution(resolution)
  .mm_finish(.mm_geom("khoroo", resolution), targets, .mm_arg_lang(lang), crs)
}
