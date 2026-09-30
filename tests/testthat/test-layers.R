test_that("mn_settlements() returns the capital and centres", {
  s <- mn_settlements()
  expect_s3_class(s, "sf")
  expect_equal(sum(s$type == "capital"), 1)
  expect_equal(sum(s$type == "aimag_centre"), 21)
  expect_gt(sum(s$type == "soum_centre"), 300)
  expect_true(all(sf::st_geometry_type(s) == "POINT"))
})

test_that("mn_settlements() filters by type and place and switches language", {
  khovd <- mn_settlements(within = "Khovd")
  expect_true(all(khovd$aimag_pcode == "MN84"))
  expect_equal(nrow(mn_settlements(type = "capital")), 1)
  expect_equal(mn_settlements(type = "capital", lang = "mn")$name, "\u0423\u043b\u0430\u0430\u043d\u0431\u0430\u0430\u0442\u0430\u0440")
  expect_snapshot(mn_settlements(type = "village"), error = TRUE)
})

test_that("settlements lie inside their soum", {
  suppressMessages(sf::sf_use_s2(FALSE))
  withr::defer(suppressMessages(sf::sf_use_s2(TRUE)))
  s <- mn_settlements(type = "soum_centre")
  soums <- mn_soums()
  hit <- sf::st_intersects(s, soums)
  inside <- purrr::map2_lgl(hit, s$soum_pcode, \(i, p) p %in% soums$pcode[i])
  expect_gt(mean(inside), 0.97)
})

test_that("context layers are sf objects near Mongolia", {
  for (x in list(mn_neighbours(), mn_rivers(), mn_lakes())) {
    expect_s3_class(x, "sf")
    bb <- sf::st_bbox(x)
    expect_gt(bb[["xmin"]], 75)
    expect_lt(bb[["xmax"]], 130)
  }
  expect_setequal(mn_neighbours()$iso3, c("RUS", "CHN", "KAZ"))
  expect_equal(sf::st_crs(mn_rivers(crs = "albers")), mn_crs("albers"))
})
