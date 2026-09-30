test_that("mn_translit() follows MNS 5217 with diacritics by default", {
  expect_equal(mn_translit("\u0425\u04e9\u0432\u0441\u0433\u04e9\u043b"), "Kh\u00f6vsg\u00f6l")
  expect_equal(
    mn_translit("\u04e8\u0432\u04e9\u0440\u0445\u0430\u043d\u0433\u0430\u0439"),
    "\u00d6v\u00f6rkhangai"
  )
  expect_equal(mn_translit("\u0421\u04af\u0445\u0431\u0430\u0430\u0442\u0430\u0440"), "S\u00fckhbaatar")
})

test_that("mn_translit(to = 'nso') reproduces NSO English spellings", {
  cyr <- c(
    "\u0425\u04e9\u0432\u0441\u0433\u04e9\u043b",
    "\u04e8\u0432\u04e9\u0440\u0445\u0430\u043d\u0433\u0430\u0439",
    "\u0423\u043b\u0430\u0430\u043d\u0431\u0430\u0430\u0442\u0430\u0440",
    "\u0413\u043e\u0432\u044c-\u0410\u043b\u0442\u0430\u0439",
    "\u0425\u044d\u043d\u0442\u0438\u0439",
    "\u0427\u0438\u043d\u0433\u044d\u043b\u0442\u044d\u0439",
    "\u0411\u0430\u044f\u043d-\u04e8\u043b\u0433\u0438\u0439",
    "\u0425\u0430\u043d-\u0423\u0443\u043b"
  )
  expect_equal(
    mn_translit(cyr, to = "nso"),
    c("Khuvsgul", "Uvurkhangai", "Ulaanbaatar", "Govi-Altai", "Khentii", "Chingeltei", "Bayan-Ulgii", "Khan-Uul")
  )
})

test_that("mn_translit() writes ye at the start of a word and after vowels", {
  expect_equal(mn_translit("\u0415\u0440\u04e9\u04e9", to = "nso"), "Yeruu")
  expect_equal(mn_translit("\u04ae\u0435\u043d\u0447", to = "nso"), "Uyench")
  expect_equal(mn_translit("\u0431\u0435\u0440", to = "nso"), "ber")
})

test_that("mn_translit() keeps all-caps words in capitals", {
  expect_equal(mn_translit("\u0423\u0411"), "UB")
  expect_equal(mn_translit("\u0425\u041e\u0412\u0414"), "KHOVD")
})

test_that("mn_translit() passes through Latin, digits, NA and empty strings", {
  expect_equal(mn_translit(c("Khovd", NA, "", "1-\u0440 \u0445\u043e\u0440\u043e\u043e")), c("Khovd", NA, "", "1-r khoroo"))
  expect_equal(mn_translit(factor("\u0423\u0432\u0441")), "Uvs")
  expect_identical(mn_translit(character()), character())
})

test_that("mn_translit() validates `to`", {
  expect_snapshot(mn_translit("x", to = "iso"), error = TRUE)
})

test_that(".mm_key() folds spelling variants to one key", {
  khuvsgul <- c("Khuvsgul", "Kh\u00f6vsg\u00f6l", "\u0425\u04e9\u0432\u0441\u0433\u04e9\u043b", "Hovsgol", "KHOVSGOL aimag")
  expect_equal(unique(.mm_key(khuvsgul)), "hubsgul")
  expect_equal(.mm_key(c("Dzavhan", "Zavkhan")), c("zabhan", "zabhan"))
  expect_equal(.mm_key(c("Bayan-\u00d6lgii", "Bayan-Ulgii", "Bayan Olgiy")), rep("baianulgi", 3))
  expect_equal(.mm_key(c("Gobi-Altai", "Govi-Altay")), rep("gubialtai", 2))
})

test_that(".mm_key() understands COD 'x' spellings", {
  expect_equal(.mm_key("Bayanzu'rx"), .mm_key("Bayanzurkh"))
  expect_equal(.mm_key("Xan-Uul"), .mm_key("Khan-Uul"))
  expect_equal(.mm_key("Su'xbaatar"), .mm_key("Sukhbaatar"))
})

test_that(".mm_key() drops generic unit words and ordinal suffixes", {
  nalaikh_mn <- "\u041d\u0430\u043b\u0430\u0439\u0445 \u0434\u04af\u04af\u0440\u044d\u0433"
  expect_equal(.mm_key(c("Nalaikh duureg", "Nalaikh District", nalaikh_mn)), rep("nalaih", 3))
  expect_equal(.mm_key(c("Ulaanbaatar city", "Ulaanbaatar")), rep("ulanbatar", 2))
  expect_equal(.mm_key(c("1-r khoroo", "Khoroo 1", "1-\u0440 \u0445\u043e\u0440\u043e\u043e", "1st")), rep("1", 4))
  expect_equal(.mm_key("Khovd Province"), "hubd")
})

test_that(".mm_key() keeps double consonants that separate names", {
  expect_false(.mm_key("Tsagaannuur") == .mm_key("Tsagaan-Uur"))
  expect_equal(.mm_key("Tsagaan-Uur"), .mm_key("Tsagan Ur"))
})

test_that(".mm_key() handles missing and empty input", {
  expect_equal(.mm_key(c(NA, "", "  ")), c(NA, "", ""))
  expect_identical(.mm_key(character()), character())
})

test_that(".mm_has_cyrillic() detects Cyrillic script", {
  expect_equal(.mm_has_cyrillic(c("\u0423\u0432\u0441", "Uvs", NA)), c(TRUE, FALSE, FALSE))
})
