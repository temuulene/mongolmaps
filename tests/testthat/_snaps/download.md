# .mm_asset() downloads once, verifies and caches

    Code
      path <- .mm_asset("fake")
    Message
      i Downloading Fake layer (0.0 MB); this happens once.

# .mm_asset() rejects corrupt mirrored downloads

    Code
      .mm_asset("fake")
    Message
      i Downloading Fake layer (0.0 MB); this happens once.
    Condition
      Error:
      ! The download of Fake layer is corrupt (checksum mismatch).
      i Try again; if it keeps failing, report it at <https://github.com/temuulene/mongolmaps/issues>.

# upstream checksum changes only warn

    Code
      path <- .mm_asset("fake")
    Message
      i Downloading Fake layer (0.0 MB); this happens once.
    Condition
      Warning:
      Fake layer changed upstream since this package version (checksum mismatch).
      i Using it anyway; results may differ from the documented data.

# offline mode stops downloads with a clear error

    Code
      .mm_asset("fake")
    Condition
      Error:
      ! Can't download Fake layer: offline mode is on.
      i Turn it off with `options(mongolmaps.offline = FALSE)`, or prefetch layers with `mn_download()`.

# no internet stops downloads with a clear error

    Code
      .mm_asset("fake")
    Condition
      Error:
      ! Can't download Fake layer: no internet connection.
      i Layers are downloaded once and cached; prefetch them with `mn_download()` while online.

# .mm_http_download() turns HTTP failures into typed errors

    Code
      .mm_http_download("https://example.org/missing.gpkg", path)
    Condition
      Error:
      ! Download failed (status 404) [https://example.org/missing.gpkg].
      Caused by error in `httr2::req_perform()`:
      ! HTTP 404 Not Found.

# .mm_manifest_row() finds layers and rejects unknown ones

    Code
      .mm_manifest_row("nope")
    Condition
      Error:
      ! Unknown data layer "nope". See `mn_sources()`.

