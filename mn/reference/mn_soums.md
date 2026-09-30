# Soums of Mongolia and districts of Ulaanbaatar

Returns the 330 soums (rural districts) together with the 9 districts
(duureg) of Ulaanbaatar, which sit at the same level (`type` is `"soum"`
or `"district"`).

## Usage

``` r
mn_soums(aimag = NULL, resolution = c("low", "high"), lang = NULL, crs = NULL)
```

## Arguments

- aimag:

  Keep only soums in these aimags (names or codes).

- resolution:

  `"low"` (default) uses simplified boundaries that ship with the
  package and suit most maps. `"high"` uses full-resolution boundaries,
  downloaded once (about 10 MB) and cached; see
  [`mn_cache_dir()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_cache_dir.md).

- lang:

  Language of the `name` column: `"en"` (English, as in NSO tables),
  `"mn"` (Cyrillic) or `"mns"` (Latin with diacritics, MNS 5217).
  Defaults to `getOption("mongolmaps.lang", "en")`.

- crs:

  Coordinate reference system of the result. `NULL` (default) keeps
  longitude/latitude (EPSG:4326). Use `"albers"`, `"lcc"` or `"utm"` for
  a projection suited to Mongolia (see
  [`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md)),
  or any value accepted by
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html).

## Value

An `sf` tibble; see
[`mn_admin()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_admin.md)
for the columns.

## See also

Other admin boundaries:
[`mn_admin()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_admin.md),
[`mn_aimags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimags.md),
[`mn_bags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_bags.md),
[`mn_country()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_country.md),
[`mn_ub()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub.md)

## Examples

``` r
mn_soums()
#> Simple feature collection with 339 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 87.7345 ymin: 41.58183 xmax: 119.9315 ymax: 52.14835
#> Geodetic CRS:  WGS 84
#> # A tibble: 339 × 16
#>    pcode  name     name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr>  <chr>    <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN1101 Багануур Baganu… Багану… Baganuur soum  dist…     NA NA       51101   
#>  2 MN1104 Багахан… Bagakh… Багаха… Bagakha… soum  dist…     NA NA       51104   
#>  3 MN1107 Баянгол  Bayang… Баянгол Bayangol soum  dist…     NA NA       51107   
#>  4 MN1110 Баянзүрх Bayanz… Баянзү… Bayanzü… soum  dist…     NA NA       51110   
#>  5 MN1113 Налайх   Nalaikh Налайх  Nalaikh  soum  dist…     NA NA       51113   
#>  6 MN1116 Сонгино… Songin… Сонгин… Songino… soum  dist…     NA NA       51116   
#>  7 MN1119 Сүхбаат… Sukhba… Сүхбаа… Sükhbaa… soum  dist…     NA NA       51119   
#>  8 MN1122 Хан-Уул  Khan-U… Хан-Уул Khan-Uul soum  dist…     NA NA       51122   
#>  9 MN1125 Чингэлт… Chinge… Чингэл… Chingel… soum  dist…     NA NA       51125   
#> 10 MN2101 Хэрлэн   Kherlen Хэрлэн  Kherlen  soum  soum      NA NA       42101   
#> # ℹ 329 more rows
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
mn_soums(aimag = "Khovd")
#> Simple feature collection with 17 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 90.65037 ymin: 44.99983 xmax: 94.30692 ymax: 48.96636
#> Geodetic CRS:  WGS 84
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
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
mn_soums(aimag = c("Uvs", "Zavkhan"), lang = "mn")
#> Simple feature collection with 43 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 89.99998 ymin: 46.56551 xmax: 99.20735 ymax: 50.88443
#> Geodetic CRS:  WGS 84
#> # A tibble: 43 × 16
#>    pcode  name     name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr>  <chr>    <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN8101 Улиастай Uliast… Улиаст… Uliastai soum  soum      NA NA       18101   
#>  2 MN8104 Алдарха… Aldark… Алдарх… Aldarkh… soum  soum      NA NA       18104   
#>  3 MN8107 Асгат    Asgat   Асгат   Asgat    soum  soum      NA NA       18107   
#>  4 MN8110 Баянтэс  Bayant… Баянтэс Bayantes soum  soum      NA NA       18110   
#>  5 MN8113 Баянхай… Bayank… Баянха… Bayankh… soum  soum      NA NA       18113   
#>  6 MN8116 Дөрвөлж… Durvul… Дөрвөл… Dörvölj… soum  soum      NA NA       18116   
#>  7 MN8119 Завханм… Zavkha… Завхан… Zavkhan… soum  soum      NA NA       18119   
#>  8 MN8122 Идэр     Ider    Идэр    Ider     soum  soum      NA NA       18122   
#>  9 MN8125 Их-Уул   Ikh-Uul Их-Уул  Ikh-Uul  soum  soum      NA NA       18125   
#> 10 MN8128 Нөмрөг   Numrug  Нөмрөг  Nömrög   soum  soum      NA NA       18128   
#> # ℹ 33 more rows
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
```
