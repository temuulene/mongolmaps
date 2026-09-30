#' Match place names and codes to Mongolian administrative units
#'
#' Converts any common way of writing a Mongolian place into its code:
#' English spellings ("Khuvsgul", "Khovsgol", "Hovsgol"), Cyrillic,
#' NSO statistical codes, ISO 3166-2 codes and P-codes. Names are compared
#' through a normalised key, so spelling variants, case, punctuation and
#' words such as "aimag", "province", "soum" or "district" do not matter.
#' Values that still do not match are tried with a small edit distance.
#'
#' @param x A character vector of names or codes (numbers and factors are
#'   converted to character).
#' @param level The level(s) to search: `"country"`, `"region"`, `"aimag"`,
#'   `"soum"` (includes Ulaanbaatar districts) or `"bag"` (includes
#'   khoroos). `NULL` (the default) searches every level, preferring aimags,
#'   then soums, regions, the country and bags.
#' @param within Restricts the search to units inside a parent, given as a
#'   name or code. Use it to separate soums that share a name. Either a
#'   single value or one value per element of `x`.
#' @param to What to return: `"pcode"` (default), `"name_en"`, `"name_mn"`,
#'   `"name_mns"`, `"iso_code"`, `"nso_code"`, `"level"` or `"type"`.
#' @param fuzzy If `TRUE` (default), values without an exact match are
#'   matched by edit distance when a single close candidate exists. Each
#'   fuzzy match is reported in a message so you can check it.
#' @param max_dist Maximum edit distance for fuzzy matching. `NULL` scales
#'   it with the length of the name (0 for 3 letters or fewer, up to 3 for
#'   long names).
#' @param quiet If `TRUE`, suppresses the message listing fuzzy matches.
#'   Warnings about ambiguous or unmatched values are always shown.
#'
#' @return A character vector the same length as `x`. Values that cannot
#'   be matched, or that match several units, are `NA` and are listed in a
#'   warning.
#' @family names and codes
#' @export
#' @examples
#' mn_match(c("Khuvsgul", "Hovsgol", "\\u0425\\u04e9\\u0432\\u0441\\u0433\\u04e9\\u043b", "MN-041"))
#'
#' # NSO statistical codes work too
#' mn_match(c("183", "511", "51107"), to = "name_en")
#'
#' # Many soums share a name: say which aimag you mean
#' mn_match("Bayan-Uul", level = "soum", within = "Dornod")
#'
#' # Khoroos are numbered within their district
#' mn_match("15-r khoroo", level = "bag", within = "Bayangol")
mn_match <- function(x,
                     level = NULL,
                     within = NULL,
                     to = c("pcode", "name_en", "name_mn", "name_mns", "iso_code", "nso_code", "level", "type"),
                     fuzzy = TRUE,
                     max_dist = NULL,
                     quiet = FALSE) {
  to <- rlang::arg_match(to)
  levels <- .mm_arg_level(level, multiple = TRUE)
  res <- .mm_match_df(x, levels = levels, within = within, fuzzy = fuzzy, max_dist = max_dist)
  .mm_report_match(res, quiet = quiet)
  if (to == "pcode") {
    return(res$pcode)
  }
  .mm_units[[to]][match(res$pcode, .mm_units$pcode)]
}

.mm_level_priority <- c("aimag", "soum", "region", "country", "bag")

.mm_fuzzy_threshold <- function(key) {
  n <- nchar(key)
  as.integer(ifelse(n <= 3, 0L, ifelse(n <= 6, 1L, ifelse(n <= 10, 2L, 3L))))
}

# Words in a name that say what kind of unit it is ("Sukhbaatar district",
# "Bayankhongor soum", "15-r khoroo"), from most to least specific.
.mm_type_hints <- list(
  khoroo = list(words = c("khoroo", "horoo"), types = "khoroo"),
  bag = list(words = c("bag", "bagh"), types = "bag"),
  district = list(words = c("district", "duureg", "dvvreg"), types = "district"),
  soum = list(words = c("soum", "sum", "sumu", "somon"), types = c("soum", "village")),
  aimag = list(words = c("aimag", "aimak", "aymag", "province"), types = c("aimag", "capital")),
  region = list(words = c("region", "bus"), types = "region")
)

.mm_type_hint <- function(x) {
  words <- stringi::stri_trans_general(stringi::stri_trans_tolower(mn_translit(x, to = "nso")), "Latin-ASCII")
  words <- strsplit(gsub("[^a-z]+", " ", words), " ", fixed = TRUE)
  purrr::map(words, function(w) {
    for (h in .mm_type_hints) {
      if (any(h$words %in% w)) {
        return(h$types)
      }
    }
    NULL
  })
}

# Resolves `within` values (names or codes) to pcodes. Unmatched values are an
# error. Ambiguous values are an error too, unless `allow_multiple` is TRUE:
# then every candidate is kept, joined with "|".
.mm_resolve_within <- function(within, levels = NULL, parent = NULL, allow_multiple = FALSE,
                               arg = "within", call = rlang::caller_env()) {
  if (is.null(within)) {
    return(NULL)
  }
  w <- unique(as.character(within[!is.na(within)]))
  if (!length(w)) {
    return(NULL)
  }
  m <- .mm_match_df(w, levels = levels, within = parent)
  if (allow_multiple) {
    amb <- m$status == "ambiguous"
    m$pcode[amb] <- purrr::map_chr(m$candidates[amb], \(cand) paste(cand, collapse = "|"))
    m$status[amb] <- "exact"
  }
  bad <- m$status %in% c("ambiguous", "unmatched", "missing")
  if (any(bad)) {
    detail <- purrr::map2_chr(m$x[bad], m$status[bad], function(value, status) {
      if (status == "ambiguous") {
        cand <- m$candidates[[match(value, m$x)]]
        paste0(.mm_esc(value), " matches ", .mm_esc(.mm_describe(cand)))
      } else {
        paste0(.mm_esc(value), " matches nothing")
      }
    })
    .mm_abort(
      c(
        "Can't resolve {.arg {arg}}.",
        rlang::set_names(detail, rep("x", length(detail))),
        "i" = "Use a code from {.fn mn_codes}, such as {.val MN84} for Khovd."
      ),
      "input",
      call = call
    )
  }
  .mm_report_match(m, quiet = FALSE)
  rlang::set_names(m$pcode, w)
}

# Matches `x` and returns one row per element: the pcode, how it matched,
# and candidates or suggestions for values that did not match.
.mm_match_df <- function(x, levels = NULL, within = NULL, fuzzy = TRUE, max_dist = NULL, call = rlang::caller_env()) {
  x <- as.character(x)
  n <- length(x)
  if (n == 0) {
    return(tibble::tibble(
      x = character(), within_pcode = character(), pcode = character(), status = character(),
      alias = character(), candidates = list(), suggestion = character()
    ))
  }
  if (!is.null(within) && !length(within) %in% c(1L, n)) {
    .mm_abort("{.arg within} must have length 1 or the same length as {.arg x}.", "input", call = call)
  }
  within_pcode <- if (is.null(within)) {
    rep(NA_character_, n)
  } else {
    wmap <- .mm_resolve_within(within, allow_multiple = TRUE, call = call)
    if (is.null(wmap)) rep(NA_character_, n) else unname(wmap[rep_len(as.character(within), n)])
  }

  pairs <- unique(data.frame(x = x, within_pcode = within_pcode, stringsAsFactors = FALSE))
  pairs$pcode <- NA_character_
  pairs$status <- NA_character_
  pairs$alias <- NA_character_
  pairs$candidates <- vector("list", nrow(pairs))
  pairs$suggestion <- NA_character_

  trimmed <- stringi::stri_trim_both(pairs$x)
  missing <- is.na(trimmed) | trimmed == ""
  pairs$status[missing] <- "missing"

  # Codes: P-codes, ISO 3166-2 codes and NSO codes.
  up <- toupper(trimmed)
  code_pc <- ifelse(up %in% .mm_units$pcode, up, NA_character_)
  code_pc <- ifelse(is.na(code_pc), .mm_units$pcode[match(up, toupper(.mm_units$iso_code), incomparables = NA)], code_pc)
  is_digits <- grepl("^[0-9]+$", trimmed)
  code_pc <- ifelse(is.na(code_pc) & is_digits, .mm_units$pcode[match(trimmed, .mm_units$nso_code)], code_pc)
  code_hit <- !missing & !is.na(code_pc)
  for (i in which(code_hit)) {
    code_hit[i] <- (is.null(levels) || .mm_units$level[match(code_pc[i], .mm_units$pcode)] %in% levels) &&
      .mm_within_ok(code_pc[i], pairs$within_pcode[i])
  }
  pairs$pcode[code_hit] <- code_pc[code_hit]
  pairs$status[code_hit] <- "code"

  priority <- if (is.null(levels)) .mm_level_priority else intersect(.mm_level_priority, levels)
  keys <- .mm_key(pairs$x)
  hints <- .mm_type_hint(pairs$x)

  # Names: exact key lookup.
  for (i in which(is.na(pairs$status))) {
    cand <- .mm_candidates(keys[[i]], priority, pairs$within_pcode[[i]], hints[[i]])
    if (length(cand) == 1) {
      pairs$pcode[i] <- cand
      pairs$status[i] <- "exact"
    } else if (length(cand) > 1) {
      pairs$status[i] <- "ambiguous"
      pairs$candidates[[i]] <- cand
    }
  }

  # Names: fuzzy lookup.
  for (i in which(is.na(pairs$status))) {
    fz <- .mm_fuzzy(keys[[i]], priority, pairs$within_pcode[[i]], hints[[i]], max_dist)
    if (fuzzy && length(fz$pcode) == 1) {
      pairs$pcode[i] <- fz$pcode
      pairs$status[i] <- "fuzzy"
      pairs$alias[i] <- fz$alias
    } else {
      pairs$status[i] <- "unmatched"
      pairs$suggestion[i] <- fz$suggestion
    }
  }

  idx <- match(paste(x, within_pcode, sep = "
"), paste(pairs$x, pairs$within_pcode, sep = "
"))
  tibble::as_tibble(pairs[idx, , drop = FALSE])
}

# `within` holds one pcode, several joined with "|", or NA for no limit.
.mm_within_targets <- function(within_pcode) {
  if (is.na(within_pcode)) NULL else strsplit(within_pcode, "|", fixed = TRUE)[[1]]
}

.mm_within_ok <- function(pcode, within_pcode) {
  targets <- .mm_within_targets(within_pcode)
  is.null(targets) || .mm_in_targets(pcode, targets, include_self = FALSE)
}

# Aliases in scope: the wanted levels, inside `within`, and of the type the
# name hints at (when that leaves anything).
.mm_scope <- function(a, priority, within_pcode, hint) {
  a <- a[a$level %in% priority, ]
  targets <- .mm_within_targets(within_pcode)
  if (!is.null(targets) && nrow(a)) {
    a <- a[.mm_in_targets(a$pcode, targets, include_self = FALSE), ]
  }
  if (!is.null(hint) && nrow(a)) {
    typed <- .mm_units$type[match(a$pcode, .mm_units$pcode)] %in% hint
    if (any(typed)) a <- a[typed, ]
  }
  a
}

# Distinct pcodes for an exact key, taken from the first level (in priority
# order) that has any.
.mm_candidates <- function(key, priority, within_pcode, hint = NULL) {
  if (is.na(key) || key == "") {
    return(character())
  }
  a <- .mm_scope(.mm_aliases[.mm_aliases$key == key, ], priority, within_pcode, hint)
  if (!nrow(a)) {
    return(character())
  }
  top <- priority[priority %in% a$level][1]
  unique(a$pcode[a$level == top])
}

.mm_fuzzy <- function(key, priority, within_pcode, hint, max_dist) {
  none <- list(pcode = character(), alias = NA_character_, suggestion = NA_character_)
  if (is.na(key) || key == "") {
    return(none)
  }
  a <- .mm_scope(.mm_aliases, priority, within_pcode, hint)
  if (!nrow(a)) {
    return(none)
  }
  d <- as.vector(utils::adist(key, a$key))
  thr <- max_dist %||% .mm_fuzzy_threshold(key)
  best <- min(d)
  near <- d <= thr + 1
  if (length(priority) > 1 && any(near & a$level != "bag")) near <- near & a$level != "bag"
  suggestion <- if (any(near)) {
    ranked <- unique(a$pcode[near][order(d[near])])
    .mm_describe(ranked[seq_len(min(3, length(ranked)))])
  } else {
    NA_character_
  }
  if (best > thr) {
    return(list(pcode = character(), alias = NA_character_, suggestion = suggestion))
  }
  hits <- a[d == best, ]
  top <- priority[priority %in% hits$level][1]
  hits <- hits[hits$level == top, ]
  pc <- unique(hits$pcode)
  if (length(pc) != 1) {
    return(list(pcode = character(), alias = NA_character_, suggestion = .mm_describe(pc)))
  }
  list(pcode = pc, alias = hits$alias[1], suggestion = NA_character_)
}

# "Khovd (MN84)" style labels for messages.
.mm_describe <- function(pcodes) {
  u <- .mm_units[match(pcodes, .mm_units$pcode), ]
  parent <- .mm_units$name_en[match(u$parent_pcode, .mm_units$pcode)]
  in_parent <- ifelse(u$level %in% c("soum", "bag") & !is.na(parent), paste0(", ", parent), "")
  paste0(u$name_en, " (", u$pcode, in_parent, ")", collapse = "; ")
}

.mm_bullets <- function(lines, max = 10) {
  extra <- length(lines) - max
  if (extra > 0) lines <- c(lines[seq_len(max)], paste0("... and ", extra, " more"))
  rlang::set_names(.mm_esc(lines), rep("*", length(lines)))
}

.mm_report_match <- function(res, quiet = FALSE) {
  u <- res[!duplicated(res[c("x", "within_pcode")]), ]
  fz <- u[u$status %in% "fuzzy", ]
  if (nrow(fz) && !quiet) {
    arrow <- cli::symbol$arrow_right
    .mm_inform(
      c("i" = "Matched {nrow(fz)} value{?s} approximately; please check:", .mm_bullets(paste(fz$x, arrow, .mm_describe_each(fz$pcode)))),
      class = "fuzzy_match"
    )
  }
  amb <- u[u$status %in% "ambiguous", ]
  if (nrow(amb)) {
    lines <- purrr::map2_chr(amb$x, amb$candidates, \(v, cand) paste0(v, ": ", .mm_describe(cand)))
    .mm_warn(
      c(
        "{nrow(amb)} value{?s} {?matches/match} more than one unit and became {.val NA}:",
        .mm_bullets(lines),
        "i" = "Use {.arg within} (for example the aimag) to choose one."
      ),
      class = "ambiguous"
    )
  }
  um <- u[u$status %in% "unmatched", ]
  if (nrow(um)) {
    lines <- ifelse(is.na(um$suggestion), um$x, paste0(um$x, " (did you mean ", um$suggestion, "?)"))
    .mm_warn(
      c("{nrow(um)} value{?s} could not be matched and became {.val NA}:", .mm_bullets(lines)),
      class = "unmatched"
    )
  }
  invisible(res)
}

.mm_describe_each <- function(pcodes) {
  purrr::map_chr(pcodes, .mm_describe)
}
