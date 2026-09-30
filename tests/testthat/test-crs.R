test_that("mn_crs() returns Mongolia projections", {
  expect_match(mn_crs("albers")$proj4string, "+proj=aea", fixed = TRUE)
  expect_match(mn_crs("lcc")$proj4string, "+proj=lcc", fixed = TRUE)
  expect_equal(mn_crs("utm"), sf::st_crs(32648))
  expect_equal(mn_crs("wgs84"), sf::st_crs(4326))
  expect_snapshot(mn_crs("mercator"), error = TRUE)
})

test_that(".mm_resolve_crs() handles NULL, keywords and bad input", {
  expect_null(.mm_resolve_crs(NULL))
  expect_equal(.mm_resolve_crs("utm"), sf::st_crs(32648))
  expect_equal(.mm_resolve_crs(3857), sf::st_crs(3857))
  expect_snapshot(.mm_resolve_crs(NA), error = TRUE)
})

test_that(".mm_auto_crs() chooses UTM for small central areas", {
  expect_equal(.mm_auto_crs(mn_ub()), sf::st_crs(32648))
  expect_equal(.mm_auto_crs(mn_aimags()), mn_crs("albers"))
  expect_equal(.mm_auto_crs(mn_soums(aimag = "Bayan-Ulgii")), mn_crs("albers"))
})
