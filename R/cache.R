#' Manage downloaded map data
#'
#' Full-resolution boundaries and the larger thematic layers are downloaded
#' the first time you use them and kept in a cache folder, so later calls
#' work offline.
#'
#' * `mn_cache_dir()` returns the cache folder. Change it with
#'   `options(mongolmaps.cache_dir = "path")`.
#' * `mn_cache_list()` lists what is cached.
#' * `mn_cache_clear()` deletes cached files.
#' * `mn_download()` downloads layers now, for example before fieldwork
#'   without internet. See [mn_sources()] for the layer ids.
#'
#' @param layers Layer ids or groups (see [mn_sources()]), such as
#'   `"admin_high"` or `"osm"`. `NULL` (the default for `mn_cache_clear()`)
#'   means all; `"all"` (the default for `mn_download()`) means every
#'   downloadable layer.
#' @param old_versions If `TRUE`, `mn_cache_clear()` removes only data left
#'   by older versions of the package.
#'
#' @return `mn_cache_dir()`: a path. `mn_cache_list()`: a tibble with one
#'   row per cached file. `mn_cache_clear()` and `mn_download()`: the
#'   affected paths, invisibly.
#' @family data sources and cache
#' @export
#' @examples
#' mn_cache_dir()
#' mn_cache_list()
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' mn_download("admin_high")
mn_cache_dir <- function() {
  getOption("mongolmaps.cache_dir") %||% tools::R_user_dir("mongolmaps", which = "cache")
}

#' @rdname mn_cache_dir
#' @export
mn_cache_list <- function() {
  root <- mn_cache_dir()
  files <- list.files(root, recursive = TRUE, full.names = TRUE)
  files <- files[!grepl("\\.(sha256|part)$", files)]
  if (!length(files)) {
    return(tibble::tibble(data_version = character(), file = character(), size_mb = numeric(), path = character()))
  }
  rel <- substring(normalizePath(files, winslash = "/"), nchar(normalizePath(root, winslash = "/")) + 2)
  tibble::tibble(
    data_version = sub("/.*$", "", rel),
    file = sub("^[^/]*/", "", rel),
    size_mb = round(file.size(files) / 1024^2, 2),
    path = files
  )
}

#' @rdname mn_cache_dir
#' @export
mn_cache_clear <- function(layers = NULL, old_versions = FALSE) {
  root <- mn_cache_dir()
  if (old_versions) {
    return(invisible(.mm_prune_versions(.mm_data_version)))
  }
  if (is.null(layers)) {
    targets <- list.files(root, full.names = TRUE)
  } else {
    m <- .mm_manifest()
    layers <- .mm_expand_layers(layers, m)
    rows <- m[m$id %in% layers & m$delivery != "bundled", ]
    dir <- file.path(root, rows$data_version)
    targets <- c(
      file.path(dir, rows$file), paste0(file.path(dir, rows$file), ".sha256"), file.path(dir, rows$id)
    )
  }
  targets <- targets[file.exists(targets)]
  unlink(targets, recursive = TRUE)
  .mm_inform(c("v" = "Removed {length(targets)} cached item{?s}."), class = "cache")
  invisible(targets)
}

#' @rdname mn_cache_dir
#' @export
mn_download <- function(layers = "all") {
  m <- .mm_manifest()
  m <- m[m$delivery != "bundled" & !is.na(m$file), ]
  remote <- m$id
  if (identical(layers, "all")) {
    layers <- remote
  }
  layers <- .mm_expand_layers(layers, m)
  unknown <- setdiff(layers, remote)
  if (length(unknown)) {
    .mm_abort(
      c("Unknown downloadable layer{?s}: {.val {unknown}}.", "i" = "Downloadable layers: {.val {remote}}."),
      "input"
    )
  }
  paths <- purrr::map_chr(layers, .mm_asset)
  invisible(rlang::set_names(paths, layers))
}

# Replaces group names (such as "osm") with the ids of their layers.
.mm_expand_layers <- function(layers, m) {
  unique(unlist(purrr::map(layers, \(l) if (l %in% m$group) m$id[m$group == l] else l)))
}
