#' Quick maps of Mongolia with ggplot2
#'
#' Draws any map from this package, or a map joined to your data, with
#' sensible defaults: a projection suited to Mongolia, a colour-blind
#' friendly palette, grey for missing values, optional labels and
#' surroundings, and the data attribution as a caption. The result is a
#' normal ggplot, so you can add layers, scales and themes to it.
#'
#' @param x An `sf` object, typically from [mn_aimags()], [mn_soums()],
#'   [mn_khoroos()] or [mn_join()], or a `terra` raster such as
#'   [mn_elevation()], [mn_landcover()] or [mn_population()]. Defaults to
#'   the aimags.
#' @param fill Column to colour the polygons by (unquoted), or a single
#'   colour such as `"steelblue"`. Numbers get a continuous viridis scale;
#'   text and factors get a discrete one.
#' @param trans Transformation of a numeric `fill` scale, such as `"log10"`
#'   or `"sqrt"`. Useful when Ulaanbaatar dwarfs everything else.
#' @param label `TRUE` to label each unit with its name (khoroos with their
#'   number), or an unquoted column to label with.
#' @param context If `TRUE`, draws neighbouring countries, major rivers and
#'   lakes around the map.
#' @param crs Projection. `NULL` picks one: Albers equal-area for the
#'   country or large parts of it, UTM zone 48N for Ulaanbaatar and other
#'   small areas in central Mongolia. See [mn_crs()].
#' @param lang Language of labels when `label = TRUE`: `"en"`, `"mn"` or
#'   `"mns"`.
#' @param caption `TRUE` adds the data attribution from [mn_citation()];
#'   `FALSE` adds none; a string is used as is.
#' @param title Optional plot title.
#' @param label_size Text size of labels.
#'
#' @return A `ggplot` object.
#' @family mapping helpers
#' @export
#' @examplesIf rlang::is_installed("ggplot2")
#' mn_map()
#' mn_map(mn_aimags(), fill = area_km2, label = TRUE)
#' mn_map(mn_khoroos(district = "Bayangol"), label = TRUE)
#'
#' pop <- mn_example_population[mn_example_population$Year == 2025, ]
#' pop_map <- mn_join(pop, "Region", level = "aimag")
#' mn_map(pop_map, fill = value, trans = "log10", title = "Population, 2025")
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet() && rlang::is_installed(c("ggplot2", "terra"))
#' mn_map(mn_landcover())
#' mn_map(mn_elevation()) + ggplot2::geom_sf(data = mn_aimags(), fill = NA, colour = "white")
mn_map <- function(x = NULL,
                   fill = NULL,
                   trans = "identity",
                   label = FALSE,
                   context = FALSE,
                   crs = NULL,
                   lang = NULL,
                   caption = TRUE,
                   title = NULL,
                   label_size = 2.6) {
  rlang::check_installed("ggplot2", reason = "to draw maps with `mn_map()`.")
  lang <- .mm_arg_lang(lang)
  x <- x %||% mn_aimags(lang = lang)
  if (inherits(x, "SpatRaster")) {
    return(.mm_map_raster(x, trans = trans, crs = crs, caption = caption, title = title))
  }
  if (!inherits(x, "sf")) {
    .mm_abort("{.arg x} must be an {.cls sf} object or a {.cls SpatRaster}, not {.obj_type_friendly {x}}.", "input")
  }
  crs <- .mm_resolve_crs(crs) %||% .mm_auto_crs(x)
  x <- sf::st_transform(x, crs)

  fill_q <- rlang::enquo(fill)
  layers <- list()
  # Context layers are cropped to a frame around `x` rather than limited by
  # the coordinate system, so users can add their own layers freely.
  frame <- if (context) .mm_frame(x, pad = 0.04)
  crop <- function(layer) suppressWarnings(sf::st_crop(sf::st_transform(layer, crs), frame))
  if (context) {
    layers <- c(layers, list(
      ggplot2::geom_sf(data = crop(mn_neighbours()), fill = "grey92", colour = "white", linewidth = 0.3)
    ))
  }
  layers <- c(layers, .mm_fill_layers(x, fill_q, trans))
  if (context) {
    layers <- c(layers, list(
      ggplot2::geom_sf(data = crop(mn_lakes()), fill = "#a6cee3", colour = NA),
      ggplot2::geom_sf(data = crop(mn_rivers()), colour = "#6baed6", linewidth = 0.3)
    ))
  }

  label_q <- rlang::enquo(label)
  if (!rlang::quo_is_null(label_q) && !isFALSE(rlang::quo_get_expr(label_q))) {
    layers <- c(layers, list(.mm_label_layer(x, label_q, lang, label_size)))
  }

  cap <- if (isTRUE(caption)) .mm_caption(x, context) else if (is.character(caption)) caption
  ggplot2::ggplot() +
    layers +
    ggplot2::coord_sf(crs = crs, datum = NA, expand = !context, default = TRUE) +
    ggplot2::labs(title = title, caption = cap, fill = if (!rlang::quo_is_null(fill_q)) rlang::as_label(fill_q)) +
    theme_mn()
}

.mm_frame <- function(x, pad) {
  bb <- sf::st_bbox(x)
  d <- pad * max(bb[["xmax"]] - bb[["xmin"]], bb[["ymax"]] - bb[["ymin"]])
  bb[c("xmin", "ymin")] <- bb[c("xmin", "ymin")] - d
  bb[c("xmax", "ymax")] <- bb[c("xmax", "ymax")] + d
  bb
}

#' A clean map theme
#'
#' A minimal ggplot2 theme for maps: no axes or grid, legend at the right,
#' small grey caption.
#'
#' @param base_size Base font size.
#' @param base_family Base font family.
#' @return A ggplot2 theme.
#' @family mapping helpers
#' @export
#' @examplesIf rlang::is_installed("ggplot2")
#' library(ggplot2)
#' ggplot(mn_aimags()) + geom_sf() + theme_mn()
theme_mn <- function(base_size = 11, base_family = "") {
  rlang::check_installed("ggplot2", reason = "to use `theme_mn()`.")
  ggplot2::theme_void(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", size = ggplot2::rel(1.2), margin = ggplot2::margin(b = 6)),
      plot.title.position = "plot",
      plot.caption.position = "plot",
      plot.subtitle = ggplot2::element_text(colour = "grey30", margin = ggplot2::margin(b = 6)),
      plot.caption = ggplot2::element_text(colour = "grey50", size = ggplot2::rel(0.7), hjust = 1),
      legend.title = ggplot2::element_text(size = ggplot2::rel(0.85)),
      legend.text = ggplot2::element_text(size = ggplot2::rel(0.8)),
      plot.margin = ggplot2::margin(8, 8, 8, 8)
    )
}

#' Label points for map units
#'
#' Returns one point per unit, placed well inside its polygon (unlike a
#' centroid, which can fall outside curved shapes). Points for the maps in
#' this package are precomputed; other polygons use
#' [sf::st_point_on_surface()].
#'
#' @param x An `sf` object of polygons.
#' @return An `sf` object of points with the attributes of `x`.
#' @family mapping helpers
#' @export
#' @examples
#' mn_label_points(mn_aimags())
mn_label_points <- function(x) {
  if (!inherits(x, "sf")) {
    .mm_abort("{.arg x} must be an {.cls sf} object, not {.obj_type_friendly {x}}.", "input")
  }
  crs <- sf::st_crs(x)
  layer <- if ("level" %in% names(x)) {
    c(country = "country", region = "region", aimag = "aimag", soum = "soum", bag = "khoroo")[x$level]
  } else {
    rep(NA_character_, nrow(x))
  }
  known <- if ("pcode" %in% names(x)) {
    match(paste(layer, x$pcode), paste(.mm_labels$layer, .mm_labels$pcode))
  } else {
    rep(NA_integer_, nrow(x))
  }
  geom <- sf::st_geometry(x)
  fallback <- suppressWarnings(sf::st_point_on_surface(geom[is.na(known)]))
  pt <- sf::st_sfc(rep(list(sf::st_point()), nrow(x)), crs = crs)
  if (any(!is.na(known))) {
    lab <- .mm_labels[known[!is.na(known)], ]
    ll <- sf::st_as_sf(lab, coords = c("x", "y"), crs = 4326)
    pt[!is.na(known)] <- sf::st_geometry(sf::st_transform(ll, crs))
  }
  if (any(is.na(known))) pt[is.na(known)] <- fallback
  sf::st_set_geometry(x, pt)
}

.mm_auto_crs <- function(x) {
  bb <- sf::st_bbox(sf::st_transform(x, 4326))
  small <- (bb[["xmax"]] - bb[["xmin"]]) < 3 && (bb[["ymax"]] - bb[["ymin"]]) < 3
  central <- bb[["xmin"]] > 101.5 && bb[["xmax"]] < 110.5
  if (small && central) mn_crs("utm") else mn_crs("albers")
}

.mm_fill_layers <- function(x, fill_q, trans = "identity") {
  border <- if (nrow(x) > 150) 0.1 else 0.25
  if (rlang::quo_is_null(fill_q)) {
    return(list(ggplot2::geom_sf(data = x, fill = "grey95", colour = "grey40", linewidth = border)))
  }
  expr <- rlang::quo_get_expr(fill_q)
  if (is.character(expr) && length(expr) == 1 && !expr %in% names(x)) {
    return(list(ggplot2::geom_sf(data = x, fill = expr, colour = "white", linewidth = border)))
  }
  values <- rlang::eval_tidy(fill_q, data = sf::st_drop_geometry(x))
  scale <- if (is.numeric(values)) {
    ggplot2::scale_fill_viridis_c(na.value = "grey85", labels = .mm_number_labels, transform = trans)
  } else {
    ggplot2::scale_fill_viridis_d(na.value = "grey85")
  }
  list(
    ggplot2::geom_sf(data = x, ggplot2::aes(fill = !!fill_q), colour = "white", linewidth = border),
    scale
  )
}

.mm_number_labels <- function(x) {
  if (rlang::is_installed("scales")) scales::label_comma()(x) else format(x, big.mark = ",", scientific = FALSE, trim = TRUE)
}

.mm_label_layer <- function(x, label_q, lang, size) {
  pts <- mn_label_points(x)
  expr <- rlang::quo_get_expr(label_q)
  pts$..label <- if (isTRUE(expr)) {
    is_khoroo <- "type" %in% names(pts) & pts$type %in% "khoroo"
    nm <- if (all(c("name_en", "name_mn", "name_mns") %in% names(pts))) .mm_name_for_lang(pts, lang) else pts$name
    ifelse(is_khoroo, as.character(pts$number), nm)
  } else {
    as.character(rlang::eval_tidy(label_q, data = sf::st_drop_geometry(pts)))
  }
  ggplot2::geom_sf_label(
    data = pts, ggplot2::aes(label = .data$..label),
    size = size, colour = "grey10", fill = "white", alpha = 0.7, linewidth = 0,
    label.padding = ggplot2::unit(0.12, "lines")
  )
}

.mm_caption <- function(x, context) {
  layers <- "admin"
  # UB district lines are the unions of khoroos, so credit both.
  if ("type" %in% names(x) && any(x$type %in% c("khoroo", "district"))) layers <- c(layers, "khoroos")
  if (context) layers <- c(layers, "naturalearth")
  mn_citation(layers)
}

# Raster maps. The first layer is an invisible outline in the map projection,
# so layers users add later (which reset the coordinate system) stay in it.
.mm_map_raster <- function(r, trans, crs, caption, title, max_cells = 1e6) {
  rlang::check_installed("terra", reason = "to map rasters.")
  r <- r[[1]]
  categorical <- terra::is.factor(r)
  crs <- .mm_resolve_crs(crs) %||% if (terra::is.lonlat(r)) .mm_auto_crs(.mm_raster_outline(r)) else sf::st_crs(terra::crs(r))
  if (!identical(sf::st_crs(terra::crs(r)), crs)) {
    r <- terra::project(r, crs$wkt, method = if (categorical) "near" else "bilinear")
  }
  if (terra::ncell(r) > max_cells) {
    r <- terra::spatSample(r, max_cells, method = "regular", as.raster = TRUE)
  }
  layer <- names(r)
  df <- terra::as.data.frame(r, xy = TRUE, na.rm = TRUE)
  names(df) <- c("x", "y", "value")
  # Projected cell centres carry floating-point noise; snap them to the grid.
  res <- terra::res(r)
  df$x <- round(df$x / res[[1]], 3) * res[[1]]
  df$y <- round(df$y / res[[2]], 3) * res[[2]]
  outline <- .mm_raster_outline(r)

  scale <- if (categorical) {
    leg <- .mm_landcover_legend
    cols <- terra::coltab(r)[[1]]
    lv <- terra::levels(r)[[1]]
    pal <- if (!is.null(cols) && nrow(cols)) {
      grDevices::rgb(cols$red, cols$green, cols$blue, maxColorValue = 255)[match(lv[[1]], cols$value)]
    } else {
      leg$colour[match(lv[[1]], leg$value)]
    }
    ggplot2::scale_fill_manual(values = stats::setNames(pal, lv[[2]]), na.value = "transparent", drop = TRUE)
  } else if (layer == "hillshade") {
    ggplot2::scale_fill_gradient(low = "grey10", high = "white", guide = "none")
  } else {
    ggplot2::scale_fill_viridis_c(labels = .mm_number_labels, transform = trans, na.value = "transparent")
  }
  cap <- if (isTRUE(caption)) .mm_raster_caption(layer) else if (is.character(caption)) caption
  ggplot2::ggplot() +
    ggplot2::geom_sf(data = outline, fill = NA, colour = NA) +
    ggplot2::geom_raster(data = df, ggplot2::aes(x = .data$x, y = .data$y, fill = .data$value)) +
    scale +
    ggplot2::coord_sf(crs = crs, datum = NA, default = TRUE) +
    ggplot2::labs(title = title, caption = cap, fill = if (layer != "hillshade") layer) +
    theme_mn()
}

.mm_raster_outline <- function(r) {
  e <- as.vector(terra::ext(r))
  bb <- sf::st_bbox(c(xmin = e[["xmin"]], xmax = e[["xmax"]], ymin = e[["ymin"]], ymax = e[["ymax"]]), crs = sf::st_crs(terra::crs(r)))
  sf::st_sf(geometry = sf::st_as_sfc(bb))
}

.mm_raster_caption <- function(layer) {
  id <- if (layer %in% c("elevation", "hillshade")) {
    "copernicus_dem"
  } else if (layer == "landcover") {
    "worldcover"
  } else if (startsWith(layer, "population")) {
    "worldpop"
  }
  if (is.null(id)) NULL else mn_citation(c("admin", id))
}
