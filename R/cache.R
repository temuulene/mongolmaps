#' Manage downloaded map data
#'
#' Full-resolution boundaries and the larger thematic layers are downloaded
#' the first time you use them and kept in a cache folder, so later calls
#' work offline.
#'
#' * `mn_cache_dir()` returns the cache folder. Change it with
#'   `options(mongolmaps.cache_dir = "path")`.
#' * `mn_cache_list()` lists what is cached.
#' * `mn_cache_clear()` deletes cached files. Old revisions are retained
#'   unless explicitly removed with `old_versions = TRUE`.
#' * `mn_cache_verify()` hashes downloaded assets to check their integrity.
#' * `mn_assets()` lists concrete assets, including WorldPop years/resolutions.
#' * `mn_download()` downloads layers now, for example before fieldwork
#'   without internet. See [mn_sources()] for the layer ids.
#'
#' @param layers Layer ids or groups (see [mn_sources()]), such as
#'   `"admin_high"` or `"osm"`. `NULL` (the default for `mn_cache_clear()`)
#'   means all; `"all"` (the default for `mn_download()`) means every
#'   fixed-file downloadable layer. WorldPop is opt-in: use `"worldpop"`
#'   for every year/resolution, or an id such as `"worldpop_2025_1km"`.
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
    return(tibble::tibble(data_version = character(), file = character(), size_mb = numeric(), path = character(),
                          modified = as.POSIXct(character()), layer = character(), has_checksum = logical()))
  }
  rel <- substring(normalizePath(files, winslash = "/"), nchar(normalizePath(root, winslash = "/")) + 2)
  out <- tibble::tibble(
    data_version = sub("/.*$", "", rel),
    file = sub("^[^/]*/", "", rel),
    size_mb = round(file.size(files) / 1024^2, 2),
    path = files
  )
  info <- file.info(files)
  out$modified <- info$mtime
  assets <- .mm_assets_manifest()
  idx <- match(out$file, assets$file)
  out$layer <- assets$id[idx]
  out$has_checksum <- file.exists(paste0(files, ".sha256"))
  out
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
    m <- .mm_assets_manifest()
    layers <- .mm_expand_layers(layers, m)
    rows <- m[m$id %in% layers & m$delivery != "bundled", ]
    dir <- file.path(root, rows$data_version)
    targets <- c(
      file.path(dir, rows$file), paste0(file.path(dir, rows$file), ".sha256"), file.path(dir, rows$id)
    )
  }
  targets <- targets[file.exists(targets)]
  unlink(targets, recursive = TRUE)
  .mm_invalidate_memory()
  .mm_inform(c("v" = "Removed {length(targets)} cached item{?s}."), class = "cache")
  invisible(targets)
}

#' @rdname mn_cache_dir
#' @export
mn_download <- function(layers = "all") {
  m <- .mm_assets_manifest()
  remote <- m$id
  if (identical(layers, "all")) {
    layers <- m$id[m$group != "worldpop"]
  }
  layers <- .mm_expand_layers(layers, m)
  unknown <- setdiff(layers, remote)
  if (length(unknown)) {
    .mm_abort(
      c("Unknown downloadable layer{?s}: {.val {unknown}}.", "i" = "Downloadable layers: {.val {remote}}."),
      "input"
    )
  }
  paths <- purrr::map_chr(layers, function(id) {
    if (id %in% .mm_manifest()$id) .mm_asset(id) else .mm_asset_row(m[m$id == id, ])
  })
  invisible(rlang::set_names(paths, layers))
}

# Replaces group names (such as "osm") with the ids of their layers.
.mm_expand_layers <- function(layers, m) {
  unique(unlist(purrr::map(layers, \(l) if (l %in% m$group) m$id[m$group == l] else l)))
}

#' @rdname mn_cache_dir
#' @export
mn_assets <- function() {
  m <- .mm_assets_manifest()
  m[c("id", "title", "group", "data_version", "year", "resolution", "file", "url", "sha256", "bytes")]
}

#' @rdname mn_cache_dir
#' @export
mn_cache_verify <- function(layers = NULL) {
  m <- .mm_assets_manifest()
  if (!is.null(layers)) {
    ids <- .mm_expand_layers(layers, m)
    unknown <- setdiff(ids, m$id)
    if (length(unknown)) .mm_abort("Unknown downloadable layer{?s}: {.val {unknown}}.", "input")
    m <- m[m$id %in% ids, ]
  }
  path <- file.path(mn_cache_dir(), m$data_version, m$file)
  exists <- file.exists(path)
  m <- m[exists, ]
  path <- path[exists]
  recorded <- vapply(paste0(path, ".sha256"), function(p) {
    if (file.exists(p)) readLines(p, warn = FALSE)[1] else NA_character_
  }, character(1))
  actual <- vapply(path, .mm_sha256, character(1))
  expected <- ifelse(is.na(m$sha256), recorded, m$sha256)
  tibble::tibble(id = m$id, path = path, expected_sha256 = expected,
                 actual_sha256 = actual, checksum_ok = !is.na(expected) & expected == actual)
}

.mm_assets_manifest <- function() {
  m <- .mm_manifest()
  m <- m[m$delivery != "bundled" & !is.na(m$file), ]
  m$year <- NA_integer_
  m$resolution <- NA_character_
  pop <- dplyr::bind_rows(lapply(2015:2030, function(y) {
    dplyr::bind_rows(lapply(c("1km", "100m"), function(res) {
      row <- .mm_worldpop_row(y, res)
      row$group <- "worldpop"
      row$year <- y
      row$resolution <- res
      row
    }))
  }))
  dplyr::bind_rows(m, pop)
}
