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

# A synthetic bag file: the soums of Khovd, each standing in for its first bag.
local_bag_file <- function(env = parent.frame(), code = "nso", shift = FALSE) {
  soums <- mn_soums(aimag = "Khovd")
  bags <- mn_codes("bag", within = "Khovd")
  first <- bags[!duplicated(bags$parent_pcode), ]
  soums <- soums[soums$pcode %in% first$parent_pcode, ]
  first <- first[match(soums$pcode, first$parent_pcode), ]
  geom <- sf::st_geometry(soums)
  if (shift) geom <- geom + c(20, 0)
  x <- sf::st_sf(
    bag_code = if (code == "nso") first$nso_code else first$pcode,
    bag_name = first$name_mn,
    geometry = sf::st_set_crs(geom, 4326)
  )
  path <- withr::local_tempfile(fileext = ".gpkg", .local_envir = env)
  sf::st_write(x, path, quiet = TRUE)
  path
}
