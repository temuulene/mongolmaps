test_that("mn_cache_dir() follows the option", {
  withr::local_options(mongolmaps.cache_dir = "somewhere")
  expect_equal(mn_cache_dir(), "somewhere")
})

test_that("mn_cache_dir() defaults to the user cache directory", {
  withr::local_options(mongolmaps.cache_dir = NULL)
  expect_equal(mn_cache_dir(), tools::R_user_dir("mongolmaps", which = "cache"))
})

test_that("mn_cache_list() and mn_cache_clear() manage files", {
  withr::local_options(mongolmaps.cache_dir = withr::local_tempdir())
  expect_equal(nrow(mn_cache_list()), 0)
  dir.create(file.path(mn_cache_dir(), "data-v1"), recursive = TRUE)
  writeLines("x", file.path(mn_cache_dir(), "data-v1", "admin_high.gpkg.zip"))
  writeLines("abc", file.path(mn_cache_dir(), "data-v1", "admin_high.gpkg.zip.sha256"))
  listing <- mn_cache_list()
  expect_equal(listing$file, "admin_high.gpkg.zip")
  expect_equal(listing$data_version, "data-v1")
  expect_snapshot(mn_cache_clear("admin_high"))
  expect_equal(nrow(mn_cache_list()), 0)
})

test_that("old data versions are pruned", {
  withr::local_options(mongolmaps.cache_dir = withr::local_tempdir())
  dir.create(file.path(mn_cache_dir(), "data-v0"), recursive = TRUE)
  writeLines("old", file.path(mn_cache_dir(), "data-v0", "old.gpkg"))
  dir.create(file.path(mn_cache_dir(), "data-v1"))
  expect_snapshot(mn_cache_clear(old_versions = TRUE))
  expect_false(dir.exists(file.path(mn_cache_dir(), "data-v0")))
  expect_true(dir.exists(file.path(mn_cache_dir(), "data-v1")))
})

test_that("mn_download() rejects unknown layers and fetches known ones", {
  expect_snapshot(mn_download("nope"), error = TRUE)
  local_mocked_bindings(.mm_asset = function(id, ...) paste0("/cache/", id))
  expect_equal(mn_download("admin_high"), c(admin_high = "/cache/admin_high"))
  expect_true("admin_high" %in% names(mn_download()))
})

test_that("mn_cache_clear() with no layers empties the cache", {
  withr::local_options(mongolmaps.cache_dir = withr::local_tempdir())
  dir.create(file.path(mn_cache_dir(), "data-v1"))
  writeLines("x", file.path(mn_cache_dir(), "data-v1", "a.gpkg"))
  suppressMessages(mn_cache_clear())
  expect_equal(nrow(mn_cache_list()), 0)
})
