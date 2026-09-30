# Coordinate reference systems suited to Mongolia

Returns a projection that keeps Mongolia's shape and area true. Maps of
the whole country look best in an equal-area Albers or Lambert conic
projection centred on Mongolia; maps of Ulaanbaatar look best in UTM
zone 48N.

## Usage

``` r
mn_crs(type = c("albers", "lcc", "utm", "wgs84"))
```

## Arguments

- type:

  One of:

  - `"albers"`: Albers equal-area conic centred on 104E, 47N, with
    standard parallels 43.5N and 50.5N. Best for national choropleths
    because areas are true.

  - `"lcc"`: Lambert conformal conic with the same parameters. Keeps
    local shapes true.

  - `"utm"`: UTM zone 48N (EPSG:32648), the usual choice for Ulaanbaatar
    and central Mongolia.

  - `"wgs84"`: plain longitude and latitude (EPSG:4326).

## Value

An
[`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html)
object.

## See also

Other mapping helpers:
[`mn_aimag_grid`](https://temuulene.github.io/mongolmaps/reference/mn_aimag_grid.md),
[`mn_label_points()`](https://temuulene.github.io/mongolmaps/reference/mn_label_points.md),
[`mn_leaflet()`](https://temuulene.github.io/mongolmaps/reference/mn_leaflet.md),
[`mn_map()`](https://temuulene.github.io/mongolmaps/reference/mn_map.md),
[`theme_mn()`](https://temuulene.github.io/mongolmaps/reference/theme_mn.md)

## Examples

``` r
mn_crs()
#> Coordinate Reference System:
#>   User input: +proj=aea +lat_0=47 +lon_0=104 +lat_1=43.5 +lat_2=50.5 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs 
#>   wkt:
#> PROJCRS["unknown",
#>     BASEGEOGCRS["unknown",
#>         DATUM["World Geodetic System 1984",
#>             ELLIPSOID["WGS 84",6378137,298.257223563,
#>                 LENGTHUNIT["metre",1]],
#>             ID["EPSG",6326]],
#>         PRIMEM["Greenwich",0,
#>             ANGLEUNIT["degree",0.0174532925199433],
#>             ID["EPSG",8901]]],
#>     CONVERSION["unknown",
#>         METHOD["Albers Equal Area",
#>             ID["EPSG",9822]],
#>         PARAMETER["Latitude of false origin",47,
#>             ANGLEUNIT["degree",0.0174532925199433],
#>             ID["EPSG",8821]],
#>         PARAMETER["Longitude of false origin",104,
#>             ANGLEUNIT["degree",0.0174532925199433],
#>             ID["EPSG",8822]],
#>         PARAMETER["Latitude of 1st standard parallel",43.5,
#>             ANGLEUNIT["degree",0.0174532925199433],
#>             ID["EPSG",8823]],
#>         PARAMETER["Latitude of 2nd standard parallel",50.5,
#>             ANGLEUNIT["degree",0.0174532925199433],
#>             ID["EPSG",8824]],
#>         PARAMETER["Easting at false origin",0,
#>             LENGTHUNIT["metre",1],
#>             ID["EPSG",8826]],
#>         PARAMETER["Northing at false origin",0,
#>             LENGTHUNIT["metre",1],
#>             ID["EPSG",8827]]],
#>     CS[Cartesian,2],
#>         AXIS["(E)",east,
#>             ORDER[1],
#>             LENGTHUNIT["metre",1,
#>                 ID["EPSG",9001]]],
#>         AXIS["(N)",north,
#>             ORDER[2],
#>             LENGTHUNIT["metre",1,
#>                 ID["EPSG",9001]]]]
sf::st_transform(mn_aimags(), mn_crs("albers"))
#> Simple feature collection with 22 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -1182877 ymin: -601751.4 xmax: 1207275 ymax: 584211.5
#> Projected CRS: +proj=aea +lat_0=47 +lon_0=104 +lat_1=43.5 +lat_2=50.5 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs
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
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [m]>
```
