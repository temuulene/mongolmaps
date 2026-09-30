test_that("the unit table has every level with the expected counts", {
  counts <- table(mn_codes()$level)
  expect_equal(counts[["country"]], 1)
  expect_equal(counts[["region"]], 5)
  expect_equal(counts[["aimag"]], 22)
  expect_equal(counts[["soum"]], 343)
  expect_equal(sum(mn_codes("soum")$type == "district"), 9)
  expect_equal(sum(mn_codes("soum")$type == "village"), 4)
  expect_equal(sum(mn_codes("bag")$type == "khoroo"), 204)
  expect_gt(sum(mn_codes("bag")$type == "bag"), 1600)
})

test_that("codes are unique and consistent", {
  u <- mn_codes()
  expect_false(anyDuplicated(u$pcode) > 0)
  expect_false(anyDuplicated(u$nso_code) > 0)
  aimags <- u[u$level == "aimag", ]
  expect_match(aimags$iso_code, "^MN-[0-9]{1,3}$")
  expect_equal(aimags$pcode, paste0("MN", substring(aimags$nso_code, 2)))
  lower <- u[u$level %in% c("soum", "bag"), ]
  expect_equal(lower$pcode, paste0("MN", substring(lower$nso_code, 2)))
  expect_true(all(lower$parent_pcode %in% u$pcode))
})

test_that("English names are ASCII and every unit has a Cyrillic name", {
  u <- mn_codes()
  expect_true(all(stringi::stri_enc_isascii(u$name_en)))
  expect_false(anyNA(u$name_mn))
})

test_that("only villages and rural bags lack geometry", {
  u <- mn_codes()
  no_geom <- u[!u$has_geometry, ]
  expect_setequal(unique(no_geom$type), c("village", "bag"))
})

test_that("alias keys never collide within a parent", {
  a <- mongolmaps:::.mm_aliases
  a$parent <- mongolmaps:::.mm_units$parent_pcode[match(a$pcode, mongolmaps:::.mm_units$pcode)]
  n <- tapply(a$pcode, paste(a$level, a$parent, a$key), \(p) length(unique(p)))
  expect_equal(max(n), 1)
})

test_that("mn_codes() filters by level and parent and switches name language", {
  khovd <- mn_codes("soum", within = "Khovd")
  expect_equal(nrow(khovd), 17)
  expect_true(all(khovd$aimag_pcode == "MN84"))
  expect_equal(mn_codes("aimag", lang = "mn")$name, mn_codes("aimag")$name_mn)
})

test_that("mn_codes(aliases = TRUE) lists spellings", {
  a <- mn_codes("aimag", aliases = TRUE)
  expect_named(a, c("pcode", "level", "name_en", "alias", "source"))
  expect_true("Hovsgel" %in% a$alias[a$pcode == "MN67"])
})
