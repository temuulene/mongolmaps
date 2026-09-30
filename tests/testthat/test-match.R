test_that("mn_match() resolves every spelling of every aimag", {
  aimags <- mn_codes("aimag")
  expect_equal(mn_match(aimags$name_en), aimags$pcode)
  expect_equal(mn_match(aimags$name_mn), aimags$pcode)
  expect_equal(mn_match(aimags$name_mns), aimags$pcode)
  expect_equal(mn_match(aimags$iso_code), aimags$pcode)
  expect_equal(mn_match(aimags$nso_code), aimags$pcode)
  expect_equal(mn_match(tolower(aimags$pcode)), aimags$pcode)
})

test_that("mn_match() resolves every soum and UB district within its aimag", {
  soums <- mn_codes("soum")
  expect_equal(mn_match(soums$name_en, level = "soum", within = soums$aimag_pcode), soums$pcode)
  expect_equal(mn_match(soums$name_mn, level = "soum", within = soums$aimag_pcode), soums$pcode)
  expect_equal(mn_match(soums$nso_code), soums$pcode)
})

test_that("mn_match() understands COD, geoBoundaries and common variants", {
  expect_equal(
    mn_match(c("Xan-Uul", "Bayanzu'rx", "Su'xbaatar"), level = "soum", within = "Ulaanbaatar"),
    c("MN1122", "MN1110", "MN1119")
  )
  expect_equal(mn_match(c("Hovsgel", "Hovsgol", "KHOVSGOL AIMAG", "Khovsgol Province")), rep("MN67", 4))
  expect_equal(mn_match(c("Ulan Bator", "UB", "Ulaanbaatar city", "South Gobi")), c("MN11", "MN11", "MN11", "MN46"))
  expect_equal(mn_match(c("BZD", "\u0421\u0425\u0414"), level = "soum"), c("MN1110", "MN1116"))
})

test_that("mn_match() uses words such as district or soum as hints", {
  expect_equal(mn_match(c("Sukhbaatar", "Sukhbaatar district")), c("MN22", "MN1119"))
  expect_equal(mn_match(c("Bayankhongor", "Bayankhongor soum")), c("MN64", "MN6401"))
})

test_that("mn_match() matches khoroos by number within a district", {
  expect_equal(mn_match("15-r khoroo", level = "bag", within = "Bayangol"), "MN110779")
  expect_equal(mn_match(c("1", "34"), level = "bag", within = "MN1107"), c("MN110751", "MN110768"))
  expect_equal(mn_match("Bayangol 15"), "MN110779")
  expect_equal(mn_match("5110779"), "MN110779")
})

test_that("mn_match() returns other columns with `to`", {
  expect_equal(mn_match("Khovd", to = "name_mn"), "\u0425\u043e\u0432\u0434")
  expect_equal(mn_match("Khovd", to = "iso_code"), "MN-043")
  expect_equal(mn_match("Khovd", to = "nso_code"), "184")
  expect_equal(mn_match(c("MN84", "MN8401"), to = "level"), c("aimag", "soum"))
})

test_that("mn_match() matches small typos and reports them", {
  expect_snapshot(out <- mn_match(c("Ulanbaatr", "Dornogobii")))
  expect_equal(out, c("MN11", "MN44"))
  expect_no_message(mn_match("Ulanbaatr", quiet = TRUE))
})

test_that("mn_match() does not fuzzy-match when fuzzy = FALSE", {
  expect_snapshot(out <- mn_match("Ulanbaatr", fuzzy = FALSE))
  expect_equal(out, NA_character_)
})

test_that("mn_match() warns about ambiguous names and suggests `within`", {
  expect_snapshot(out <- mn_match("Bayan-Uul", level = "soum"))
  expect_equal(out, NA_character_)
  expect_equal(mn_match("Bayan-Uul", level = "soum", within = "Dornod"), "MN2110")
})

test_that("mn_match() warns about unmatched values", {
  expect_snapshot(out <- mn_match(c("Paris", "Khovd", "Uvss aimag")))
  expect_equal(out, c(NA, "MN84", "MN85"))
})

test_that("mn_match() keeps NA, empty strings and input length", {
  expect_equal(mn_match(c(NA, "", "Uvs", "Uvs")), c(NA, NA, "MN85", "MN85"))
  expect_identical(mn_match(character()), character())
  expect_equal(mn_match(factor("Uvs")), "MN85")
  expect_equal(mn_match(183), "MN83")
})

test_that("mn_match() respects `level` for codes", {
  expect_snapshot(out <- mn_match("511", level = "soum"))
  expect_equal(out, NA_character_)
})

test_that("mn_match() accepts one `within` per value", {
  expect_equal(
    mn_match(c("Bayan-Uul", "Bayan-Uul"), level = "soum", within = c("Dornod", "Govi-Altai")),
    c("MN2110", "MN8207")
  )
})

test_that("mn_match() validates its arguments", {
  expect_snapshot(mn_match("x", level = "planet"), error = TRUE)
  expect_snapshot(mn_match("x", to = "code"), error = TRUE)
  expect_snapshot(mn_match(c("a", "b", "c"), within = c("Khovd", "Uvs")), error = TRUE)
  expect_snapshot(mn_match("Jargalant", within = "Atlantis"), error = TRUE)
})

test_that(".mm_type_hint() recognises unit words", {
  expect_equal(
    .mm_type_hint(c("Sukhbaatar district", "1-r khoroo", "Bayankhongor soum", "Khovd aimag", "Western region", "Khovd")),
    list("district", "khoroo", c("soum", "village"), c("aimag", "capital"), "region", NULL)
  )
})

test_that(".mm_fuzzy_threshold() grows with name length", {
  expect_equal(.mm_fuzzy_threshold(c("ub", "khovd", "zavkhanaa", "songinokhairkhan")), c(0L, 1L, 2L, 3L))
})

test_that("mn_match() treats missing `within` values as no restriction", {
  expect_equal(mn_match("Khovd", within = NA), "MN84")
  expect_equal(mn_match(c("Khovd", "Bayan-Uul"), level = c("aimag", "soum"), within = c(NA, "Dornod")), c("MN84", "MN2110"))
})

test_that("mn_match() handles names that are only generic words", {
  expect_snapshot(out <- mn_match(c("aimag", "soum")))
  expect_equal(out, c(NA_character_, NA_character_))
})

test_that("mn_match() finds nothing inside units without children", {
  expect_snapshot(out <- mn_match("1", level = "bag", within = "MN6770"))
  expect_equal(out, NA_character_)
})

test_that("fuzzy ties are not guessed", {
  expect_snapshot(out <- mn_match("Bayan-Uulx", level = "soum"))
  expect_equal(out, NA_character_)
})

test_that("the quiet option silences fuzzy-match messages", {
  withr::local_options(mongolmaps.quiet = TRUE)
  expect_no_message(mn_match("Ulanbaatr"))
})
