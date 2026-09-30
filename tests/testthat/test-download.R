local_fake_asset <- function(env = parent.frame(), sha = NULL, delivery = "release") {
  withr::local_options(mongolmaps.cache_dir = withr::local_tempdir(.local_envir = env), .local_envir = env)
  src <- withr::local_tempfile(fileext = ".txt", .local_envir = env)
  writeLines("hello mongolia", src)
  row <- tibble::tibble(
    id = "fake", title = "Fake layer", delivery = delivery, data_version = "data-v1",
    file = "fake.txt", url = "https://example.org/fake.txt", fallback_url = NA_character_,
    sha256 = sha %||% .mm_sha256(src), bytes = "15"
  )
  testthat::local_mocked_bindings(.mm_manifest_row = function(id, ...) row, .env = env)
  src
}

test_that(".mm_asset() downloads once, verifies and caches", {
  src <- local_fake_asset()
  calls <- 0
  local_mocked_bindings(
    .mm_http_download = function(url, path) {
      calls <<- calls + 1
      file.copy(src, path)
      invisible(path)
    }
  )
  expect_snapshot(path <- .mm_asset("fake"))
  expect_equal(readLines(path), "hello mongolia")
  expect_true(file.exists(paste0(path, ".sha256")))
  .mm_asset("fake")
  expect_equal(calls, 1)
  expect_equal(nrow(mn_cache_list()), 1)
})

test_that(".mm_asset() rejects corrupt mirrored downloads", {
  src <- local_fake_asset(sha = "0000")
  local_mocked_bindings(.mm_http_download = function(url, path) file.copy(src, path))
  expect_snapshot(.mm_asset("fake"), error = TRUE)
  expect_false(file.exists(file.path(mn_cache_dir(), "data-v1", "fake.txt")))
})

test_that("upstream checksum changes only warn", {
  src <- local_fake_asset(sha = "0000", delivery = "upstream")
  local_mocked_bindings(.mm_http_download = function(url, path) file.copy(src, path))
  expect_snapshot(path <- .mm_asset("fake"))
  expect_true(file.exists(path))
})

test_that("offline mode stops downloads with a clear error", {
  local_fake_asset()
  withr::local_options(mongolmaps.offline = TRUE)
  expect_snapshot(.mm_asset("fake"), error = TRUE)
})

test_that("no internet stops downloads with a clear error", {
  local_fake_asset()
  local_mocked_bindings(has_internet = function() FALSE, .package = "curl")
  expect_snapshot(.mm_asset("fake"), error = TRUE)
})

test_that(".mm_http_download() turns HTTP failures into typed errors", {
  withr::local_options(mongolmaps.retry_tries = 1L)
  httr2::local_mocked_responses(function(req) httr2::response(status_code = 404))
  path <- withr::local_tempfile()
  expect_snapshot(.mm_http_download("https://example.org/missing.gpkg", path), error = TRUE)
  err <- tryCatch(.mm_http_download("https://example.org/missing.gpkg", path), error = identity)
  expect_s3_class(err, "mongolmaps_http_error")
})

test_that(".mm_http_download() writes the response body", {
  httr2::local_mocked_responses(function(req) httr2::response(status_code = 200, body = charToRaw("data")))
  path <- withr::local_tempfile()
  .mm_http_download("https://example.org/ok.txt", path)
  expect_equal(readLines(path, warn = FALSE), "data")
})

test_that("zip assets are unpacked next to the download", {
  dir <- withr::local_tempdir()
  inner <- file.path(dir, "layer.gpkg")
  writeLines("x", inner)
  zip <- file.path(dir, "layer.gpkg.zip")
  withr::with_dir(dir, utils::zip(zip, "layer.gpkg", flags = "-q"))
  out <- .mm_unpacked(list(id = "layer"), zip)
  expect_equal(basename(out), "layer.gpkg")
  expect_true(file.exists(out))
})

test_that("the release URL can be overridden", {
  row <- list(delivery = "release", file = "a.zip", url = "https://github.com/x/a.zip")
  expect_equal(.mm_asset_url(row), "https://github.com/x/a.zip")
  withr::local_options(mongolmaps.release_url = "https://mirror.example.org/data")
  expect_equal(.mm_asset_url(row), "https://mirror.example.org/data/a.zip")
})

test_that("the fallback URL is tried when the release fails", {
  src <- local_fake_asset()
  row <- .mm_manifest_row("fake")
  row$fallback_url <- "https://mirror.example.org/fake.txt"
  local_mocked_bindings(.mm_manifest_row = function(id, ...) row)
  tried <- character()
  local_mocked_bindings(.mm_http_download = function(url, path) {
    tried <<- c(tried, url)
    if (grepl("example.org/fake", url) && !grepl("mirror", url)) .mm_abort("boom", "http")
    file.copy(src, path)
  })
  suppressMessages(.mm_asset("fake"))
  expect_equal(tried, c("https://example.org/fake.txt", "https://mirror.example.org/fake.txt"))
})

test_that("downloads show progress in interactive sessions", {
  rlang::local_interactive(TRUE)
  httr2::local_mocked_responses(function(req) httr2::response(status_code = 200, body = charToRaw("ok")))
  path <- withr::local_tempfile()
  .mm_http_download("https://example.org/ok.txt", path)
  expect_true(file.exists(path))
})

test_that("zip files whose content has another name unpack to a folder", {
  dir <- withr::local_tempdir()
  writeLines("x", file.path(dir, "other.gpkg"))
  zip <- file.path(dir, "layer.gpkg.zip")
  withr::with_dir(dir, utils::zip(zip, "other.gpkg", flags = "-q"))
  out <- .mm_unpacked(list(id = "layer"), zip)
  expect_true(dir.exists(out))
  expect_true(file.exists(file.path(out, "other.gpkg")))
})

test_that(".mm_manifest_row() finds layers and rejects unknown ones", {
  expect_equal(.mm_manifest_row("admin_high")$delivery, "release")
  expect_snapshot(.mm_manifest_row("nope"), error = TRUE)
})

test_that("downloading an upstream file never prunes the current data version", {
  withr::local_options(mongolmaps.cache_dir = withr::local_tempdir())
  current <- file.path(mn_cache_dir(), .mm_data_version)
  dir.create(current, recursive = TRUE)
  writeLines("keep", file.path(current, "admin_high.gpkg.zip"))
  src <- withr::local_tempfile()
  writeLines("x", src)
  row <- tibble::tibble(
    id = "up", title = "Upstream", delivery = "upstream", data_version = "upstream", file = "up.txt",
    url = "https://example.org/up.txt", fallback_url = NA_character_, sha256 = NA_character_, bytes = NA_character_
  )
  local_mocked_bindings(.mm_http_download = function(url, path) file.copy(src, path))
  suppressMessages(.mm_asset_row(row))
  expect_true(file.exists(file.path(current, "admin_high.gpkg.zip")))
})

test_that("the last mirror's error is reported when every URL fails", {
  local_fake_asset()
  row <- .mm_manifest_row("fake")
  row$fallback_url <- "https://mirror.example.org/fake.txt"
  local_mocked_bindings(.mm_manifest_row = function(id, ...) row)
  local_mocked_bindings(.mm_http_download = function(url, path) .mm_abort("{url} is down", "http"))
  expect_error(suppressMessages(.mm_asset("fake")), "mirror.example.org", class = "mongolmaps_http_error")
})
