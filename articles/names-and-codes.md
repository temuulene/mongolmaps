# Names and codes

A place can have several spellings. Khovsgol, Khuvsgul, Khövsgöl and
Хөвсгөл refer to the same aimag. mongolmaps connects these names to one
place code. Use codes when joining data; use names for labels.

``` r

library(mongolmaps)
```

## Find a place code

[`mn_match()`](https://temuulene.github.io/mongolmaps/reference/mn_match.md)
returns a P-code by default. You can ask for another column, such as
`name_mn` or `nso_code`, with `to`.

``` r

mn_match(c("Khuvsgul", "Hovsgol", "Khövsgöl", "Хөвсгөл", "MN-041", "267"))
#> [1] "MN67" "MN67" "MN67" "MN67" "MN67" "MN67"
mn_match(c("MN84", "MN8401"), to = "name_mn")
#> [1] "Ховд"      "Жаргалант"
```

## Choose a code system

- `pcode`: a unique code across the package’s administrative levels.
- `nso_code`: the code used in National Statistics Office tables.
- `iso_code`: ISO 3166-2 for aimags and Ulaanbaatar; not available at
  every level.

This table comes from the package’s crosswalk rather than a hand-written
list. Store codes as text to preserve their formatting.

``` r

examples <- mn_codes()
examples <- examples[examples$pcode %in% c(
  "MN", "MNR1", "MN84", "MN8401", "MN11", "MN1107", "MN110751"
), ]
knitr::kable(examples[c("name_en", "pcode", "nso_code", "iso_code")])
```

| name_en        | pcode    | nso_code | iso_code |
|:---------------|:---------|:---------|:---------|
| Mongolia       | MN       | 0        | MN       |
| Western region | MNR1     | 1        | NA       |
| Ulaanbaatar    | MN11     | 511      | MN-1     |
| Khovd          | MN84     | 184      | MN-043   |
| Bayangol       | MN1107   | 51107    | NA       |
| Jargalant      | MN8401   | 18401    | NA       |
| 1-r khoroo     | MN110751 | 5110751  | NA       |

Use `mn_codes("aimag")` for all aimags and the capital. To see a few
khoroos and whether they have a boundary:

``` r

knitr::kable(mn_codes("bag", within = "Baganuur")[
  c("name_en", "pcode", "nso_code", "has_geometry")
])
```

| name_en    | pcode    | nso_code | has_geometry |
|:-----------|:---------|:---------|:-------------|
| 1-r khoroo | MN110151 | 5110151  | TRUE         |
| 2-r khoroo | MN110153 | 5110153  | TRUE         |
| 3-r khoroo | MN110155 | 5110155  | TRUE         |
| 4-r khoroo | MN110157 | 5110157  | TRUE         |
| 5-r khoroo | MN110159 | 5110159  | TRUE         |

Rural bags and villages have names and codes, but their boundaries are
not included. `has_geometry = FALSE` identifies these entries. See
[Bring your own bag
boundaries](https://temuulene.github.io/mongolmaps/articles/bags-from-nso.md).

## Resolve repeated names

Several soums share names such as Bayan-Uul. Restrict the search to the
right parent with `within`.

``` r

mn_match("Bayan-Uul", level = "soum", within = "Dornod")
#> [1] "MN2110"
mn_match("Sukhbaatar district", within = "Ulaanbaatar")
#> [1] "MN1119"
```

Without enough information,
[`mn_match()`](https://temuulene.github.io/mongolmaps/reference/mn_match.md)
returns `NA` and warns about the possible matches. Inspect the
candidates before choosing:

``` r

matches <- mn_match("Bayan-Uul", level = "soum", details = TRUE)
#> Warning: 1 value matches more than one unit and became "NA":
#> • Bayan-Uul: Bayan-Uul (MN2110, Dornod); Bayan-Uul (MN8207, Govi-Altai)
#> ℹ Use `within` (for example the aimag) to choose one.
matches[c("x", "pcode", "status")]
#> # A tibble: 1 × 3
#>   x         pcode status   
#>   <chr>     <chr> <chr>    
#> 1 Bayan-Uul NA    ambiguous
```

The warning in this example is intentional. When joining rows from
several aimags, use `by_parent`; see [Putting your data on a
map](https://temuulene.github.io/mongolmaps/articles/joining-data.md).

## Check spelling corrections

The matcher ignores case and punctuation and uses words such as “aimag”
or “district” to help identify the level. It can also suggest a close
spelling. Review these suggestions before using them.

``` r

mn_match("Ulanbaatr", details = TRUE)[c("x", "pcode", "status")]
#> # A tibble: 1 × 3
#>   x         pcode status
#>   <chr>     <chr> <chr> 
#> 1 Ulanbaatr MN11  fuzzy
```

To disallow approximate spelling matches, set `fuzzy = FALSE`. For a
join that must stop on uncertain matches, use
`mn_join(..., strict = TRUE)`.

## Convert Cyrillic to Latin letters

[`mn_translit()`](https://temuulene.github.io/mongolmaps/reference/mn_translit.md)
converts spelling; it does not identify a place or check that it exists.

``` r

x <- c("Өвөрхангай", "Сүхбаатар")
mn_translit(x)
#> [1] "Övörkhangai" "Sükhbaatar"
mn_translit(x, to = "nso")
#> [1] "Uvurkhangai" "Sukhbaatar"
```

The default uses MNS 5217:2012. `to = "nso"` gives the plain Latin
spellings used in NSO English tables.
