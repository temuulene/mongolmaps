#' Codes and names of Mongolian administrative units
#'
#' Returns the table behind every map in the package: one row per unit, from
#' the country down to bags and khoroos, with its codes, names and place in
#' the hierarchy. Use it to look up codes, to build your own crosswalks, or
#' to see which units have a boundary.
#'
#' @details
#' Units are identified by `pcode`, a code that is unique across levels:
#'
#' * `"MN"` for the country, `"MNR1"` to `"MNR5"` for the economic regions
#'   (Western, Khangai, Central, Eastern, Ulaanbaatar);
#' * `"MN"` + the two-digit NSO aimag code for aimags (`"MN84"` Khovd,
#'   `"MN11"` Ulaanbaatar);
#' * two more digits for soums and Ulaanbaatar districts (`"MN8401"`), and
#'   two more for bags and khoroos (`"MN110751"`).
#'
#' These match the P-codes of the humanitarian Common Operational Dataset
#' and are the NSO statistical codes without their leading region digit
#' (`nso_code`, as used in NSO PXWeb tables).
#'
#' The `type` column separates units that share a level: `"capital"`
#' (Ulaanbaatar) among aimags; `"district"` and `"village"` among soums;
#' `"khoroo"` among bags. Villages (tosgon) and rural bags have codes and
#' statistics but no boundary (`has_geometry` is `FALSE`).
#'
#' @param level Levels to return (see [mn_match()]); `NULL` returns all.
#' @param within Keep only units inside this parent (a name or code).
#' @param aliases If `TRUE`, return one row per known spelling of each unit
#'   (the table used by [mn_match()]) instead of one row per unit.
#' @param lang Language of the `name` column: `"en"` (English, as in NSO
#'   tables), `"mn"` (Cyrillic) or `"mns"` (Latin with diacritics). Defaults
#'   to `getOption("mongolmaps.lang", "en")`.
#'
#' @return A tibble. With `aliases = FALSE`: the columns of every admin map
#'   (see [mn_admin()]) plus `has_geometry`. With `aliases = TRUE`: `pcode`,
#'   `level`, `name_en`, `alias` and `source`.
#' @family names and codes
#' @export
#' @examples
#' mn_codes("aimag")
#' mn_codes("soum", within = "Khovd")
#' mn_codes("aimag", aliases = TRUE)
mn_codes <- function(level = NULL, within = NULL, aliases = FALSE, lang = NULL) {
  levels <- .mm_arg_level(level, multiple = TRUE)
  lang <- .mm_arg_lang(lang)
  u <- .mm_units
  if (!is.null(levels)) u <- u[u$level %in% levels, ]
  if (!is.null(within)) {
    targets <- .mm_resolve_within(within)
    u <- u[.mm_in_targets(u$pcode, targets, include_self = FALSE), ]
  }
  if (aliases) {
    a <- .mm_aliases[.mm_aliases$pcode %in% u$pcode, c("pcode", "level", "alias", "source")]
    a$name_en <- u$name_en[match(a$pcode, u$pcode)]
    return(tibble::as_tibble(a[c("pcode", "level", "name_en", "alias", "source")]))
  }
  u$name <- .mm_name_for_lang(u, lang)
  tibble::as_tibble(u[c(.mm_schema, "has_geometry")])
}
