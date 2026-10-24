#' National and urban maps with Ulaanbaatar inset panels
#'
#' Compose ordinary ggplots without shifting any analytical coordinates.
#' All panels share fill limits and breaks. When supplying different data
#' to the national and urban panels, their fill expressions must have
#' compatible units. Insets have independent map scales.
#'
#' @param x A national map for `mn_inset_ub()`, or a UB district/khoroo map
#'   for `mn_map_ub()`. Defaults to aimags or UB districts respectively.
#' @param ub Optional urban data for the inset. By default, select
#'   Ulaanbaatar units from `x`; if none exist, stop rather than invent data.
#' @param fill An unquoted fill column/expression, as in [mn_map()].
#' @param label Label units in each panel.
#' @param title Overall title.
#' @param limits,breaks Shared fill scale limits and breaks.
#' @param ... Additional arguments to [mn_map()], such as `lang`,
#'   `trans`, `bins` or `midpoint`.
#' @return A patchwork object; requires the optional patchwork package.
#'   No input geometry is modified.
#' @family mapping helpers
#' @export
#' @examplesIf rlang::is_installed(c("patchwork", "ggplot2"))
#' mn_inset_ub(fill = area_km2)
#' mn_map_ub(fill = area_km2)
mn_inset_ub <- function(x = NULL, ub = NULL, fill = NULL, label = FALSE,
                        title = NULL, limits = NULL, breaks = NULL, ...) {
  rlang::check_installed("patchwork", reason = "to compose inset panels.")
  x <- x %||% mn_aimags()
  .mm_check_inset_data(x)
  if (is.null(ub)) {
    if (!"pcode" %in% names(x)) .mm_abort("Supply {.arg ub} for a map without administrative codes.", "input")
    ub <- x[.mm_in_targets(x$pcode, "MN11"), ]
  }
  .mm_check_inset_data(ub)
  if (!nrow(ub)) .mm_abort("No Ulaanbaatar records are available; supply {.arg ub}.", "input")
  fq <- rlang::enquo(fill)
  dots <- list(...)
  args <- .mm_panel_scale(list(x, ub), fq, limits, breaks, dots)
  main <- .mm_panel(x, fq, label, NULL, args, dots)
  box <- sf::st_sf(geometry = sf::st_as_sfc(sf::st_bbox(ub)))
  main <- main + ggplot2::geom_sf(data = box, fill = NA, colour = "grey25", linewidth = 0.4)
  urban <- .mm_panel(ub, fq, label, "Ulaanbaatar (enlarged)", args, dots)
  out <- patchwork::wrap_plots(list(main, urban), widths = c(2, 1), guides = "collect") +
    patchwork::plot_annotation(
      title = title, caption = .mm_layout_caption(list(x, ub), dots),
      subtitle = "Panels have independent geographic scales",
      theme = ggplot2::theme(plot.caption = ggplot2::element_text(size = 8, colour = "grey40", hjust = 1))
    )
  attr(out, "mongolmaps_panels") <- list(national = x, ulaanbaatar = ub)
  out
}

#' @rdname mn_inset_ub
#' @export
mn_map_ub <- function(x = NULL, fill = NULL, label = FALSE, title = NULL,
                      limits = NULL, breaks = NULL, ...) {
  rlang::check_installed("patchwork", reason = "to compose urban panels.")
  x <- x %||% mn_ub_districts()
  .mm_check_inset_data(x)
  if (!"pcode" %in% names(x) || any(!.mm_in_targets(x$pcode, "MN11"))) {
    .mm_abort("{.arg x} must contain only Ulaanbaatar administrative units.", "input")
  }
  # Baganuur and Bagakhangai are detached; the main panel includes Nalaikh.
  detached <- c("MN1101", "MN1104")
  parts <- list(
    main = x[!.mm_in_targets(x$pcode, detached), ],
    baganuur = x[.mm_in_targets(x$pcode, detached[1]), ],
    bagakhangai = x[.mm_in_targets(x$pcode, detached[2]), ]
  )
  parts <- parts[vapply(parts, nrow, integer(1)) > 0]
  if (!length(parts)) .mm_abort("No urban polygons are available.", "input")
  fq <- rlang::enquo(fill)
  dots <- list(...)
  args <- .mm_panel_scale(parts, fq, limits, breaks, dots)
  titles <- c(main = "Ulaanbaatar (including Nalaikh)", baganuur = "Baganuur", bagakhangai = "Bagakhangai")
  plots <- lapply(names(parts), function(n) .mm_panel(parts[[n]], fq, label, titles[[n]], args, dots))
  out <- if (length(plots) == 3) {
    side <- patchwork::wrap_plots(plots[2:3], ncol = 1)
    patchwork::wrap_plots(list(plots[[1]], side), widths = c(2, 1), guides = "collect")
  } else {
    patchwork::wrap_plots(plots, guides = "collect")
  }
  out <- out + patchwork::plot_annotation(
    title = title, subtitle = "Panels have independent geographic scales",
    caption = .mm_layout_caption(parts, dots),
    theme = ggplot2::theme(plot.caption = ggplot2::element_text(size = 8, colour = "grey40", hjust = 1))
  )
  attr(out, "mongolmaps_panels") <- parts
  out
}

.mm_check_inset_data <- function(x) {
  if (!inherits(x, "sf") || !all(sf::st_geometry_type(x) %in% c("POLYGON", "MULTIPOLYGON"))) {
    .mm_abort("Inset data must be an sf polygon object.", "input")
  }
}

.mm_panel_scale <- function(parts, fill_q, limits, breaks, dots) {
  if (!rlang::quo_is_null(fill_q)) {
    expr <- rlang::quo_get_expr(fill_q)
    literal <- is.character(expr) && length(expr) == 1 && !expr %in% names(parts[[1]])
    if (!literal) {
      v <- unlist(lapply(parts, function(p) rlang::eval_tidy(fill_q, sf::st_drop_geometry(p))), use.names = FALSE)
      if (is.null(limits)) {
        limits <- if (is.numeric(v)) {
          if (any(is.finite(v))) range(v[is.finite(v)]) else NULL
        } else {
          unique(as.character(v[!is.na(v)]))
        }
      }
      if (length(dots$bins) == 1 && is.numeric(v) && any(is.finite(v))) {
        dots$bins <- unique(c(-Inf, pretty(range(v[is.finite(v)]), n = dots$bins), Inf))
      }
    }
  }
  list(limits = limits, breaks = breaks, dots = dots)
}

.mm_panel <- function(x, fill_q, label, title, scale, dots) {
  # Bin cut points derived across all panels must also be shared.
  dots <- scale$dots
  dots$caption <- FALSE
  call <- rlang::expr(mn_map(x = !!x, fill = !!fill_q, label = !!label,
                             title = !!title, limits = !!scale$limits, breaks = !!scale$breaks, !!!dots))
  rlang::eval_tidy(call)
}

.mm_layout_caption <- function(parts, dots) {
  caption <- dots$caption %||% TRUE
  if (isFALSE(caption)) return(NULL)
  text <- if (is.character(caption)) {
    caption
  } else {
    p <- do.call(.mm_combine_provenance, parts)
    paste(unique(p$attribution), collapse = "; ")
  }
  paste(strwrap(text, width = 110), collapse = "\n")
}
