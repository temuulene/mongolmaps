test_that("every admin getter returns the shared schema", {
  expect_mn_schema(mn_country(), "country")
  expect_mn_schema(mn_regions(), "region")
  expect_mn_schema(mn_aimags(), "aimag")
  expect_mn_schema(mn_soums(), "soum")
  expect_mn_schema(mn_ub(), "aimag")
  expect_mn_schema(mn_ub_districts(), "soum")
  expect_mn_schema(mn_khoroos(), "bag")
})

test_that("getters return the expected number of units", {
  expect_equal(nrow(mn_country()), 1)
  expect_equal(nrow(mn_regions()), 5)
  expect_equal(nrow(mn_aimags()), 22)
  expect_equal(nrow(mn_soums()), 339)
  expect_equal(nrow(mn_ub_districts()), 9)
  expect_equal(nrow(mn_khoroos()), 204)
})

test_that("filters accept names, codes and regions", {
  expect_equal(unique(mn_soums(aimag = "Khovd")$aimag_pcode), "MN84")
  expect_equal(nrow(mn_soums(aimag = c("Uvs", "MN84"))), nrow(mn_soums(aimag = "Uvs")) + 17)
  expect_setequal(mn_aimags(region = "Western")$pcode, c("MN81", "MN82", "MN83", "MN84", "MN85"))
  expect_equal(mn_aimags(region = c("Khovd", "Uvs"))$pcode, c("MN84", "MN85"))
  expect_equal(nrow(mn_khoroos(district = "Bayangol")), 34)
  expect_equal(nrow(mn_khoroos(district = c("BND", "MN1104"))), 7)
  expect_equal(nrow(mn_soums(aimag = "Ulaanbaatar")), 9)
})

test_that("mn_admin() is the engine behind the getters", {
  expect_equal(mn_admin("province"), mn_aimags())
  expect_equal(mn_admin("district", within = "Khovd"), mn_soums(aimag = "Khovd"))
  expect_equal(mn_admin("khoroo", within = "Bayangol duureg")$pcode, mn_khoroos(district = "Bayangol")$pcode)
  expect_equal(mn_admin("aimag", within = "Western region")$pcode, mn_aimags(region = "Western")$pcode)
})

test_that("mn_admin('bag') explains that only khoroos have boundaries", {
  rlang::reset_message_verbosity("mongolmaps_no_bags")
  expect_snapshot(x <- mn_admin("bag"))
  expect_equal(nrow(x), 204)
  expect_no_message(mn_admin("bag", within = "Ulaanbaatar"))
})

test_that("`lang` switches the name column", {
  expect_equal(mn_aimags(lang = "mn")$name, mn_aimags()$name_mn)
  expect_equal(mn_aimags(lang = "mns")$name, mn_aimags()$name_mns)
  withr::local_options(mongolmaps.lang = "mn")
  expect_equal(mn_aimags()$name, mn_aimags()$name_mn)
})

test_that("`crs` accepts keywords, EPSG codes and crs objects", {
  expect_equal(sf::st_crs(mn_aimags()), sf::st_crs(4326))
  expect_equal(sf::st_crs(mn_aimags(crs = "albers")), mn_crs("albers"))
  expect_equal(sf::st_crs(mn_khoroos(crs = "utm")), sf::st_crs(32648))
  expect_equal(sf::st_crs(mn_aimags(crs = 3857)), sf::st_crs(3857))
  expect_equal(sf::st_crs(mn_aimags(crs = sf::st_crs(32647))), sf::st_crs(32647))
})

test_that("bad arguments give clear errors", {
  expect_snapshot(mn_aimags(crs = "mercator-ish"), error = TRUE)
  expect_snapshot(mn_aimags(lang = "fr"), error = TRUE)
  expect_snapshot(mn_aimags(resolution = "medium"), error = TRUE)
  expect_snapshot(mn_soums(aimag = "Atlantis"), error = TRUE)
  expect_snapshot(mn_admin(c("aimag", "soum")), error = TRUE)
})

test_that("resolution = 'high' reads the downloaded release asset", {
  gpkg <- local_admin_high_fixture()
  local_mocked_bindings(.mm_asset = function(id, ...) gpkg)
  rm(list = ls(mongolmaps:::.mm_env), envir = mongolmaps:::.mm_env)
  withr::defer(rm(list = ls(mongolmaps:::.mm_env), envir = mongolmaps:::.mm_env))
  hi <- mn_soums(aimag = "Khovd", resolution = "high")
  expect_mn_schema(hi, "soum")
  expect_equal(hi$pcode, mn_soums(aimag = "Khovd")$pcode)
  expect_equal(nrow(mn_khoroos(resolution = "high")), 204)
})
