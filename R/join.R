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
#' `511` empty or out. At the aimag level, missing capital values are filled
#' from the region within each statistical stratum. Conflicts are reported;
#' `ub_policy` controls which source wins. A few tables use `511` for
#' something else (for example "Other"); check their metadata first.
#' Use `ub_policy = "none"` for tables where this equivalence is invalid.
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
#' @param fuzzy,max_dist Passed to [mn_match()].
#' @param strict If `TRUE`, reject missing, unmatched, ambiguous or fuzzy
#'   keys, missing boundaries, duplicate statistical keys and UB conflicts.
#'   Deliberately excluded levels and geographic areas are allowed.
#' @param strata Character vector of statistical key columns, such as
#'   `c("Year", "Sex")`. `NULL` recognizes common dimension names.
#'   Supply this explicitly for other dimensions or repeated records.
#' @param value_cols Columns to reconcile for Ulaanbaatar. `NULL` uses
#'   numeric columns except keys and recognized dimensions.
#' @param ub_policy `"prefer_city"` (default), `"prefer_region"`,
#'   `"error"` on conflicting values, or `"none"` to disable reconciliation.
#' @param duplicates `"allow"` (default), `"warn"` or `"error"` for repeated
#'   pcode/stratum keys. Strict mode always rejects duplicates.
#' @inheritParams mn_admin
#'
#' @return An `sf` tibble: the boundaries of every unit at the level, with
#'   the columns of `data` added. Columns of `data` whose names clash with
#'   boundary columns get the suffix `.data`. [mn_join_audit()] returns
#'   one diagnostic record per original input row.
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
                    crs = NULL,
                    fuzzy = TRUE,
                    max_dist = NULL,
                    strict = FALSE,
                    strata = NULL,
                    value_cols = NULL,
                    ub_policy = c("prefer_city", "prefer_region", "error", "none"),
                    duplicates = c("allow", "warn", "error")) {
  if (!is.data.frame(data)) {
    .mm_abort("{.arg data} must be a data frame, not {.obj_type_friendly {data}}.", "input")
  }
  by <- rlang::as_name(rlang::ensym(by))
  if (!by %in% names(data)) .mm_abort("Column {.field {by}} is not in {.arg data}.", "input")
  parent <- if (!is.null(by_parent)) {
    .mm_check_string(by_parent)
    if (!by_parent %in% names(data)) .mm_abort("Column {.field {by_parent}} is not in {.arg data}.", "input")
    data[[by_parent]]
  }
  if (inherits(data, "sf")) data <- sf::st_drop_geometry(data)
  level <- .mm_arg_level(level)
  resolution <- .mm_arg_resolution(resolution)
  ub_policy <- rlang::arg_match(ub_policy)
  duplicates <- rlang::arg_match(duplicates)
  for (flag in list(strict = strict, fuzzy = fuzzy, drop_other_levels = drop_other_levels)) {
    if (!is.logical(flag) || length(flag) != 1 || is.na(flag)) .mm_abort("Join flags must be TRUE or FALSE.", "input")
  }
  cols <- .mm_join_columns(data, by, by_parent, strata, value_cols)
  targets <- .mm_resolve_within(within)
  values <- as.character(data[[by]])
  if (is.null(level)) level <- .mm_detect_level(values, parent, targets, strict)
  res <- .mm_match_df(values, levels = level, within = parent, fuzzy = fuzzy, max_dist = max_dist, scope = targets)

  # Recognized units deliberately outside the global scope are not bad keys.
  if (!is.null(targets)) {
    failed <- which(res$status %in% c("unmatched", "ambiguous"))
    alt <- .mm_match_df(values[failed], levels = level, within = if (!is.null(parent)) parent[failed],
                        fuzzy = fuzzy, max_dist = max_dist)
    outside <- alt$status %in% c("code", "exact", "fuzzy") & !.mm_in_targets(alt$pcode, targets)
    res$pcode[failed[outside]] <- alt$pcode[outside]
    res$status[failed[outside]] <- "outside_scope"
  }
  failed <- which(res$status == "unmatched")
  other <- rep(NA_character_, length(values))
  other_pcode <- rep(NA_character_, length(values))
  if (length(failed)) {
    alt <- .mm_match_df(values[failed], levels = setdiff(.mm_levels, level), fuzzy = FALSE)
    hit <- alt$status %in% c("code", "exact")
    other_pcode[failed[hit]] <- alt$pcode[hit]
    other[failed[hit]] <- .mm_units$level[match(alt$pcode[hit], .mm_units$pcode)]
  }
  selected <- res$status %in% c("code", "exact", "fuzzy")
  action <- ifelse(selected, "joined", res$status)
  if (level == "aimag" && ub_policy != "none") {
    ub <- .mm_reconcile_ub(data, res, other, other_pcode, selected, action, cols, ub_policy, strict)
    data <- ub$data
    res <- ub$res
    other <- ub$other
    selected <- ub$selected
    action <- ub$action
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
      )), class = "dropped_levels"
    )
    res$status[!is.na(other)] <- "other_level"
    action[!is.na(other)] <- "other_level"
  }
  if (!is.null(targets)) {
    outside <- selected & !.mm_in_targets(res$pcode, targets)
    action[outside] <- "outside_scope"
    selected[outside] <- FALSE
  }
  .mm_report_match(res[!res$status %in% c("other_level", "outside_scope"), ])
  bnd <- suppressMessages(mn_admin(level, within = targets, resolution = resolution, lang = lang),
                          classes = "mongolmaps_message")
  no_geom <- setdiff(unique(res$pcode[selected]), bnd$pcode)
  if (length(no_geom)) {
    .mm_inform(
      c(
        "i" = "{length(no_geom)} matched place{?s} ha{?s/ve} no boundary and {?is/are} left out:",
        .mm_bullets(.mm_describe_each(no_geom), max = 5),
        "i" = "Villages and rural bags have NSO codes but no public boundary; see {.help mongolmaps::mn_bags}."
      ), class = "no_boundary"
    )
    action[selected & res$pcode %in% no_geom] <- "no_boundary"
  }
  if (strict && any(action %in% c("missing", "unmatched", "ambiguous", "no_boundary") | res$status == "fuzzy")) {
    .mm_abort("Strict join rejected unresolved, missing, fuzzy or boundaryless input rows. Inspect {.fn mn_match} with details = TRUE.",
              "join")
  }
  data$..pcode <- res$pcode
  data <- data[selected, , drop = FALSE]
  if (!is.null(targets)) data <- data[.mm_in_targets(data$..pcode, targets), , drop = FALSE]
  key <- data[c("..pcode", cols$strata)]
  dup <- duplicated(key) | duplicated(key, fromLast = TRUE)
  if (any(dup) && (strict || duplicates != "allow")) {
    msg <- "Repeated place/stratum keys: {sum(dup)} rows. Supply {.arg strata} for legitimate dimensions."
    if (strict || duplicates == "error") .mm_abort(msg, "join_duplicate") else .mm_warn(msg, "join_duplicate")
  }
  clash <- intersect(names(data), c(names(bnd), "geometry"))
  names(data)[names(data) %in% clash] <- paste0(names(data)[names(data) %in% clash], ".data")
  names(data)[names(data) == "..pcode"] <- "pcode"
  out <- dplyr::left_join(bnd, data, by = dplyr::join_by("pcode"), relationship = "one-to-many")
  out <- .mm_set_provenance(.mm_transform(out, crs), mn_provenance(bnd))
  audit <- .mm_match_details(res)
  audit$action <- action
  audit$other_level <- other
  attr(audit, "strata") <- cols$strata
  attr(audit, "value_cols") <- cols$values
  attr(out, "mongolmaps_join_audit") <- audit
  out
}

#' Inspect the input records behind a map join
#'
#' @param x An object returned by [mn_join()].
#' @return A tibble with one row per original input record. `action`
#'   distinguishes joined, coalesced, superseded, outside-scope, other-level,
#'   missing, unmatched, ambiguous and boundaryless rows. Original row numbers
#'   refer to the original input, even after filtering the map. The audit is
#'   an attribute; rebuilding an object can remove it.
#' @family joining data
#' @export
#' @examples
#' x <- mn_join(data.frame(place = c("Khovd", "Uvs"), value = 1:2), "place")
#' mn_join_audit(x)
mn_join_audit <- function(x) {
  audit <- attr(x, "mongolmaps_join_audit", exact = TRUE)
  if (is.null(audit)) .mm_abort("No join audit is attached to {.arg x}. Use {.fn mn_join} first.", "input")
  audit
}

.mm_join_columns <- function(data, by, by_parent, strata, value_cols) {
  if (is.null(strata)) {
    pattern <- "^(year|month|quarter|date|period|sex|gender|age|age_group|indicator|variable|measure|unit|frequency)(_(en|mn|code|label))?$"
    strata <- grep(pattern, names(data), value = TRUE, ignore.case = TRUE)
  }
  strata <- setdiff(strata, c(by, by_parent))
  if (is.null(value_cols)) {
    value_cols <- setdiff(names(data)[vapply(data, is.numeric, logical(1))], c(by, by_parent, strata))
  }
  for (cols in list(strata, value_cols)) {
    if (!is.character(cols) || anyNA(cols) || any(!cols %in% names(data))) {
      .mm_abort("{.arg strata} and {.arg value_cols} must name columns of {.arg data}.", "input")
    }
  }
  if (length(intersect(strata, value_cols))) .mm_abort("Stratum columns cannot also be value columns.", "input")
  list(strata = unique(strata), values = unique(value_cols))
}

.mm_reconcile_ub <- function(data, res, other, other_pcode, selected, action, cols, policy, strict) {
  region <- which(other_pcode == "MNR5")
  city <- which(res$pcode %in% "MN11" & selected)
  if (length(region) && length(cols$values)) {
    rows <- c(region, city)
    groups <- if (length(cols$strata)) {
      grouped <- dplyr::group_by(data[rows, cols$strata, drop = FALSE], dplyr::across(dplyr::everything()))
      dplyr::group_indices(grouped)
    } else {
      rep(1L, length(rows))
    }
    used <- integer()
    for (g in unique(groups)) {
      idx <- rows[groups == g]
      r <- intersect(idx, region)
      cty <- intersect(idx, city)
      if (!length(r)) next
      if (length(r) > 1 || length(cty) > 1) {
        .mm_abort("Ulaanbaatar has repeated records within a stratum. Supply all statistical dimensions in {.arg strata}.", "join")
      }
      conflict <- if (length(cty)) cols$values[vapply(cols$values, function(v) {
        !is.na(data[[v]][r]) && !is.na(data[[v]][cty]) && !isTRUE(all.equal(data[[v]][r], data[[v]][cty]))
      }, logical(1))] else character()
      if (length(conflict)) {
        msg <- "Conflicting Ulaanbaatar region/capital values in {.val {conflict}} (input row {r})."
        if (strict || policy == "error") .mm_abort(msg, "ub_conflict") else .mm_warn(msg, "ub_conflict")
      }
      prefer_r <- policy == "prefer_region" || !length(cty) ||
        (length(cty) && all(is.na(data[cty, cols$values, drop = FALSE])) && any(!is.na(data[r, cols$values, drop = FALSE])))
      primary <- if (prefer_r) r else cty
      secondary <- if (prefer_r) cty else r
      copied <- FALSE
      for (v in cols$values) {
        if (length(secondary) && is.na(data[[v]][primary]) && !is.na(data[[v]][secondary])) {
          data[[v]][primary] <- data[[v]][secondary]
          copied <- TRUE
        }
      }
      # A region-only row with no values is still a recognized fallback record.
      selected[r] <- prefer_r
      res$pcode[r] <- "MN11"
      res$status[r] <- "code"
      other[r] <- NA_character_
      action[r] <- if (prefer_r) "joined" else if (copied) "coalesced" else "superseded"
      if (length(cty)) {
        selected[cty] <- !prefer_r
        action[cty] <- if (!prefer_r) "joined" else if (copied) "coalesced" else "superseded"
      }
      if (prefer_r || copied) used <- c(used, r)
    }
    if (length(used)) {
      .mm_inform(c("i" = "Using Ulaanbaatar region values to fill capital data within {length(used)} statistical stratum/strata."),
                 class = "ub_from_region")
    }
  }
  list(data = data, res = res, other = other, selected = selected, action = action)
}

# The level with the most matches; ties go to the finer level outside strict mode.
.mm_detect_level <- function(values, parent = NULL, scope = NULL, strict = FALSE) {
  m <- suppressWarnings(suppressMessages(.mm_match_df(values, within = parent, fuzzy = FALSE, scope = scope)))
  m <- m[!duplicated(m[c("x", "within_pcode")]), ]
  lv <- .mm_units$level[match(m$pcode, .mm_units$pcode)]
  lv <- lv[!is.na(lv)]
  if (!length(lv)) {
    if (strict) .mm_abort("Cannot infer an administrative level; supply {.arg level}.", "join")
    return("aimag")
  }
  counts <- table(factor(lv, levels = .mm_levels))
  best <- .mm_levels[counts == max(counts)]
  if (strict && length(best) > 1) .mm_abort("Level inference is tied; supply {.arg level}.", "join")
  best[length(best)]
}
