# Match place names and codes to Mongolian administrative units

Converts any common way of writing a Mongolian place into its code:
English spellings ("Khuvsgul", "Khovsgol", "Hovsgol"), Cyrillic, NSO
statistical codes, ISO 3166-2 codes and P-codes. Names are compared
through a normalised key, so spelling variants, case, punctuation and
words such as "aimag", "province", "soum" or "district" do not matter.
Values that still do not match are tried with a small edit distance.

## Usage

``` r
mn_match(
  x,
  level = NULL,
  within = NULL,
  to = c("pcode", "name_en", "name_mn", "name_mns", "iso_code", "nso_code", "level",
    "type"),
  fuzzy = TRUE,
  max_dist = NULL,
  quiet = FALSE
)
```

## Arguments

- x:

  A character vector of names or codes (numbers and factors are
  converted to character).

- level:

  The level(s) to search: `"country"`, `"region"`, `"aimag"`, `"soum"`
  (includes Ulaanbaatar districts) or `"bag"` (includes khoroos). `NULL`
  (the default) searches every level, preferring aimags, then soums,
  regions, the country and bags.

- within:

  Restricts the search to units inside a parent, given as a name or
  code. Use it to separate soums that share a name. Either a single
  value or one value per element of `x`.

- to:

  What to return: `"pcode"` (default), `"name_en"`, `"name_mn"`,
  `"name_mns"`, `"iso_code"`, `"nso_code"`, `"level"` or `"type"`.

- fuzzy:

  If `TRUE` (default), values without an exact match are matched by edit
  distance when a single close candidate exists. Each fuzzy match is
  reported in a message so you can check it.

- max_dist:

  Maximum edit distance for fuzzy matching. `NULL` scales it with the
  length of the name (0 for 3 letters or fewer, up to 3 for long names).

- quiet:

  If `TRUE`, suppresses the message listing fuzzy matches. Warnings
  about ambiguous or unmatched values are always shown.

## Value

A character vector the same length as `x`. Values that cannot be
matched, or that match several units, are `NA` and are listed in a
warning.

## See also

Other names and codes:
[`mn_codes()`](https://temuulene.github.io/mongolmaps/reference/mn_codes.md),
[`mn_translit()`](https://temuulene.github.io/mongolmaps/reference/mn_translit.md)

## Examples

``` r
mn_match(c("Khuvsgul", "Hovsgol", "\\u0425\\u04e9\\u0432\\u0441\\u0433\\u04e9\\u043b", "MN-041"))
#> Warning: 1 value could not be matched and became "NA":
#> • \u0425\u04e9\u0432\u0441\u0433\u04e9\u043b
#> [1] "MN67" "MN67" NA     "MN67"

# NSO statistical codes work too
mn_match(c("183", "511", "51107"), to = "name_en")
#> [1] "Bayan-Ulgii" "Ulaanbaatar" "Bayangol"   

# Many soums share a name: say which aimag you mean
mn_match("Bayan-Uul", level = "soum", within = "Dornod")
#> [1] "MN2110"

# Khoroos are numbered within their district
mn_match("15-r khoroo", level = "bag", within = "Bayangol")
#> [1] "MN110779"
```
