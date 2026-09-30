# Map context: neighbouring countries, rivers and lakes

Layers that give a map of Mongolia its surroundings and water.

## Usage

``` r
mn_neighbours(crs = NULL)

mn_rivers(detail = c("major", "all"), within = NULL, crs = NULL)

mn_lakes(detail = c("major", "all"), within = NULL, crs = NULL)
```

## Arguments

- crs:

  Coordinate reference system of the result. `NULL` (default) keeps
  longitude/latitude (EPSG:4326). Use `"albers"`, `"lcc"` or `"utm"` for
  a projection suited to Mongolia (see
  [`mn_crs()`](https://temuulene.github.io/mongolmaps/reference/mn_crs.md)),
  or any value accepted by
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html).

- detail:

  `"major"` for the main rivers and lakes (bundled), or `"all"` for
  everything in OpenStreetMap (downloaded).

- within:

  Keep only features inside these places (names or codes).

## Value

An `sf` tibble. Natural Earth layers have `name_en` and `scalerank`
(lower is more important). OpenStreetMap layers have `osm_id`, `name`,
`name_en`, `name_mn` and `class` (for example `"river"`, `"stream"`,
`"lake"` or `"reservoir"`).

## Details

- `mn_neighbours()`: the neighbouring parts of Russia, China and
  Kazakhstan (Natural Earth, public domain), clipped to a frame 300 km
  around Mongolia.

- `mn_rivers()` and `mn_lakes()`: with `detail = "major"` (default),
  major rivers and lakes from Natural Earth, bundled with the package.
  With `detail = "all"`, every river, stream, canal and water body
  mapped in OpenStreetMap (ODbL), downloaded once (about 20 MB) and
  cached.

## See also

Other thematic layers:
[`mn_protected_areas()`](https://temuulene.github.io/mongolmaps/reference/mn_protected_areas.md),
[`mn_roads()`](https://temuulene.github.io/mongolmaps/reference/mn_roads.md),
[`mn_settlements()`](https://temuulene.github.io/mongolmaps/reference/mn_settlements.md)

## Examples

``` r
mn_neighbours()
#> Simple feature collection with 3 features and 2 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 81.68486 ymin: 37.38575 xmax: 126.6633 ymax: 53.54906
#> Geodetic CRS:  WGS 84
#> # A tibble: 3 × 3
#>   iso3  name_en                                                         geometry
#>   <chr> <chr>                                                 <MULTIPOLYGON [°]>
#> 1 CHN   People's Republic of China (((120.4634 37.74775, 120.738 37.83397, 120.…
#> 2 KAZ   Kazakhstan                 (((84.25979 46.99974, 82.69872 50.83535, 82.…
#> 3 RUS   Russia                     (((87.21796 49.22981, 87.07601 49.23689, 86.…
mn_rivers()
#> Simple feature collection with 56 features and 3 fields
#> Geometry type: MULTILINESTRING
#> Dimension:     XY
#> Bounding box:  xmin: 83.19501 ymin: 37.51963 xmax: 126.3505 ymax: 54.95819
#> Geodetic CRS:  WGS 84
#> # A tibble: 56 × 4
#>    name_en         scalerank feature                                    geometry
#>    <chr>               <int> <chr>                         <MULTILINESTRING [°]>
#>  1 Amur                    3 River           ((121.4054 53.31708, 121.4585 53.3…
#>  2 Angara                  6 Lake Centerline ((106.4973 52.38312, 106.4898 52.4…
#>  3 Angara                  6 River           ((103.3741 53.10725, 103.3811 53.0…
#>  4 Argun                   3 River           ((122.2871 49.84931, 122.1747 49.7…
#>  5 Biya                    6 Lake Centerline ((87.39199 51.76159, 87.4126 51.75…
#>  6 Biya                    6 River           ((85.05615 52.43361, 85.06758 52.4…
#>  7 Bolshoy Yenisei         8 River           ((98.73315 52.51516, 98.70371 52.4…
#>  8 Chaor                   8 River           ((121.8268 48.7842, 121.8774 48.76…
#>  9 Chulym                  7 River           ((89.11206 54.09792, 89.09204 54.0…
#> 10 Chulyshman              6 River           ((87.75576 51.36437, 87.74941 51.3…
#> # ℹ 46 more rows
mn_lakes(within = "Khuvsgul")
#> Simple feature collection with 3 features and 2 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 98.80906 ymin: 49.14479 xmax: 100.796 ymax: 51.61981
#> Geodetic CRS:  WGS 84
#> # A tibble: 3 × 3
#>   name_en       scalerank                                               geometry
#>   <chr>             <int>                                     <MULTIPOLYGON [°]>
#> 1 Khovsgol Nuur         3 (((100.7669 51.44731, 100.7448 51.45673, 100.7207 51.…
#> 2 Dood Tsagaan          7 (((99.50847 51.49029, 99.49199 51.49294, 99.47668 51.…
#> 3 Sangiin Dalai         9 (((99.12786 49.25253, 99.1152 49.24959, 99.10372 49.2…
mn_rivers(detail = "all", within = "Ulaanbaatar")
#> ℹ Downloading Rivers, streams and water bodies (OpenStreetMap) (19.9 MB); this
#>   happens once.
#> Simple feature collection with 4443 features and 5 fields
#> Geometry type: MULTILINESTRING
#> Dimension:     XY
#> Bounding box:  xmin: 106.4625 ymin: 47.35603 xmax: 108.4999 ymax: 48.22817
#> Geodetic CRS:  WGS 84
#> # A tibble: 4,443 × 6
#>    osm_id        name  name_en name_mn class                            geometry
#>    <chr>         <chr> <chr>   <chr>   <chr>               <MULTILINESTRING [°]>
#>  1 way/933666181 NA    NA      NA      stream ((106.8376 47.74605, 106.8375 47.…
#>  2 way/923102281 NA    NA      NA      stream ((106.7528 47.73934, 106.7502 47.…
#>  3 way/907338522 NA    NA      NA      stream ((106.7541 47.7396, 106.7537 47.7…
#>  4 way/907338520 NA    NA      NA      stream ((106.7514 47.74151, 106.7513 47.…
#>  5 way/907338521 NA    NA      NA      stream ((106.754 47.7416, 106.7536 47.74…
#>  6 way/907338518 NA    NA      NA      stream ((106.7529 47.74241, 106.7534 47.…
#>  7 way/907338519 NA    NA      NA      stream ((106.7495 47.74297, 106.7487 47.…
#>  8 way/931582819 NA    NA      NA      river  ((106.7734 47.74336, 106.7732 47.…
#>  9 way/931582820 NA    NA      NA      river  ((106.7734 47.74336, 106.7734 47.…
#> 10 way/931582818 NA    NA      NA      river  ((106.7742 47.7467, 106.7742 47.7…
#> # ℹ 4,433 more rows
```
