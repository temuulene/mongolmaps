#' Join your data to a map of Mongolia
#'
#' Attaches a data frame to boundaries in one step. The column in `by` can
#' hold names in any common spelling, Cyrillic names, NSO codes, ISO codes
#' or P-codes; they are matched with [mn_match()]. Every unit of the level
#' is kept, so places without data still appear on the map (with `NA`).
#'
#' @details
#' **Level.** When `level` is `NULL`, the level with the most matches is
#' used. NSO tables often list several levels in one column (the national
#' total, regions, aimags, soums ...); rows at other levels are dropped with
#' a message (see `drop_other_levels`). Join NSO tables by their code column
#' (such as `Region`) rather than the label column: labels such as
#' "Ulaanbaatar" name both a region and an aimag.
#'
#' **Ulaanbaatar.** The Ulaanbaatar region (NSO code `5`) and the capital
#' (`511`) cover the same area. Many NSO tables, health tables in
#' particular, give the capital's figures only on the region row and leave
#' `511` empty or out. At the aimag level, when the region rows hold more
#' values than the `511` rows, they are used for Ulaanbaatar, with a
#' message. A few tables use `511` for something else (for example "Other");
#' check the labels of such tables before joining.
#'
#' **Several rows per unit.** Data with several rows per place (for
#' example one per year) give several copies of that place's polygon, ready
#' for `ggplot2::facet_wrap()`.
#'
#' **Places without boundaries.** Villages (tosgon) and rural bags have NSO
#' codes but no boundary; their rows are reported and left out.
#'
#' @param data A data frame.
#' @param by The column of `data` with place names or codes, as a string or
#'   a bare column name.
#' @param level The level of the places in `by`. `NULL` detects it.
#' @param by_parent Optional column of `data` naming each row's parent (for
#'   example the aimag of each soum). Needed when soum or bag names repeat
#'   across the country.
#' @param drop_other_levels If `TRUE` (default), rows for units at other
#'   levels, such as national or aimag totals in a soum table, are dropped
#'   with a single message. If `FALSE` they are reported as unmatched.
#' @inheritParams mn_admin
#'
#' @return An `sf` tibble: the boundaries of every unit at the level, with
#'   the columns of `data` added. Columns of `data` whose names clash with
#'   boundary columns get the suffix `.data`.
#' @family joining data
#' @export
#' @examples
#' # Mid-year population from NSO, by aimag and year
#' pop <- mn_example_population[mn_example_population$Year == 2025, ]
#' mn_join(pop, by = "Region", level = "aimag")
#'
#' # Khoroos of Ulaanbaatar, from the same table
#' mn_join(pop, by = "Region", level = "bag", within = "Ulaanbaatar")
#'
#' # Names in any spelling work
#' df <- data.frame(aimag = c("Khovsgol", "Hovd", "\\u0423\\u0432\\u0441"), value = 1:3)
#' mn_join(df, aimag)
mn_join <- function(data,
                    by,
                    level = NULL,
                    by_parent = NULL,
                    within = NULL,
                    drop_other_levels = TRUE,
                    resolution = c("low", "high"),
                    lang = NULL,
                    crs = NULL) {
  if (!is.data.frame(data)) {
    .mm_abort("{.arg data} must be a data frame, not {.obj_type_friendly {data}}.", "input")
  }
  by <- rlang::as_name(rlang::ensym(by))
  if (!by %in% names(data)) {
    .mm_abort("Column {.field {by}} is not in {.arg data}.", "input")
  }
  parent <- if (!is.null(by_parent)) {
    .mm_check_string(by_parent)
    if (!by_parent %in% names(data)) .mm_abort("Column {.field {by_parent}} is not in {.arg data}.", "input")
    data[[by_parent]]
  }
  if (inherits(data, "sf")) {
    data <- sf::st_drop_geometry(data)
  }
  level <- .mm_arg_level(level)
  resolution <- .mm_arg_resolution(resolution)

  values <- as.character(data[[by]])
  if (is.null(level)) {
    level <- .mm_detect_level(values)
  }
  res <- .mm_match_df(values, levels = level, within = parent)

  # Rows that did not match at `level` but name a unit at another level are
  # totals (larger units) or details (smaller units), not errors.
  failed <- which(res$status %in% c("unmatched", "ambiguous"))
  other <- rep(NA_character_, length(values))
  other_pcode <- rep(NA_character_, length(values))
  if (length(failed)) {
    alt <- .mm_match_df(values[failed], levels = setdiff(.mm_levels, level), fuzzy = FALSE)
    hit <- alt$status %in% c("code", "exact")
    other_pcode[failed[hit]] <- alt$pcode[hit]
    other[failed[hit]] <- .mm_units$level[match(alt$pcode[hit], .mm_units$pcode)]
  }

  # The Ulaanbaatar region (NSO code 5) and the capital (511) are the same
  # place. Many NSO tables fill only the region row, so use it when the
  # capital's own rows are missing or hold less data.
  if (level == "aimag") {
    from_region <- which(other_pcode == "MNR5")
    from_city <- which(res$pcode %in% "MN11")
    keep <- setdiff(names(data), c(by, by_parent))
    n_filled <- function(rows) sum(!is.na(data[rows, keep, drop = FALSE]))
    if (length(from_region) && n_filled(from_region) > n_filled(from_city)) {
      ub_city <- unique(values[from_city])
      res$pcode[from_region] <- "MN11"
      res$status[from_region] <- "code"
      other[from_region] <- NA
      res$pcode[from_city] <- NA
      res$status[from_city] <- "other_level"
      .mm_inform(
        c("i" = paste0(
          "Using the Ulaanbaatar region ({.val {unique(values[from_region])}}) for Ulaanbaatar: ",
          if (length(ub_city)) {
            "the rows for the capital itself ({.val {ub_city}}) have fewer values."
          } else {
            "the data have no rows for the capital itself."
          }
        )),
        class = "ub_from_region"
      )
    }
  }
  if (drop_other_levels && any(!is.na(other))) {
    rank <- match(other, .mm_levels) - match(level, .mm_levels)
    n_up <- sum(rank < 0, na.rm = TRUE)
    n_down <- sum(rank > 0, na.rm = TRUE)
    .mm_inform(
      c("i" = paste0(
        "Joining at the {level} level; dropped ",
        if (n_up) "{n_up} row{?s} for larger units ({.val {unique(other[rank < 0 & !is.na(rank)])}})",
        if (n_up && n_down) " and ",
        if (n_down) "{n_down} row{?s} for smaller units ({.val {unique(other[rank > 0 & !is.na(rank)])}})",
        "."
      )),
      class = "dropped_levels"
    )
    res$status[!is.na(other)] <- "other_level"
  }
  .mm_report_match(res[res$status != "other_level", ])

  data$..pcode <- res$pcode
  data <- data[!is.na(data$..pcode), , drop = FALSE]
  targets <- .mm_resolve_within(within)
  if (!is.null(targets)) {
    data <- data[.mm_in_targets(data$..pcode, targets), , drop = FALSE]
  }

  bnd <- suppressMessages(mn_admin(level, within = targets, resolution = resolution, lang = lang), classes = "mongolmaps_message")
  no_geom <- setdiff(unique(data$..pcode), bnd$pcode)
  if (length(no_geom)) {
    .mm_inform(
      c(
        "i" = "{length(no_geom)} matched place{?s} ha{?s/ve} no boundary and {?is/are} left out:",
        .mm_bullets(.mm_describe_each(no_geom), max = 5),
        "i" = "Villages and rural bags have NSO codes but no public boundary; see {.help mongolmaps::mn_bags}."
      ),
      class = "no_boundary"
    )
  }

  clash <- intersect(names(data), c(names(bnd), "geometry"))
  names(data)[names(data) %in% clash] <- paste0(names(data)[names(data) %in% clash], ".data")
  names(data)[names(data) == "..pcode"] <- "pcode"
  out <- dplyr::left_join(bnd, data, by = dplyr::join_by("pcode"), relationship = "one-to-many")
  .mm_transform(out, crs)
}

# The level with the most matches; ties go to the finer level.
.mm_detect_level <- function(values) {
  u <- unique(values[!is.na(values)])
  m <- suppressWarnings(suppressMessages(.mm_match_df(u, fuzzy = FALSE)))
  lv <- .mm_units$level[match(m$pcode, .mm_units$pcode)]
  lv <- lv[!is.na(lv)]
  if (!length(lv)) {
    return("aimag")
  }
  counts <- table(factor(lv, levels = .mm_levels))
  best <- .mm_levels[counts == max(counts)]
  best[length(best)]
}
