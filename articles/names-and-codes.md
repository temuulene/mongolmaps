# Names and codes

``` r

library(mongolmaps)
```

Mongolian place names are written in many ways: Khovsgol, Khuvsgul,
Hovsgol, Khövsgöl or Хөвсгөл are the same aimag. mongolmaps gives every
unit one code and knows its other names.

## The codes

`pcode` is unique across all levels:

| Unit                   | pcode      | NSO code  | ISO 3166-2 |
|------------------------|------------|-----------|------------|
| Mongolia               | `MN`       | `0`       | `MN`       |
| Western region         | `MNR1`     | `1`       |            |
| Khovd aimag            | `MN84`     | `184`     | `MN-043`   |
| Jargalant soum (Khovd) | `MN8401`   | `18401`   |            |
| Ulaanbaatar            | `MN11`     | `511`     | `MN-1`     |
| Bayangol district      | `MN1107`   | `51107`   |            |
| Bayangol, 1st khoroo   | `MN110751` | `5110751` |            |

pcodes match the humanitarian Common Operational Dataset (COD) and are
the NSO codes without their leading region digit.
[`mn_codes()`](https://temuulene.github.io/mongolmaps/reference/mn_codes.md)
lists them all:

``` r

mn_codes("aimag")
#> # A tibble: 22 × 16
#>    pcode name      name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr> <chr>     <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN11  Ulaanbaa… Ulaanb… Улаанб… Ulaanba… aimag capi…     NA MN-1     511     
#>  2 MN21  Dornod    Dornod  Дорнод  Dornod   aimag aimag     NA MN-061   421     
#>  3 MN22  Sukhbaat… Sukhba… Сүхбаа… Sükhbaa… aimag aimag     NA MN-051   422     
#>  4 MN23  Khentii   Khentii Хэнтий  Khentii  aimag aimag     NA MN-039   423     
#>  5 MN41  Tuv       Tuv     Төв     Töv      aimag aimag     NA MN-047   341     
#>  6 MN42  Govisumb… Govisu… Говьсү… Govisüm… aimag aimag     NA MN-064   342     
#>  7 MN43  Selenge   Selenge Сэлэнгэ Selenge  aimag aimag     NA MN-049   343     
#>  8 MN44  Dornogovi Dornog… Дорног… Dornogo… aimag aimag     NA MN-063   344     
#>  9 MN45  Darkhan-… Darkha… Дархан… Darkhan… aimag aimag     NA MN-037   345     
#> 10 MN46  Umnugovi  Umnugo… Өмнөго… Ömnögovi aimag aimag     NA MN-053   346     
#> # ℹ 12 more rows
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>, has_geometry <lgl>
mn_codes("bag", within = "Baganuur")
#> # A tibble: 5 × 16
#>   pcode    name    name_en name_mn name_mns level type  number iso_code nso_code
#>   <chr>    <chr>   <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#> 1 MN110151 1-r kh… 1-r kh… 1-р хо… 1-r kho… bag   khor…      1 NA       5110151 
#> 2 MN110153 2-r kh… 2-r kh… 2-р хо… 2-r kho… bag   khor…      2 NA       5110153 
#> 3 MN110155 3-r kh… 3-r kh… 3-р хо… 3-r kho… bag   khor…      3 NA       5110155 
#> 4 MN110157 4-r kh… 4-r kh… 4-р хо… 4-r kho… bag   khor…      4 NA       5110157 
#> 5 MN110159 5-r kh… 5-r kh… 5-р хо… 5-r kho… bag   khor…      5 NA       5110159 
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>, has_geometry <lgl>
```

Bags and villages (tosgon) have codes and names but no public boundary
(`has_geometry` is `FALSE`).

## Matching names

[`mn_match()`](https://temuulene.github.io/mongolmaps/reference/mn_match.md)
turns names or codes into pcodes (or any other column):

``` r

mn_match(c("Khuvsgul", "Hovsgol", "Kh\u00f6vsg\u00f6l", "\u0425\u04e9\u0432\u0441\u0433\u04e9\u043b", "MN-041", "267"))
#> [1] "MN67" "MN67" "MN67" "MN67" "MN67" "MN67"
mn_match(c("MN84", "MN8401"), to = "name_mn")
#> [1] "Ховд"      "Жаргалант"
```

It ignores case, punctuation and words such as “aimag”, “province”,
“soum” or “district” – but uses them as hints when a name is shared:

``` r

mn_match(c("Sukhbaatar", "Sukhbaatar district", "Sukhbaatar soum"), within = c(NA, NA, "Selenge"))
#> [1] "MN22"   "MN1119" "MN4301"
```

Small typos are matched and reported:

``` r

mn_match("Ulanbaatr")
#> ℹ Matched 1 value approximately; please check:
#> • Ulanbaatr → Ulaanbaatar (MN11)
#> [1] "MN11"
```

When a name is shared by several units,
[`mn_match()`](https://temuulene.github.io/mongolmaps/reference/mn_match.md)
returns `NA` and says which ones; add `within` to choose:

``` r

mn_match("Bayan-Uul", level = "soum")
#> Warning: 1 value matches more than one unit and became "NA":
#> • Bayan-Uul: Bayan-Uul (MN2110, Dornod); Bayan-Uul (MN8207, Govi-Altai)
#> ℹ Use `within` (for example the aimag) to choose one.
#> [1] NA
mn_match("Bayan-Uul", level = "soum", within = "Dornod")
#> [1] "MN2110"
```

## Transliteration

[`mn_translit()`](https://temuulene.github.io/mongolmaps/reference/mn_translit.md)
romanises Cyrillic with a fixed table:

``` r

x <- c("\u04e8\u0432\u04e9\u0440\u0445\u0430\u043d\u0433\u0430\u0439", "\u0421\u04af\u0445\u0431\u0430\u0430\u0442\u0430\u0440")
mn_translit(x)
#> [1] "Övörkhangai" "Sükhbaatar"
mn_translit(x, to = "nso")
#> [1] "Uvurkhangai" "Sukhbaatar"
```

The default is the national standard MNS 5217:2012; `to = "nso"` gives
the plain-ASCII spellings used in NSO English tables.
