test_that("bundled boundaries are valid under GEOS and S2", {
  for (layer in names(mongolmaps:::.mm_low)) {
    x <- mongolmaps:::.mm_low[[layer]]
    expect_true(all(sf::st_is_valid(x)), label = paste(layer, "GEOS validity"))
    expect_true(all(s2::s2_is_valid(x)), label = paste(layer, "S2 validity"))
  }
})

test_that("soum label points fall inside their aimag", {
  suppressMessages(sf::sf_use_s2(FALSE))
  withr::defer(suppressMessages(sf::sf_use_s2(TRUE)))
  soums <- mn_label_points(mn_soums())
  aimags <- mn_aimags()
  hit <- sf::st_intersects(soums, aimags)
  inside <- purrr::map2_lgl(hit, soums$aimag_pcode, \(i, a) a %in% aimags$pcode[i])
  expect_true(all(inside))
})

test_that("khoroos tile their districts and districts tile Ulaanbaatar", {
  suppressMessages(sf::sf_use_s2(FALSE))
  withr::defer(suppressMessages(sf::sf_use_s2(TRUE)))
  utm <- \(x) sf::st_transform(x, 32648)
  km2 <- \(g) if (length(g) == 0) 0 else sum(as.numeric(sf::st_area(g))) / 1e6
  kh <- utm(mn_khoroos())
  ub <- utm(mn_ub())
  expect_lt(km2(sf::st_sym_difference(sf::st_union(kh), sf::st_geometry(ub))), 0.5)
  expect_lt(km2(sf::st_geometry(kh)) - km2(sf::st_union(kh)), 0.05)
})

test_that("national and Ulaanbaatar layers agree on the city outline", {
  a <- sf::st_transform(mn_aimags()[mn_aimags()$pcode == "MN11", ], 32648)
  b <- sf::st_transform(mn_ub(), 32648)
  expect_lt(as.numeric(sf::st_distance(sf::st_boundary(a), sf::st_boundary(b), which = "Hausdorff")), 300)
})

test_that("areas are close to the published COD areas", {
  a <- mn_aimags()
  expect_true(all(a$area_km2 > 0))
  expect_equal(sum(a$area_km2), mn_country()$area_km2, tolerance = 0.001)
  expect_equal(mn_country()$area_km2, 1564877, tolerance = 0.005)
})

test_that("the bundled data stays small", {
  path <- system.file("R", "sysdata.rdb", package = "mongolmaps")
  skip_if(path == "", "installed package layout not available")
  expect_lt(file.size(path) / 1024^2, 5)
})
