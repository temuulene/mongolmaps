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

test_that("mn_bags() explains how to get bag boundaries", {
  withr::local_options(mongolmaps.bags_path = NULL)
  expect_snapshot(mn_bags(), error = TRUE)
})

test_that("mn_read_bags() reads NSO codes or pcodes and returns pcodes", {
  path <- local_bag_file()
  bags <- mn_read_bags(path)
  expect_s3_class(bags, "sf")
  expect_named(bags, c("pcode", "geometry"))
  expect_match(bags$pcode, "^MN84[0-9]{4}$")
  expect_equal(mn_read_bags(local_bag_file(code = "pcode"))$pcode, bags$pcode)
})

test_that("mn_bags() returns bags in the shared schema, filtered", {
  path <- local_bag_file()
  bags <- mn_bags(path = path)
  expect_mn_schema(bags, "bag")
  expect_equal(unique(bags$type), "bag")
  expect_equal(nrow(mn_bags(aimag = "Khovd", soum = "Jargalant", path = path)), 1)
  expect_equal(nrow(mn_bags(soum = "MN8401", path = path)), 1)
  expect_equal(nrow(mn_bags(aimag = "Uvs", path = path)), 0)
})

test_that("registered bags join the bag level", {
  withr::local_options(mongolmaps.bags_path = local_bag_file())
  all_bags <- mn_admin("bag")
  expect_equal(sum(all_bags$type == "khoroo"), 204)
  expect_gt(sum(all_bags$type == "bag"), 10)
  expect_equal(nrow(mn_bags(aimag = "Khovd")), sum(all_bags$type == "bag"))
})

test_that("mn_read_bags() rejects bad files", {
  expect_snapshot(mn_read_bags("no-such-file.gpkg"), error = TRUE)
  expect_snapshot(mn_read_bags(local_bag_file(shift = TRUE)), error = TRUE)

  bad <- sf::st_sf(id = c("9999999", "1234567"), geometry = sf::st_geometry(mn_aimags()[1:2, ]))
  path <- withr::local_tempfile(fileext = ".gpkg")
  sf::st_write(bad, path, quiet = TRUE)
  scrub <- \(x) gsub("'[^']*[.]gpkg'", "'<file>.gpkg'", x)
  expect_snapshot(mn_read_bags(path), error = TRUE, transform = scrub)
  expect_snapshot(mn_read_bags(path, code_col = "id"), error = TRUE)
})

test_that("mn_read_bags() can skip the nesting check", {
  expect_s3_class(mn_read_bags(local_bag_file(shift = TRUE), check_nesting = FALSE), "sf")
})

test_that("mn_bags() refuses ambiguous soum names", {
  expect_snapshot(mn_bags(soum = "Jargalant", path = local_bag_file()), error = TRUE)
})

test_that("mn_read_bags() needs a path and a coordinate system", {
  expect_snapshot(mn_read_bags(NULL), error = TRUE)
  x <- sf::st_sf(code = "1840151", geometry = sf::st_set_crs(sf::st_geometry(mn_soums(aimag = "Khovd")[1, ]), NA))
  path <- withr::local_tempfile(fileext = ".shp")
  suppressWarnings(sf::st_write(x, path, quiet = TRUE))
  expect_snapshot(mn_read_bags(path), error = TRUE, transform = \(x) gsub("'[^']*[.]shp'", "'<file>.shp'", x))
})
