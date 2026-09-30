#' Interactive maps with leaflet
#'
#' Shows any map from this package, or your joined data, on an interactive
#' web map with a basemap, hover labels and click pop-ups.
#'
#' @param x An `sf` object; defaults to the aimags.
#' @param fill Column to colour by (unquoted), or a single colour.
#' @param popup Column with pop-up text (unquoted). By default the pop-up
#'   shows the English and Mongolian names, the code and the `fill` value.
#' @param lang Language of the hover labels: `"en"`, `"mn"` or `"mns"`.
#' @param tiles A basemap from [leaflet::providers], such as
#'   `"CartoDB.Positron"` (default) or `"OpenStreetMap"`.
#' @param opacity Fill opacity between 0 and 1.
#'
#' @return A `leaflet` htmlwidget.
#' @family mapping helpers
#' @export
#' @examplesIf rlang::is_installed("leaflet")
#' mn_leaflet()
#' mn_leaflet(mn_khoroos(), fill = area_km2)
mn_leaflet <- function(x = NULL, fill = NULL, popup = NULL, lang = NULL, tiles = "CartoDB.Positron", opacity = 0.7) {
  rlang::check_installed("leaflet", reason = "to draw interactive maps with `mn_leaflet()`.")
  lang <- .mm_arg_lang(lang)
  x <- x %||% mn_aimags(lang = lang)
  if (!inherits(x, "sf")) {
    .mm_abort("{.arg x} must be an {.cls sf} object, not {.obj_type_friendly {x}}.", "input")
  }
  x <- sf::st_transform(x, 4326)
  df <- sf::st_drop_geometry(x)

  labels <- if (all(c("name_en", "name_mn", "name_mns") %in% names(df))) .mm_name_for_lang(df, lang) else df[["name"]]
  labels <- labels %||% rep("", nrow(df))

  fill_q <- rlang::enquo(fill)
  colour <- rep("#3182bd", nrow(df))
  pal <- NULL
  values <- NULL
  if (!rlang::quo_is_null(fill_q)) {
    expr <- rlang::quo_get_expr(fill_q)
    if (is.character(expr) && length(expr) == 1 && !expr %in% names(df)) {
      colour <- rep(expr, nrow(df))
    } else {
      values <- rlang::eval_tidy(fill_q, data = df)
      pal <- if (is.numeric(values)) {
        leaflet::colorNumeric("viridis", values, na.color = "#d9d9d9")
      } else {
        leaflet::colorFactor("viridis", values, na.color = "#d9d9d9")
      }
      colour <- pal(values)
    }
  }

  popup_q <- rlang::enquo(popup)
  popups <- if (!rlang::quo_is_null(popup_q)) {
    as.character(rlang::eval_tidy(popup_q, data = df))
  } else {
    .mm_default_popup(df, values, if (!is.null(values)) rlang::as_label(fill_q))
  }

  m <- leaflet::leaflet(x) |>
    leaflet::addProviderTiles(tiles) |>
    leaflet::addPolygons(
      fillColor = colour, fillOpacity = opacity, color = "white", weight = 1,
      label = labels, popup = popups,
      highlightOptions = leaflet::highlightOptions(weight = 2, color = "#333333", bringToFront = TRUE)
    )
  if (!is.null(pal)) {
    m <- leaflet::addLegend(m, pal = pal, values = values, title = rlang::as_label(fill_q), opacity = opacity)
  }
  m
}

.mm_html_escape <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  gsub(">", "&gt;", x, fixed = TRUE)
}

.mm_default_popup <- function(df, values, value_name) {
  field <- function(col) if (col %in% names(df)) .mm_html_escape(as.character(df[[col]])) else rep("", nrow(df))
  out <- paste0("<b>", field("name_en"), "</b><br>", field("name_mn"), "<br><small>", field("pcode"), "</small>")
  if (!is.null(values)) {
    out <- paste0(out, "<br>", .mm_html_escape(value_name), ": ", .mm_html_escape(format(values, big.mark = ",")))
  }
  out
}
