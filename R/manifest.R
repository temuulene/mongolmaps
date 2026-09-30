# The manifest (inst/extdata/manifest.csv) lists every data layer: where it
# comes from, its licence, and for downloaded layers the URL and checksum.

.mm_manifest <- function() {
  if (is.null(.mm_env$manifest)) {
    path <- system.file("extdata", "manifest.csv", package = "mongolmaps")
    m <- utils::read.csv(path, colClasses = "character", encoding = "UTF-8", na.strings = "")
    .mm_env$manifest <- tibble::as_tibble(m)
  }
  .mm_env$manifest
}

.mm_manifest_row <- function(id, call = rlang::caller_env()) {
  m <- .mm_manifest()
  row <- m[m$id == id, ]
  if (nrow(row) != 1) {
    .mm_abort("Unknown data layer {.val {id}}. See {.fn mn_sources}.", "input", call = call)
  }
  row
}

.mm_asset_url <- function(row) {
  base <- getOption("mongolmaps.release_url")
  if (!is.null(base) && row$delivery == "release") {
    return(paste0(sub("/?$", "/", base), row$file))
  }
  row$url
}
