# Mongolia and its economic regions

`mn_country()` returns the outline of Mongolia. `mn_regions()` returns
the five economic regions used in NSO statistics: Western, Khangai,
Central, Eastern and Ulaanbaatar.

## Usage

``` r
mn_country(resolution = c("low", "high"), lang = NULL, crs = NULL)

mn_regions(resolution = c("low", "high"), lang = NULL, crs = NULL)
```

## Arguments

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
[`mn_aimags()`](https://temuulene.github.io/mongolmaps/reference/mn_aimags.md),
[`mn_bags()`](https://temuulene.github.io/mongolmaps/reference/mn_bags.md),
[`mn_soums()`](https://temuulene.github.io/mongolmaps/reference/mn_soums.md),
[`mn_ub()`](https://temuulene.github.io/mongolmaps/reference/mn_ub.md)

## Examples

``` r
mn_country()
#> Simple feature collection with 1 feature and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 87.7345 ymin: 41.58183 xmax: 119.9315 ymax: 52.14835
#> Geodetic CRS:  WGS 84
#> # A tibble: 1 × 16
#>   pcode name     name_en  name_mn  name_mns level type  number iso_code nso_code
#>   <chr> <chr>    <chr>    <chr>    <chr>    <chr> <chr>  <int> <chr>    <chr>   
#> 1 MN    Mongolia Mongolia Монгол … Mongol … coun… coun…     NA MN       0       
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
mn_regions()
#> Simple feature collection with 5 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 87.7345 ymin: 41.58183 xmax: 119.9315 ymax: 52.14835
#> Geodetic CRS:  WGS 84
#> # A tibble: 5 × 16
#>   pcode name       name_en name_mn name_mns level type  number iso_code nso_code
#>   <chr> <chr>      <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#> 1 MNR1  Western r… Wester… Баруун… Baruun … regi… regi…     NA NA       1       
#> 2 MNR2  Khangai r… Khanga… Хангай… Khangai… regi… regi…     NA NA       2       
#> 3 MNR3  Central r… Centra… Төвийн… Töviin … regi… regi…     NA NA       3       
#> 4 MNR4  Eastern r… Easter… Зүүн б… Züün büs regi… regi…     NA NA       4       
#> 5 MNR5  Ulaanbaat… Ulaanb… Улаанб… Ulaanba… regi… regi…     NA NA       5       
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
```
