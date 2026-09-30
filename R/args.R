.mm_levels <- c("country", "region", "aimag", "soum", "bag")

.mm_level_synonyms <- c(
  country = "country", adm0 = "country", national = "country", mongolia = "country",
  region = "region", regions = "region",
  aimag = "aimag", aimags = "aimag", adm1 = "aimag", province = "aimag", provinces = "aimag",
  soum = "soum", soums = "soum", sum = "soum", adm2 = "soum", district = "soum", districts = "soum", duureg = "soum",
  bag = "bag", bags = "bag", adm3 = "bag", khoroo = "bag", khoroos = "bag", horoo = "bag"
)

# Canonical level names from user input; NULL stays NULL (meaning any level).
.mm_arg_level <- function(level, multiple = FALSE, arg = rlang::caller_arg(level), call = rlang::caller_env()) {
  if (is.null(level)) {
    return(NULL)
  }
  if (!is.character(level) || !length(level) || anyNA(level) || (!multiple && length(level) != 1)) {
    .mm_abort(
      "{.arg {arg}} must be {if (multiple) 'a character vector' else 'a single string'} naming a level, such as {.val aimag}.",
      "input",
      call = call
    )
  }
  out <- unname(.mm_level_synonyms[tolower(trimws(level))])
  bad <- level[is.na(out)]
  if (length(bad)) {
    .mm_abort(
      c(
        "{.arg {arg}} has an unknown level: {.val {bad}}.",
        "i" = "Use one of {.or {.val {(.mm_levels)}}}."
      ),
      "input",
      call = call
    )
  }
  unique(out)
}

.mm_arg_lang <- function(lang, arg = rlang::caller_arg(lang), call = rlang::caller_env()) {
  force(arg)
  lang <- lang %||% getOption("mongolmaps.lang", "en")
  rlang::arg_match0(lang, c("en", "mn", "mns"), arg_nm = arg, error_call = call)
}

.mm_arg_resolution <- function(resolution, arg = rlang::caller_arg(resolution), call = rlang::caller_env()) {
  force(arg)
  rlang::arg_match0(resolution[[1]], c("low", "high"), arg_nm = arg, error_call = call)
}

.mm_check_string <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!is.character(x) || length(x) != 1 || is.na(x)) {
    .mm_abort("{.arg {arg}} must be a single string.", "input", call = call)
  }
  invisible(x)
}
