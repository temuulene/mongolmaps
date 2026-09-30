# Codes and names of Mongolian administrative units

Returns the table behind every map in the package: one row per unit,
from the country down to bags and khoroos, with its codes, names and
place in the hierarchy. Use it to look up codes, to build your own
crosswalks, or to see which units have a boundary.

## Usage

``` r
mn_codes(level = NULL, within = NULL, aliases = FALSE, lang = NULL)
```

## Arguments

- level:

  Levels to return (see
  [`mn_match()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_match.md));
  `NULL` returns all.

- within:

  Keep only units inside this parent (a name or code).

- aliases:

  If `TRUE`, return one row per known spelling of each unit (the table
  used by
  [`mn_match()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_match.md))
  instead of one row per unit.

- lang:

  Language of the `name` column: `"en"` (English, as in NSO tables),
  `"mn"` (Cyrillic) or `"mns"` (Latin with diacritics). Defaults to
  `getOption("mongolmaps.lang", "en")`.

## Value

A tibble. With `aliases = FALSE`: the columns of every admin map (see
[`mn_admin()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_admin.md))
plus `has_geometry`. With `aliases = TRUE`: `pcode`, `level`, `name_en`,
`alias` and `source`.

## Details

Units are identified by `pcode`, a code that is unique across levels:

- `"MN"` for the country, `"MNR1"` to `"MNR5"` for the economic regions
  (Western, Khangai, Central, Eastern, Ulaanbaatar);

- `"MN"` + the two-digit NSO aimag code for aimags (`"MN84"` Khovd,
  `"MN11"` Ulaanbaatar);

- two more digits for soums and Ulaanbaatar districts (`"MN8401"`), and
  two more for bags and khoroos (`"MN110751"`).

These match the P-codes of the humanitarian Common Operational Dataset
and are the NSO statistical codes without their leading region digit
(`nso_code`, as used in NSO PXWeb tables).

The `type` column separates units that share a level: `"capital"`
(Ulaanbaatar) among aimags; `"district"` and `"village"` among soums;
`"khoroo"` among bags. Villages (tosgon) and rural bags have codes and
statistics but no boundary (`has_geometry` is `FALSE`).

## See also

Other names and codes:
[`mn_match()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_match.md),
[`mn_translit()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_translit.md)

## Examples

``` r
mn_codes("aimag")
#> # A tibble: 22 × 16
#>    pcode name      name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr> <chr>     <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN11  Улаанбаа… Ulaanb… Улаанб… Ulaanba… aimag capi…     NA MN-1     511     
#>  2 MN21  Дорнод    Dornod  Дорнод  Dornod   aimag aimag     NA MN-061   421     
#>  3 MN22  Сүхбаатар Sukhba… Сүхбаа… Sükhbaa… aimag aimag     NA MN-051   422     
#>  4 MN23  Хэнтий    Khentii Хэнтий  Khentii  aimag aimag     NA MN-039   423     
#>  5 MN41  Төв       Tuv     Төв     Töv      aimag aimag     NA MN-047   341     
#>  6 MN42  Говьсүмб… Govisu… Говьсү… Govisüm… aimag aimag     NA MN-064   342     
#>  7 MN43  Сэлэнгэ   Selenge Сэлэнгэ Selenge  aimag aimag     NA MN-049   343     
#>  8 MN44  Дорноговь Dornog… Дорног… Dornogo… aimag aimag     NA MN-063   344     
#>  9 MN45  Дархан-У… Darkha… Дархан… Darkhan… aimag aimag     NA MN-037   345     
#> 10 MN46  Өмнөговь  Umnugo… Өмнөго… Ömnögovi aimag aimag     NA MN-053   346     
#> # ℹ 12 more rows
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>, has_geometry <lgl>
mn_codes("soum", within = "Khovd")
#> # A tibble: 17 × 16
#>    pcode  name     name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr>  <chr>    <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN8401 Жаргала… Jargal… Жаргал… Jargala… soum  soum      NA NA       18401   
#>  2 MN8404 Алтай    Altai   Алтай   Altai    soum  soum      NA NA       18404   
#>  3 MN8407 Булган   Bulgan  Булган  Bulgan   soum  soum      NA NA       18407   
#>  4 MN8410 Буянт    Buyant  Буянт   Buyant   soum  soum      NA NA       18410   
#>  5 MN8413 Дарви    Darvi   Дарви   Darvi    soum  soum      NA NA       18413   
#>  6 MN8416 Дөргөн   Durgun  Дөргөн  Dörgön   soum  soum      NA NA       18416   
#>  7 MN8419 Дуут     Duut    Дуут    Duut     soum  soum      NA NA       18419   
#>  8 MN8422 Зэрэг    Zereg   Зэрэг   Zereg    soum  soum      NA NA       18422   
#>  9 MN8425 Манхан   Mankhan Манхан  Mankhan  soum  soum      NA NA       18425   
#> 10 MN8428 Мөнххай… Munkhk… Мөнхха… Mönkhkh… soum  soum      NA NA       18428   
#> 11 MN8431 Мөст     Must    Мөст    Möst     soum  soum      NA NA       18431   
#> 12 MN8434 Мянгад   Myangad Мянгад  Myangad  soum  soum      NA NA       18434   
#> 13 MN8437 Үенч     Uyench  Үенч    Üyench   soum  soum      NA NA       18437   
#> 14 MN8440 Ховд     Khovd   Ховд    Khovd    soum  soum      NA NA       18440   
#> 15 MN8443 Цэцэг    Tsetseg Цэцэг   Tsetseg  soum  soum      NA NA       18443   
#> 16 MN8446 Чандмань Chandm… Чандма… Chandma… soum  soum      NA NA       18446   
#> 17 MN8449 Эрдэнэб… Erdene… Эрдэнэ… Erdeneb… soum  soum      NA NA       18449   
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>, has_geometry <lgl>
mn_codes("aimag", aliases = TRUE)
#> # A tibble: 33 × 5
#>    pcode level name_en      alias        source 
#>    <chr> <chr> <chr>        <chr>        <chr>  
#>  1 MN65  aimag Arkhangai    Arkhangai    name_en
#>  2 MN64  aimag Bayankhongor Bayankhongor name_en
#>  3 MN83  aimag Bayan-Ulgii  Bayan-Ulgii  name_en
#>  4 MN63  aimag Bulgan       Bulgan       name_en
#>  5 MN45  aimag Darkhan-Uul  Darkhan-Uul  name_en
#>  6 MN48  aimag Dundgovi     Dundgovi     name_en
#>  7 MN21  aimag Dornod       Dornod       name_en
#>  8 MN44  aimag Dornogovi    Dornogovi    name_en
#>  9 MN44  aimag Dornogovi    East Gobi    manual 
#> 10 MN82  aimag Govi-Altai   Govi-Altai   name_en
#> # ℹ 23 more rows
```
