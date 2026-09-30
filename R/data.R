#' Mid-year resident population of Mongolia (example data)
#'
#' Population by administrative unit for 2015, 2020 and 2025, exactly as
#' returned by the National Statistics Office (NSO) table
#' DT_NSO_0300_002V4 via the \pkg{mongolstats} package. The `Region` column
#' mixes levels (national total, regions, aimags, soums, bags and khoroos),
#' as NSO tables do, which makes it a good example for [mn_join()].
#'
#' @format A data frame with 6,672 rows and 4 columns:
#' \describe{
#'   \item{Region}{NSO unit code, such as `"0"` (Mongolia), `"183"`
#'     (Bayan-Ulgii), `"18301"` (Ulgii soum) or `"5110751"` (Bayangol
#'     district, 1st khoroo).}
#'   \item{Region_en}{English label of the unit.}
#'   \item{Year}{Year.}
#'   \item{value}{Mid-year resident population.}
#' }
#' @source National Statistics Office of Mongolia,
#'   <https://data.1212.mn/pxweb/>, retrieved 2026-09-29.
#' @family joining data
#' @examples
#' head(mn_example_population)
"mn_example_population"

#' A grid layout of the aimags for small-multiple maps
#'
#' Positions of the 21 aimags and Ulaanbaatar on a 4-by-9 grid that keeps
#' their rough geographic arrangement, in the format used by the
#' \pkg{geofacet} package.
#'
#' @format A data frame with 22 rows and 4 columns: `row`, `col`, `code`
#'   (the aimag pcode) and `name` (English name).
#' @family mapping helpers
#' @examplesIf rlang::is_installed(c("geofacet", "ggplot2"))
#' library(ggplot2)
#' pop <- mn_example_population[nchar(mn_example_population$Region) == 3, ]
#' pop$code <- mn_match(pop$Region)
#' ggplot(pop, aes(Year, value / 1000)) +
#'   geom_line() +
#'   geofacet::facet_geo(~code, grid = mn_aimag_grid, label = "name") +
#'   labs(y = "Population (thousands)")
"mn_aimag_grid"
