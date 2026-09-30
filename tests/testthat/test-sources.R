test_that("every layer has a licence, provider and attribution", {
  s <- mn_sources()
  expect_false(anyNA(s$license))
  expect_false(anyNA(s$provider))
  expect_false(anyNA(s$attribution))
  expect_true(all(s$delivery %in% c("bundled", "release", "upstream")))
})

test_that("bundled layers only use licences that allow redistribution", {
  s <- mn_sources()
  bundled <- s$license[s$delivery %in% c("bundled", "release")]
  expect_true(all(grepl("CC BY|CC0|0BSD|Public domain|Open data|ODbL|Copernicus DEM licence", bundled)))
})

test_that("downloadable layers have a URL and checksum", {
  m <- mongolmaps:::.mm_manifest()
  remote <- m[m$delivery == "release", ]
  expect_true(all(startsWith(remote$url, "https://")))
  expect_match(remote$sha256, "^[0-9a-f]{64}$")
})

test_that("mn_sources() filters and mn_citation() combines attributions", {
  expect_equal(mn_sources("khoroos")$id, "khoroos")
  expect_snapshot(mn_sources("nope"), error = TRUE)
  expect_match(mn_citation(c("admin", "khoroos")), "COD-AB.*khoroo-map")
})

test_that("no exported function clashes with mongolstats", {
  skip_if_not_installed("mongolstats")
  clash <- intersect(getNamespaceExports("mongolmaps"), getNamespaceExports("mongolstats"))
  expect_equal(clash, character())
})

test_that("the example data are ASCII and well formed", {
  expect_named(mn_example_population, c("Region", "Region_en", "Year", "value"))
  expect_true(all(stringi::stri_enc_isascii(mn_example_population$Region_en)))
  expect_equal(nrow(mn_aimag_grid), 22)
  expect_setequal(mn_aimag_grid$code, mn_codes("aimag")$pcode)
})

test_that("layers that may not be redistributed are never bundled or mirrored", {
  s <- mn_sources()
  expect_equal(s$delivery[s$id == "wdpa"], "upstream")
  expect_true(all(s$delivery[grepl("no redistribution", s$license)] == "upstream"))
})
