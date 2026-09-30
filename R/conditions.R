# Typed conditions. Every error carries "mongolmaps_error" plus a specific
# class, so callers can catch them with tryCatch().

.mm_abort <- function(message, class, ..., call = rlang::caller_env(), .envir = parent.frame()) {
  cli_abort(
    message,
    class = c(paste0("mongolmaps_", class, "_error"), "mongolmaps_error"),
    ...,
    call = call,
    .envir = .envir
  )
}

.mm_warn <- function(message, class, ..., .envir = parent.frame()) {
  cli_warn(message, class = c(paste0("mongolmaps_", class), "mongolmaps_warning"), ..., .envir = .envir)
}

.mm_inform <- function(message, class = NULL, ..., .envir = parent.frame()) {
  if (isTRUE(getOption("mongolmaps.quiet", FALSE))) {
    return(invisible())
  }
  cli_inform(message, class = c(if (!is.null(class)) paste0("mongolmaps_", class), "mongolmaps_message"), ..., .envir = .envir)
}

# Escapes text for safe use inside cli templates.
.mm_esc <- function(x) {
  gsub("}", "}}", gsub("{", "{{", x, fixed = TRUE), fixed = TRUE)
}
