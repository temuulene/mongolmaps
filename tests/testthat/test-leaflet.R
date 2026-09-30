skip_if_not_installed("leaflet")

test_that("mn_leaflet() returns a leaflet widget", {
  m <- mn_leaflet()
  expect_s3_class(m, "leaflet")
  expect_s3_class(m, "htmlwidget")
})

test_that("mn_leaflet() colours by a column and adds a legend", {
  m <- mn_leaflet(mn_khoroos(district = "Bayangol"), fill = area_km2)
  methods <- purrr::map_chr(m$x$calls, "method")
  expect_true("addLegend" %in% methods)
  m <- mn_leaflet(mn_aimags(), fill = region_pcode, popup = name_mn, lang = "mn")
  expect_true("addLegend" %in% purrr::map_chr(m$x$calls, "method"))
  m <- mn_leaflet(mn_aimags(), fill = "tomato")
  expect_false("addLegend" %in% purrr::map_chr(m$x$calls, "method"))
})

test_that("mn_leaflet() escapes HTML in pop-ups", {
  expect_equal(.mm_html_escape("<b>&"), "&lt;b&gt;&amp;")
  pop <- .mm_default_popup(data.frame(name_en = "<x>", name_mn = "y", pcode = "MN1"), 5, "v")
  expect_match(pop, "&lt;x&gt;", fixed = TRUE)
})

test_that("mn_leaflet() validates `x`", {
  expect_snapshot(mn_leaflet("aimags"), error = TRUE)
})
