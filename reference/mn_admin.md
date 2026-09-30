# Administrative boundaries of Mongolia at any level

The engine behind
[`mn_country()`](https://temuulene.github.io/mongolmaps/reference/mn_country.md),
[`mn_regions()`](https://temuulene.github.io/mongolmaps/reference/mn_country.md),
[`mn_aimags()`](https://temuulene.github.io/mongolmaps/reference/mn_aimags.md),
[`mn_soums()`](https://temuulene.github.io/mongolmaps/reference/mn_soums.md),
[`mn_khoroos()`](https://temuulene.github.io/mongolmaps/reference/mn_ub.md)
and
[`mn_bags()`](https://temuulene.github.io/mongolmaps/reference/mn_bags.md).
Every function returns the same columns, so maps from different levels
can be combined and joined in the same way.

## Usage

``` r
mn_admin(
  level = "aimag",
  within = NULL,
  resolution = c("low", "high"),
  lang = NULL,
  crs = NULL
)
```

## Arguments

- level:

  The level to return:

  - `"country"`: Mongolia.

  - `"region"`: the five economic regions used by NSO (Western, Khangai,
    Central, Eastern, Ulaanbaatar).

  - `"aimag"`: the 21 aimags (provinces) and the capital, Ulaanbaatar.

  - `"soum"`: the 330 soums and the 9 districts (duureg) of Ulaanbaatar.

  - `"bag"`: the 204 khoroos of Ulaanbaatar, plus rural bags if you have
    registered a bag boundary file (see
    [`mn_bags()`](https://temuulene.github.io/mongolmaps/reference/mn_bags.md)).

  Synonyms such as `"province"`, `"district"`, `"adm1"` or `"khoroo"`
  also work.

- within:

  Keep only units inside these places, or these places themselves: names
  or codes of any level, such as `"Khovd"`, `"MN84"` or
  `"Western region"`.

- resolution:

  `"low"` (default) uses simplified boundaries that ship with the
  package and suit most maps. `"high"` uses full-resolution boundaries,
  downloaded once (about 10 MB) and cached; see
  [`mn_cache_dir()`](https://temuulene.github.io/mongolmaps/reference/mn_cache_dir.md).

- lang:

  Language of the `name` column: `"en"` (English, as in NSO tables),
  `"mn"` (Cyrillic) or `"mns"` (Latin with diacritics, MNS 5217).
  Defaults to `getOption("mongolmaps.lang", "en")`.

- crs:

  Coordinate reference system of the result. `NULL` (default) keeps
  longitude/latitude (EPSG:4326). Use `"albers"`, `"lcc"` or `"utm"` for
  a projection suited to Mongolia (see
  [`mn_crs()`](https://temuulene.github.io/mongolmaps/reference/mn_crs.md)),
  or any value accepted by
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html).

## Value

An `sf` tibble with one row per unit and the columns:

- pcode:

  Unique code (see
  [`mn_codes()`](https://temuulene.github.io/mongolmaps/reference/mn_codes.md)).

- name:

  Name in the language chosen with `lang`.

- name_en, name_mn, name_mns:

  English, Cyrillic and MNS Latin names.

- level, type:

  Level (`"aimag"`, `"soum"`, ...) and type (`"capital"`, `"district"`,
  `"khoroo"`, ...).

- number:

  Bag or khoroo number within its soum or district.

- iso_code:

  ISO 3166-2 code (aimags only).

- nso_code:

  Code used in NSO statistical tables.

- parent_pcode, region_pcode, aimag_pcode, soum_pcode:

  Codes of the units that contain this one.

- area_km2:

  Area in square kilometres, computed from the full-resolution boundary.

- geometry:

  Multipolygon boundary.

## See also

Other admin boundaries:
[`mn_aimags()`](https://temuulene.github.io/mongolmaps/reference/mn_aimags.md),
[`mn_bags()`](https://temuulene.github.io/mongolmaps/reference/mn_bags.md),
[`mn_country()`](https://temuulene.github.io/mongolmaps/reference/mn_country.md),
[`mn_soums()`](https://temuulene.github.io/mongolmaps/reference/mn_soums.md),
[`mn_ub()`](https://temuulene.github.io/mongolmaps/reference/mn_ub.md)

## Examples

``` r
mn_admin("aimag")
#> Simple feature collection with 22 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 87.7345 ymin: 41.58183 xmax: 119.9315 ymax: 52.14835
#> Geodetic CRS:  WGS 84
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
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
mn_admin("soum", within = "Khovd")
#> Simple feature collection with 17 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 90.65037 ymin: 44.99983 xmax: 94.30692 ymax: 48.96636
#> Geodetic CRS:  WGS 84
#> # A tibble: 17 × 16
#>    pcode  name     name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr>  <chr>    <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN8401 Jargala… Jargal… Жаргал… Jargala… soum  soum      NA NA       18401   
#>  2 MN8404 Altai    Altai   Алтай   Altai    soum  soum      NA NA       18404   
#>  3 MN8407 Bulgan   Bulgan  Булган  Bulgan   soum  soum      NA NA       18407   
#>  4 MN8410 Buyant   Buyant  Буянт   Buyant   soum  soum      NA NA       18410   
#>  5 MN8413 Darvi    Darvi   Дарви   Darvi    soum  soum      NA NA       18413   
#>  6 MN8416 Durgun   Durgun  Дөргөн  Dörgön   soum  soum      NA NA       18416   
#>  7 MN8419 Duut     Duut    Дуут    Duut     soum  soum      NA NA       18419   
#>  8 MN8422 Zereg    Zereg   Зэрэг   Zereg    soum  soum      NA NA       18422   
#>  9 MN8425 Mankhan  Mankhan Манхан  Mankhan  soum  soum      NA NA       18425   
#> 10 MN8428 Munkhkh… Munkhk… Мөнхха… Mönkhkh… soum  soum      NA NA       18428   
#> 11 MN8431 Must     Must    Мөст    Möst     soum  soum      NA NA       18431   
#> 12 MN8434 Myangad  Myangad Мянгад  Myangad  soum  soum      NA NA       18434   
#> 13 MN8437 Uyench   Uyench  Үенч    Üyench   soum  soum      NA NA       18437   
#> 14 MN8440 Khovd    Khovd   Ховд    Khovd    soum  soum      NA NA       18440   
#> 15 MN8443 Tsetseg  Tsetseg Цэцэг   Tsetseg  soum  soum      NA NA       18443   
#> 16 MN8446 Chandma… Chandm… Чандма… Chandma… soum  soum      NA NA       18446   
#> 17 MN8449 Erdeneb… Erdene… Эрдэнэ… Erdeneb… soum  soum      NA NA       18449   
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
mn_admin("aimag", within = c("Khovd", "Uvs"), lang = "mn")
#> Simple feature collection with 2 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 89.99998 ymin: 44.99983 xmax: 95.68892 ymax: 50.88443
#> Geodetic CRS:  WGS 84
#> # A tibble: 2 × 16
#>   pcode name  name_en name_mn name_mns level type  number iso_code nso_code
#>   <chr> <chr> <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#> 1 MN84  Ховд  Khovd   Ховд    Khovd    aimag aimag     NA MN-043   184     
#> 2 MN85  Увс   Uvs     Увс     Uvs      aimag aimag     NA MN-046   185     
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
```
