skip_if_not_installed("ggplot2")

test_that("mn_map() draws the aimags by default in Albers", {
  p <- mn_map()
  expect_s3_class(p, "ggplot")
  expect_equal(p$coordinates$crs, mn_crs("albers"))
  expect_match(p$labels$caption, "COD-AB")
})

test_that("mn_map() picks UTM for Ulaanbaatar", {
  p <- mn_map(mn_khoroos(district = "Bayangol"))
  expect_equal(p$coordinates$crs, sf::st_crs(32648))
  expect_match(p$labels$caption, "khoroo-map")
})

test_that("mn_map() maps numbers and categories to fill scales", {
  p <- mn_map(mn_aimags(), fill = area_km2)
  expect_s3_class(p$scales$get_scales("fill"), "ScaleContinuous")
  p <- mn_map(mn_aimags(), fill = region_pcode)
  expect_s3_class(p$scales$get_scales("fill"), "ScaleDiscrete")
  p <- mn_map(mn_aimags(), fill = "steelblue")
  expect_null(p$scales$get_scales("fill"))
})

test_that("mn_map() adds labels and context layers", {
  p <- mn_map(mn_aimags(), label = TRUE, context = TRUE, caption = "Custom")
  geoms <- purrr::map_chr(p$layers, \(l) class(l$geom)[1])
  expect_equal(sum(geoms %in% c("GeomLabel", "GeomLabelRepel")), 1)
  expect_gte(length(p$layers), 5)
  expect_equal(p$labels$caption, "Custom")
  kh <- mn_map(mn_khoroos(district = "Baganuur"), label = TRUE)
  labels <- ggplot2::layer_data(kh, 2)$label
  expect_setequal(labels, as.character(1:5))
  custom <- mn_map(mn_aimags(), label = pcode, caption = FALSE)
  expect_true("MN84" %in% ggplot2::layer_data(custom, 2)$label)
  expect_null(custom$labels$caption)
})

test_that("mn_map() validates `x`", {
  expect_snapshot(mn_map(data.frame(a = 1)), error = TRUE)
})

test_that("mn_label_points() uses precomputed points and falls back", {
  pts <- mn_label_points(mn_aimags())
  expect_true(all(sf::st_geometry_type(pts) == "POINT"))
  expect_equal(nrow(pts), 22)
  plain <- sf::st_sf(id = 1, geometry = sf::st_geometry(mn_country()))
  expect_equal(nrow(mn_label_points(plain)), 1)
  expect_snapshot(mn_label_points(1), error = TRUE)
})

test_that("theme_mn() is a ggplot2 theme", {
  expect_s3_class(theme_mn(), "theme")
})

test_that("mn_map() snapshots look right", {
  skip_on_cran()
  skip_if_not_installed("vdiffr")
  vdiffr::expect_doppelganger("aimags labelled", mn_map(mn_aimags(), label = TRUE, caption = FALSE))
  vdiffr::expect_doppelganger("khoroos of bayangol", mn_map(mn_khoroos(district = "Bayangol"), fill = area_km2, caption = FALSE))
  vdiffr::expect_doppelganger("regions with context", mn_map(mn_regions(), fill = name, context = TRUE, caption = FALSE))
})

test_that("mn_map() credits Natural Earth when context is drawn", {
  expect_match(mn_map(mn_aimags(), context = TRUE)$labels$caption, "Natural Earth")
})

test_that("number labels work without the scales package", {
  local_mocked_bindings(is_installed = function(...) FALSE, .package = "rlang")
  expect_equal(.mm_number_labels(1234567), "1,234,567")
})

test_that("labels fall back to geom_sf_label() without ggrepel", {
  local_mocked_bindings(is_installed = function(pkg, ...) pkg != "ggrepel", .package = "rlang")
  p <- mn_map(mn_aimags(), label = TRUE)
  expect_s3_class(p$layers[[2]]$geom, "GeomLabel")
  expect_equal(nrow(ggplot2::layer_data(p, 2)), 22)
})
