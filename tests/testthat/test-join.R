pop <- mn_example_population[mn_example_population$Year == 2025, ]

test_that("mn_join() joins NSO codes at the aimag level and drops other levels", {
  expect_snapshot(out <- mn_join(pop, by = "Region", level = "aimag"))
  expect_s3_class(out, "sf")
  expect_equal(nrow(out), 22)
  expect_false(anyNA(out$value))
  expect_equal(out$value[out$pcode == "MN11"], pop$value[pop$Region == "511"])
})

test_that("mn_join() detects the level and joins khoroos", {
  expect_snapshot(out <- mn_join(pop, Region, within = "Ulaanbaatar"))
  expect_equal(unique(out$level), "bag")
  expect_equal(nrow(out), 204)
  expect_false(anyNA(out$value))
})

test_that("mn_join() keeps every unit and repeats units for several rows", {
  df <- data.frame(aimag = c("Khovsgol", "Hovd", "\u0423\u0432\u0441", "Hovd"), year = c(1, 1, 1, 2), value = 1:4)
  out <- mn_join(df, aimag)
  expect_equal(nrow(out), 22 + 1)
  expect_equal(sum(is.na(out$value)), 19)
  expect_equal(sort(out$value[out$pcode == "MN84"]), c(2L, 4L))
})

test_that("mn_join() reports unmatched rows and places without boundaries", {
  df <- data.frame(place = c("Khovd", "Narnia"), value = 1:2)
  expect_snapshot(out <- mn_join(df, "place", level = "aimag"))
  expect_equal(sum(!is.na(out$value)), 1)
  villages <- data.frame(code = c("26770", "18401"), value = 1:2)
  expect_snapshot(out <- mn_join(villages, "code", level = "soum"))
  expect_equal(sum(!is.na(out$value)), 1)
})

test_that("mn_join() uses `by_parent` for repeated soum names", {
  df <- data.frame(aimag = c("Dornod", "Govi-Altai"), soum = c("Bayan-Uul", "Bayan-Uul"), value = 1:2)
  out <- mn_join(df, "soum", level = "soum", by_parent = "aimag")
  expect_equal(out$value[out$pcode %in% c("MN2110", "MN8207")], 1:2)
})

test_that("mn_join() renames clashing columns and drops input geometry", {
  df <- data.frame(name = "x", pcode = "MN84", level = "high", value = 3)
  out <- mn_join(df, "pcode")
  expect_true(all(c("name.data", "level.data", "value") %in% names(out)))
  expect_equal(out$name.data[out$pcode == "MN84"], "x")
  sf_in <- mn_aimags()[1:2, c("pcode", "area_km2")]
  expect_s3_class(mn_join(sf_in, "pcode"), "sf")
})

test_that("mn_join() validates its inputs", {
  expect_snapshot(mn_join(list(a = 1), "a"), error = TRUE)
  expect_snapshot(mn_join(pop, "Province"), error = TRUE)
  expect_snapshot(mn_join(pop, "Region", by_parent = "Aimag"), error = TRUE)
})

test_that(".mm_detect_level() picks the most common level", {
  expect_equal(.mm_detect_level(c("0", "183", "184", "511")), "aimag")
  expect_equal(.mm_detect_level(c("Khovd", "18401", "18404")), "soum")
  expect_equal(.mm_detect_level(c("no", "match")), "aimag")
})

test_that("mn_join() checks `by_parent` is a single string", {
  expect_snapshot(mn_join(pop, "Region", by_parent = 1), error = TRUE)
})
