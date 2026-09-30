expect_mn_schema <- function(x, level = NULL) {
  testthat::expect_s3_class(x, "sf")
  testthat::expect_s3_class(x, "tbl_df")
  testthat::expect_named(x, c(mongolmaps:::.mm_schema, "geometry"))
  testthat::expect_type(x$pcode, "character")
  testthat::expect_type(x$number, "integer")
  testthat::expect_type(x$area_km2, "double")
  testthat::expect_false(anyDuplicated(x$pcode) > 0)
  if (!is.null(level)) testthat::expect_equal(unique(x$level), level)
  invisible(x)
}

# A stand-in release asset built from the bundled layers, for mocked downloads.
local_admin_high_fixture <- function(env = parent.frame()) {
  dir <- withr::local_tempdir(.local_envir = env)
  gpkg <- file.path(dir, "admin_high.gpkg")
  low <- mongolmaps:::.mm_low
  for (layer in names(low)) {
    sf::st_write(low[[layer]], gpkg, layer = layer, quiet = TRUE)
  }
  gpkg
}
