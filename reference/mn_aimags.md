# Aimags (provinces) of Mongolia

Returns the 21 aimags and the capital, Ulaanbaatar, which has aimag
status (`type = "capital"`).

## Usage

``` r
mn_aimags(
  region = NULL,
  resolution = c("low", "high"),
  lang = NULL,
  crs = NULL
)
```

## Arguments

- region:

  Keep only aimags in these economic regions, such as `"Western"` or
  `"Khangai region"`. You can also name aimags here to select them
  directly.

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

An `sf` tibble; see
[`mn_admin()`](https://temuulene.github.io/mongolmaps/reference/mn_admin.md)
for the columns.

## See also

Other admin boundaries:
[`mn_admin()`](https://temuulene.github.io/mongolmaps/reference/mn_admin.md),
[`mn_bags()`](https://temuulene.github.io/mongolmaps/reference/mn_bags.md),
[`mn_country()`](https://temuulene.github.io/mongolmaps/reference/mn_country.md),
[`mn_soums()`](https://temuulene.github.io/mongolmaps/reference/mn_soums.md),
[`mn_ub()`](https://temuulene.github.io/mongolmaps/reference/mn_ub.md)

## Examples

``` r
aimags <- mn_aimags()
aimags
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
mn_aimags(region = "Western")
#> Simple feature collection with 5 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 87.7345 ymin: 42.69975 xmax: 99.20735 ymax: 50.88443
#> Geodetic CRS:  WGS 84
#> # A tibble: 5 × 16
#>   pcode name       name_en name_mn name_mns level type  number iso_code nso_code
#>   <chr> <chr>      <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#> 1 MN81  Zavkhan    Zavkhan Завхан  Zavkhan  aimag aimag     NA MN-057   181     
#> 2 MN82  Govi-Altai Govi-A… Говь-А… Govi-Al… aimag aimag     NA MN-065   182     
#> 3 MN83  Bayan-Ulg… Bayan-… Баян-Ө… Bayan-Ö… aimag aimag     NA MN-071   183     
#> 4 MN84  Khovd      Khovd   Ховд    Khovd    aimag aimag     NA MN-043   184     
#> 5 MN85  Uvs        Uvs     Увс     Uvs      aimag aimag     NA MN-046   185     
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
mn_aimags(lang = "mn")
#> Simple feature collection with 22 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 87.7345 ymin: 41.58183 xmax: 119.9315 ymax: 52.14835
#> Geodetic CRS:  WGS 84
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
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
```
