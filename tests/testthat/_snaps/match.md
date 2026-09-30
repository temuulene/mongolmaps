# mn_match() matches small typos and reports them

    Code
      out <- mn_match(c("Ulanbaatr", "Dornogobii"))
    Message
      i Matched 1 value approximately; please check:
      * Ulanbaatr > Ulaanbaatar (MN11)

# mn_match() does not fuzzy-match when fuzzy = FALSE

    Code
      out <- mn_match("Ulanbaatr", fuzzy = FALSE)
    Condition
      Warning:
      1 value could not be matched and became "NA":
      * Ulanbaatr

# mn_match() warns about ambiguous names and suggests `within`

    Code
      out <- mn_match("Bayan-Uul", level = "soum")
    Condition
      Warning:
      1 value matches more than one unit and became "NA":
      * Bayan-Uul: Bayan-Uul (MN2110, Dornod); Bayan-Uul (MN8207, Govi-Altai)
      i Use `within` (for example the aimag) to choose one.

# mn_match() warns about unmatched values

    Code
      out <- mn_match(c("Paris", "Khovd", "Uvss aimag"))
    Message
      i Matched 1 value approximately; please check:
      * Uvss aimag > Uvs (MN85)
    Condition
      Warning:
      1 value could not be matched and became "NA":
      * Paris (did you mean Dariv (MN8216, Govi-Altai)?)

# mn_match() respects `level` for codes

    Code
      out <- mn_match("511", level = "soum")
    Condition
      Warning:
      1 value could not be matched and became "NA":
      * 511

# mn_match() validates its arguments

    Code
      mn_match("x", level = "planet")
    Condition
      Error in `mn_match()`:
      ! `level` has an unknown level: "planet".
      i Use one of "country", "region", "aimag", "soum", or "bag".

---

    Code
      mn_match("x", to = "code")
    Condition
      Error in `mn_match()`:
      ! `to` must be one of "pcode", "name_en", "name_mn", "name_mns", "iso_code", "nso_code", "level", or "type", not "code".
      i Did you mean "pcode"?

---

    Code
      mn_match(c("a", "b", "c"), within = c("Khovd", "Uvs"))
    Condition
      Error in `mn_match()`:
      ! `within` must have length 1 or the same length as `x`.

---

    Code
      mn_match("Jargalant", within = "Atlantis")
    Condition
      Error in `mn_match()`:
      ! Can't resolve `within`.
      x Atlantis matches nothing
      i Use a code from `mn_codes()`, such as "MN84" for Khovd.

# mn_match() handles names that are only generic words

    Code
      out <- mn_match(c("aimag", "soum"))
    Condition
      Warning:
      2 values could not be matched and became "NA":
      * aimag
      * soum

# mn_match() finds nothing inside units without children

    Code
      out <- mn_match("1", level = "bag", within = "MN6770")
    Condition
      Warning:
      1 value could not be matched and became "NA":
      * 1

# fuzzy ties are not guessed

    Code
      out <- mn_match("Bayan-Uulx", level = "soum")
    Condition
      Warning:
      1 value could not be matched and became "NA":
      * Bayan-Uulx (did you mean Bayan-Uul (MN2110, Dornod); Bayan-Uul (MN8207, Govi-Altai)?)

