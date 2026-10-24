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
.mm_asset_row <- function(row, call = rlang::caller_env(), refresh = FALSE, allow_stale = FALSE) {
  dir <- file.path(mn_cache_dir(), row$data_version)
  dest <- file.path(dir, row$file)
  valid <- .mm_cached_ok(dest, row)
  if (refresh || !valid) {
    tryCatch(
      .mm_fetch(row, dest, call = call),
      mongolmaps_error = function(e) {
        if (!allow_stale || !valid) stop(e)
        .mm_warn("Refresh failed; using the previously cached {.field {row$title}}. {conditionMessage(e)}", "stale_cache")
      }
    )
  }
  .mm_unpacked(row, dest)
}

.mm_cached_ok <- function(dest, row, verify = getOption("mongolmaps.verify_cache", TRUE)) {
  side <- paste0(dest, ".sha256")
  if (!file.exists(dest) || !file.exists(side)) return(FALSE)
  sha <- tryCatch(readLines(side, warn = FALSE)[1], error = function(e) NA_character_)
  if (is.na(sha) || !grepl("^[0-9a-f]{64}$", sha)) return(FALSE)
  expected <- row$sha256
  if (!is.na(expected) && !identical(sha, expected)) return(FALSE)
  !isTRUE(verify) || identical(.mm_sha256(dest), sha)
}

.mm_fetch <- function(row, dest, call = rlang::caller_env()) {
  if (isTRUE(getOption("mongolmaps.offline", FALSE))) {
    .mm_abort(
      c(
        "Can't download {.field {row$title}}: offline mode is on.",
        "i" = "Turn it off with {.code options(mongolmaps.offline = FALSE)}, or prefetch layers with {.fn mn_download}."
      ), "offline", call = call
    )
  }
  dir.create(dirname(dest), recursive = TRUE, showWarnings = FALSE)
  lock <- .mm_lock_cache(dest)
  on.exit(unlink(lock, recursive = TRUE), add = TRUE)
  size <- if (is.na(row$bytes)) "" else sprintf(" (%.1f MB)", as.numeric(row$bytes) / 1024^2) # nolint object_usage_linter.
  .mm_inform(c("i" = "Downloading {.field {row$title}}{size}; this happens once."), class = "download")
  tmp <- tempfile(pattern = ".mongolmaps-", tmpdir = dirname(dest), fileext = ".part")
  side <- paste0(tmp, ".sha256")
  on.exit(unlink(c(tmp, side)), add = TRUE)
  urls <- stats::na.omit(c(.mm_asset_url(row), row$fallback_url))
  for (i in seq_along(urls)) {
    ok <- tryCatch({
      .mm_http_download(urls[i], tmp)
      TRUE
    }, mongolmaps_http_error = function(e) {
      if (i == length(urls)) stop(e)
      FALSE
    })
    if (ok) break
  }
  if (!file.exists(tmp)) .mm_abort("The download did not produce a file.", "http", call = call)
  sha <- .mm_sha256(tmp)
  if (!is.na(row$sha256) && !identical(sha, row$sha256)) {
    if (row$delivery == "release") {
      .mm_abort(
        c("The download of {.field {row$title}} is corrupt (checksum mismatch).",
          "i" = "Try again; if it keeps failing, report it at {.url https://github.com/temuulene/mongolmaps/issues}."),
        "checksum", call = call
      )
    }
    .mm_warn(
      c("{.field {row$title}} changed upstream since this package version (checksum mismatch).",
        "i" = "Using it anyway; results may differ from the documented data."),
      class = "checksum_warning"
    )
  }
  .mm_validate_download(row, tmp)
  writeLines(sha, side)
  .mm_publish_files(c(tmp, side), c(dest, paste0(dest, ".sha256")))
  .mm_invalidate_memory()
  if (isTRUE(getOption("mongolmaps.prune_old_versions", FALSE))) .mm_prune_versions(.mm_data_version)
  invisible(dest)
}

# Publish a checked file and checksum together; preserve old files on failure.
.mm_move_file <- function(from, to) file.rename(from, to)

.mm_publish_files <- function(from, to) {
  backups <- vapply(to, function(p) tempfile(".backup-", tmpdir = dirname(p)), character(1))
  old_moved <- new_moved <- rep(FALSE, length(to))
  err <- tryCatch({
    for (i in seq_along(to)) {
      if (file.exists(to[i])) {
        if (!.mm_move_file(to[i], backups[i])) stop("Cannot stage previous cache file.")
        old_moved[i] <- TRUE
      }
    }
    for (i in seq_along(to)) {
      if (!.mm_move_file(from[i], to[i])) stop("Cannot publish replacement cache file.")
      new_moved[i] <- TRUE
    }
    NULL
  }, error = identity)
  if (!is.null(err)) {
    unlink(to[new_moved], recursive = TRUE)
    restored <- vapply(which(old_moved), function(i) .mm_move_file(backups[i], to[i]), logical(1))
    if (!all(restored)) {
      .mm_abort("Cache replacement failed. Previous files remain at {.path {backups[file.exists(backups)]}}.", "cache", parent = err)
    }
    .mm_abort("Cache replacement failed; previous cached files were preserved.", "cache", parent = err)
  }
  unlink(backups, recursive = TRUE)
  invisible(to)
}

.mm_validate_download <- function(row, path) {
  if (row$id != "wdpa") return(invisible(TRUE))
  text <- paste(readLines(path, warn = FALSE), collapse = "")
  if (grepl('"exceededTransferLimit"[[:space:]]*:[[:space:]]*true', text)) {
    .mm_abort("The protected-area service returned an incomplete page; cached data were not replaced.", "http")
  }
  x <- tryCatch(sf::st_read(path, quiet = TRUE), error = function(e) NULL)
  if (is.null(x) || !nrow(x) || !all(c("name_eng", "desig_eng") %in% tolower(names(x)))) {
    .mm_abort("The protected-area download has no usable records or an unexpected schema.", "http")
  }
  invisible(TRUE)
}

.mm_invalidate_memory <- function() {
  keys <- grep("^(high_|bags_)", ls(.mm_env), value = TRUE)
  if (length(keys)) rm(list = keys, envir = .mm_env)
  invisible()
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
  if (!grepl("\\.zip$", dest)) return(dest)
  out_dir <- file.path(dirname(dest), row$id)
  inner <- sub("\\.zip$", "", basename(dest))
  target <- file.path(out_dir, inner)
  marker <- file.path(out_dir, ".archive.sha256")
  sha <- .mm_sha256(dest)
  ready <- file.exists(marker) && identical(readLines(marker, warn = FALSE)[1], sha)
  if (ready && file.exists(target)) {
    content_side <- paste0(target, ".sha256")
    if (file.exists(content_side) && identical(readLines(content_side, warn = FALSE)[1], .mm_sha256(target))) return(target)
    ready <- FALSE
  }
  if (ready && dir.exists(out_dir) && !file.exists(target)) return(out_dir)
  lock <- .mm_lock_cache(paste0(dest, ".extract"))
  on.exit(unlink(lock, recursive = TRUE), add = TRUE)
  stage <- tempfile(".extract-", tmpdir = dirname(dest))
  dir.create(stage)
  on.exit(if (dir.exists(stage)) unlink(stage, recursive = TRUE), add = TRUE)
  members <- tryCatch(utils::unzip(dest, list = TRUE)$Name, error = function(e) character())
  if (!length(members) || any(grepl("(^[/\\\\]|^[A-Za-z]:|(^|[/\\\\])\\.\\.([/\\\\]|$))", members))) {
    .mm_abort("The downloaded archive is empty, unreadable or contains unsafe paths.", "cache")
  }
  files <- tryCatch(
    withCallingHandlers(utils::unzip(dest, exdir = stage), warning = function(w) stop(w)),
    error = function(e) .mm_abort("Could not extract the downloaded archive.", "cache", parent = e)
  )
  if (!length(files) || !all(file.exists(files))) .mm_abort("Archive extraction is incomplete.", "cache")
  staged_target <- file.path(stage, inner)
  if (identical(row$format, "gpkg")) {
    layers <- tryCatch(sf::st_layers(staged_target)$name, error = function(e) character())
    if (!length(layers)) .mm_abort("The extracted GeoPackage has no readable layers.", "cache")
    if (row$id == "admin_high" && !all(c("country", "region", "aimag", "soum", "ub", "ub_district", "khoroo") %in% layers)) {
      .mm_abort("The boundary GeoPackage is missing expected layers.", "cache")
    }
  }
  writeLines(sha, file.path(stage, ".archive.sha256"))
  if (file.exists(staged_target)) writeLines(.mm_sha256(staged_target), paste0(staged_target, ".sha256"))
  .mm_publish_files(stage, out_dir)
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



# Atomic directory creation prevents two sessions publishing the same asset.
.mm_lock_cache <- function(path) {
  lock <- paste0(path, ".lock")
  if (!dir.create(lock, showWarnings = FALSE)) {
    .mm_abort(
      c("Cache asset is busy: {.path {path}}. Retry after the other session finishes.",
        "i" = "Remove an abandoned .lock directory only when no session is using it."),
      "cache_busy"
    )
  }
  lock
}
