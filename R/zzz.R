# nocov start
.onLoad <- function(libname, pkgname) {
  defaults <- list(
    mongolmaps.lang = "en",
    mongolmaps.offline = FALSE,
    mongolmaps.timeout = 600,
    mongolmaps.retry_tries = 3L,
    mongolmaps.quiet = FALSE
  )
  unset <- !(names(defaults) %in% names(options()))
  if (any(unset)) options(defaults[unset])
  invisible()
}
# nocov end
