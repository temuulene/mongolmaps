# Label points for map units

Returns one point per unit, placed well inside its polygon (unlike a
centroid, which can fall outside curved shapes). Points for the maps in
this package are precomputed; other polygons use
[`sf::st_point_on_surface()`](https://r-spatial.github.io/sf/reference/geos_unary.html).

## Usage

``` r
mn_label_points(x)
```

## Arguments

- x:

  An `sf` object of polygons.

## Value

An `sf` object of points with the attributes of `x`.

## See also

Other mapping helpers:
[`mn_aimag_grid`](https://temuulene.github.io/mongolmaps/reference/mn_aimag_grid.md),
[`mn_crs()`](https://temuulene.github.io/mongolmaps/reference/mn_crs.md),
[`mn_leaflet()`](https://temuulene.github.io/mongolmaps/reference/mn_leaflet.md),
[`mn_map()`](https://temuulene.github.io/mongolmaps/reference/mn_map.md),
[`theme_mn()`](https://temuulene.github.io/mongolmaps/reference/theme_mn.md)

## Examples

``` r
mn_label_points(mn_aimags())
#> Simple feature collection with 22 features and 15 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 89.81971 ymin: 43.35253 xmax: 114.2144 ymax: 50.37989
#> Geodetic CRS:  WGS 84
#> # A tibble: 22 × 16
#>    pcode name      name_en name_mn name_mns level type  number iso_code nso_code
#>  * <chr> <chr>     <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
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
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>, geometry <POINT [°]>
```
