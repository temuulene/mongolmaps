# Downloads data layers on first use and keeps them in the cache.
#
# Layout: <cache_dir>/<data_version>/<file>, a <file>.sha256 sidecar written
# after the checksum passes, and for zip files an extracted folder <id>/.

# Local path of a layer, downloading it if needed.
.mm_asset <- function(id, call = rlang::caller_env()) {
  .mm_asset_row(.mm_manifest_row(id, call = call), call = call)
}

# The same for a manifest-like row built at run time (for example one
# WorldPop year).
.mm_asset_row <- function(row, call = rlang::caller_env()) {
  dir <- file.path(mn_cache_dir(), row$data_version)
  dest <- file.path(dir, row$file)
  if (!.mm_cached_ok(dest, row)) {
    .mm_fetch(row, dest, call = call)
  }
  .mm_unpacked(row, dest)
}

.mm_cached_ok <- function(dest, row) {
  side <- paste0(dest, ".sha256")
  file.exists(dest) && file.exists(side) &&
    (is.na(row$sha256) || isTRUE(readLines(side, warn = FALSE)[1] == row$sha256))
}

.mm_fetch <- function(row, dest, call = rlang::caller_env()) {
  if (isTRUE(getOption("mongolmaps.offline", FALSE))) {
    .mm_abort(
      c(
        "Can't download {.field {row$title}}: offline mode is on.",
        "i" = "Turn it off with {.code options(mongolmaps.offline = FALSE)}, or prefetch layers with {.fn mn_download}."
      ),
      "offline",
      call = call
    )
  }
  if (!curl::has_internet()) {
    .mm_abort(
      c(
        "Can't download {.field {row$title}}: no internet connection.",
        "i" = "Layers are downloaded once and cached; prefetch them with {.fn mn_download} while online."
      ),
      "offline",
      call = call
    )
  }
  dir.create(dirname(dest), recursive = TRUE, showWarnings = FALSE)
  size <- if (is.na(row$bytes)) "" else sprintf(" (%.1f MB)", as.numeric(row$bytes) / 1024^2) # nolint object_usage_linter. Used in the cli message.
  .mm_inform(c("i" = "Downloading {.field {row$title}}{size}; this happens once."), class = "download")
  tmp <- paste0(dest, ".part")
  on.exit(unlink(tmp), add = TRUE)
  urls <- stats::na.omit(c(.mm_asset_url(row), row$fallback_url))
  ok <- FALSE
  for (url in urls) {
    ok <- tryCatch(
      {
        .mm_http_download(url, tmp)
        TRUE
      },
      mongolmaps_http_error = function(e) {
        if (url == urls[length(urls)]) rlang::cnd_signal(e)
        FALSE
      }
    )
    if (ok) break
  }
  sha <- .mm_sha256(tmp)
  if (!is.na(row$sha256) && !identical(sha, row$sha256)) {
    if (row$delivery == "release") {
      .mm_abort(
        c(
          "The download of {.field {row$title}} is corrupt (checksum mismatch).",
          "i" = "Try again; if it keeps failing, report it at {.url https://github.com/temuulene/mongolmaps/issues}."
        ),
        "checksum",
        call = call
      )
    }
    .mm_warn(
      c(
        "{.field {row$title}} changed upstream since this package version (checksum mismatch).",
        "i" = "Using it anyway; results may differ from the documented data."
      ),
      class = "checksum_warning"
    )
  }
  file.rename(tmp, dest)
  writeLines(sha, paste0(dest, ".sha256"))
  # Prune relative to the package's data version, never the downloaded
  # row's: upstream files live in their own folder.
  .mm_prune_versions(.mm_data_version)
  invisible(dest)
}

.mm_http_download <- function(url, path) {
  ver <- tryCatch(as.character(utils::packageVersion("mongolmaps")), error = function(e) "dev")
  req <- httr2::request(url) |>
    httr2::req_user_agent(paste0("mongolmaps/", ver, " (https://github.com/temuulene/mongolmaps)")) |>
    httr2::req_timeout(as.numeric(getOption("mongolmaps.timeout", 600))) |>
    httr2::req_retry(max_tries = as.integer(getOption("mongolmaps.retry_tries", 3L)))
  if (rlang::is_interactive() && !isTRUE(getOption("mongolmaps.quiet", FALSE))) {
    req <- httr2::req_progress(req)
  }
  resp <- tryCatch(httr2::req_perform(req, path = path), error = function(e) e)
  if (inherits(resp, "error")) {
    status <- if (inherits(resp, "httr2_http")) httr2::resp_status(resp$resp)
    detail <- paste0(if (!is.null(status)) paste0(" (status ", status, ")"), " [", url, "]") # nolint object_usage_linter. Used in the cli message.
    .mm_abort("Download failed{detail}.", "http", parent = resp, call = NULL)
  }
  if (!file.exists(path) && httr2::resp_has_body(resp)) {
    writeBin(httr2::resp_body_raw(resp), path)
  }
  invisible(path)
}

.mm_sha256 <- function(path) {
  con <- file(path, open = "rb")
  on.exit(close(con))
  as.vector(as.character(openssl::sha256(con)))
}

# Extracts zip files next to the download; returns the path to use.
.mm_unpacked <- function(row, dest) {
  if (!grepl("\\.zip$", dest)) {
    return(dest)
  }
  out_dir <- file.path(dirname(dest), row$id)
  inner <- sub("\\.zip$", "", basename(dest))
  target <- file.path(out_dir, inner)
  if (!file.exists(target)) {
    dir.create(out_dir, showWarnings = FALSE)
    utils::unzip(dest, exdir = out_dir)
  }
  if (file.exists(target)) target else out_dir
}

# Removes cache folders of older data versions.
.mm_prune_versions <- function(keep) {
  root <- mn_cache_dir()
  dirs <- list.dirs(root, recursive = FALSE)
  old <- dirs[basename(dirs) != keep & grepl("^data-v", basename(dirs))]
  if (length(old)) {
    mb <- sum(file.size(list.files(old, recursive = TRUE, full.names = TRUE)), na.rm = TRUE) / 1024^2 # nolint object_usage_linter. Used in the cli message.
    unlink(old, recursive = TRUE)
    .mm_inform(c("i" = "Removed cached data from older versions ({sprintf('%.1f', mb)} MB)."), class = "cache")
  }
  invisible(old)
}
