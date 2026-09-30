# Transliteration tables. Mongolian Cyrillic letters in alphabetical order:
# a b v g d e yo j z i i k l m n o oe p r s t u ue f kh ts ch sh shch
# hard-sign y soft-sign e yu ya
.mm_cyr_lower <- c(
  "\u0430", "\u0431", "\u0432", "\u0433", "\u0434", "\u0435", "\u0451", "\u0436",
  "\u0437", "\u0438", "\u0439", "\u043a", "\u043b", "\u043c", "\u043d", "\u043e",
  "\u04e9", "\u043f", "\u0440", "\u0441", "\u0442", "\u0443", "\u04af", "\u0444",
  "\u0445", "\u0446", "\u0447", "\u0448", "\u0449", "\u044a", "\u044b", "\u044c",
  "\u044d", "\u044e", "\u044f"
)

.mm_cyr_upper <- c(
  "\u0410", "\u0411", "\u0412", "\u0413", "\u0414", "\u0415", "\u0401", "\u0416",
  "\u0417", "\u0418", "\u0419", "\u041a", "\u041b", "\u041c", "\u041d", "\u041e",
  "\u04e8", "\u041f", "\u0420", "\u0421", "\u0422", "\u0423", "\u04ae", "\u0424",
  "\u0425", "\u0426", "\u0427", "\u0428", "\u0429", "\u042a", "\u042b", "\u042c",
  "\u042d", "\u042e", "\u042f"
)

# NSO-style romanisation, as used in NSO English tables ("Khuvsgul").
.mm_lat_nso <- c(
  "a", "b", "v", "g", "d", "e", "yo", "j",
  "z", "i", "i", "k", "l", "m", "n", "o",
  "u", "p", "r", "s", "t", "u", "u", "f",
  "kh", "ts", "ch", "sh", "sh", "i", "y", "i",
  "e", "yu", "ya"
)

# MNS 5217:2012 keeps the front vowels as o-umlaut and u-umlaut ("Khovsgol").
.mm_lat_mns <- replace(.mm_lat_nso, c(17L, 23L), c("\u00f6", "\u00fc"))

.mm_cyr_e <- 6L
.mm_cyr_vowels <- c(1L, 6L, 7L, 10L, 16L, 17L, 22L, 23L, 31L, 33L, 34L, 35L)

#' Transliterate Mongolian Cyrillic to Latin script
#'
#' Converts Mongolian Cyrillic text to Latin script with a fixed,
#' package-owned table, so results never change between systems. Latin
#' characters, digits and punctuation pass through unchanged.
#'
#' @param x A character vector (factors are converted to character).
#' @param to The romanisation scheme:
#'   * `"mns"` (default): the Mongolian national standard MNS 5217:2012,
#'     which writes the front vowels as o-umlaut and u-umlaut, for example
#'     "Khovsgol" with umlauts.
#'   * `"nso"`: the plain-ASCII spelling used in English tables of the
#'     National Statistics Office, for example "Khuvsgul".
#'
#' @return A character vector the same length as `x`.
#' @family names and codes
#' @export
#' @examples
#' mn_translit("\\u0425\\u04e9\\u0432\\u0441\\u0433\\u04e9\\u043b")
#' mn_translit("\\u0425\\u04e9\\u0432\\u0441\\u0433\\u04e9\\u043b", to = "nso")
#' mn_translit("\\u0423\\u043b\\u0430\\u0430\\u043d\\u0431\\u0430\\u0430\\u0442\\u0430\\u0440")
mn_translit <- function(x, to = c("mns", "nso")) {
  to <- rlang::arg_match(to)
  x <- enc2utf8(as.character(x))
  lat <- if (to == "mns") .mm_lat_mns else .mm_lat_nso
  out <- x
  todo <- .mm_has_cyrillic(x)
  out[todo] <- purrr::map_chr(x[todo], .mm_translit_one, lat = lat)
  out
}

.mm_has_cyrillic <- function(x) {
  !is.na(x) & stringi::stri_detect_regex(x, "\\p{Script=Cyrillic}")
}

.mm_translit_one <- function(s, lat) {
  ch <- strsplit(s, "", fixed = TRUE)[[1]]
  n <- length(ch)
  lo <- match(ch, .mm_cyr_lower)
  up <- match(ch, .mm_cyr_upper)
  is_up <- !is.na(up)
  is_letter <- stringi::stri_detect_regex(ch, "\\p{L}")
  word_start <- !c(FALSE, is_letter[-n])

  out <- ch
  idx <- ifelse(is.na(lo), up, lo)
  hit <- !is.na(idx)
  out[hit] <- lat[idx[hit]]
  prev_vowel <- c(FALSE, (idx %in% .mm_cyr_vowels)[-n])
  ye <- hit & idx == .mm_cyr_e & (word_start | prev_vowel)
  out[ye] <- "ye"

  next_up <- c(is_up[-1], FALSE)
  prev_up <- c(FALSE, is_up[-n])
  next_lower_letter <- c(is_letter[-1] & !is_up[-1], FALSE)
  all_caps <- is_up & (next_up | (prev_up & !next_lower_letter))
  out[is_up & all_caps] <- toupper(out[is_up & all_caps])
  title <- is_up & !all_caps
  out[title] <- paste0(toupper(substr(out[title], 1, 1)), substring(out[title], 2))
  paste(out, collapse = "")
}

# Words that describe the kind of unit rather than naming it.
.mm_generic_words <- c(
  "aimag", "aimak", "aymag", "ajmag", "province", "prov", "soum", "sum", "sumu",
  "somon", "district", "duureg", "dvvreg", "khot", "hot", "city", "capital",
  "municipality", "khoroo", "horoo", "subdistrict", "bag", "bagh", "region", "bus"
)

# A matching key: the same for every common spelling of a place name.
.mm_key <- function(x) {
  x <- as.character(x)
  out <- rep(NA_character_, length(x))
  ok <- !is.na(x)
  if (!any(ok)) {
    return(out)
  }
  k <- stringi::stri_trans_nfc(x[ok])
  k <- mn_translit(k, to = "nso")
  k <- stringi::stri_trans_tolower(k)
  k <- stringi::stri_trans_general(k, "Latin-ASCII")
  k <- gsub("([uo])'", "\\1", k)
  k <- gsub("x", "kh", k, fixed = TRUE)
  k <- gsub("(\\d+)\\s*-?\\s*(r|th|st|nd|rd)\\b", "\\1", k)
  k <- gsub("[^a-z0-9]+", " ", k)
  generic <- paste0("\\b(", paste(.mm_generic_words, collapse = "|"), ")\\b")
  k <- gsub(generic, " ", k)
  folds <- c(zh = "j", dz = "z", ts = "c", kh = "h", y = "i", w = "b", v = "b", o = "u")
  for (from in names(folds)) {
    k <- gsub(from, folds[[from]], k, fixed = TRUE)
  }
  # Long vowels are often written short ("Ulan Bator"); double consonants are
  # kept because they separate real names (Tsagaannuur vs Tsagaan-Uur).
  k <- gsub("([aeiu])\\1+", "\\1", k)
  out[ok] <- gsub(" ", "", k, fixed = TRUE)
  out
}
