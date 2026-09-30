# Roads, railways, airports and places from OpenStreetMap

Transport and settlement layers from OpenStreetMap, prepared from the
Humanitarian OpenStreetMap Team exports. Each layer is downloaded once
(roads about 30 MB, the others smaller) and cached; see
[`mn_download()`](https://temuulene.github.io/mongolmaps/reference/mn_cache_dir.md).

## Usage

``` r
mn_roads(class = "main", within = NULL, crs = NULL)

mn_railways(stations = FALSE, within = NULL, crs = NULL)

mn_airports(within = NULL, crs = NULL)

mn_places(
  type = c("city", "town", "village"),
  within = NULL,
  lang = NULL,
  crs = NULL
)
```

## Arguments

- class:

  Road classes to keep: `"main"` (motorways to tertiary roads, the
  default), `"minor"` (residential, service and unclassified streets),
  `"track"`, `"path"`, or `"all"`.

- within:

  Keep only features inside these places (names or codes of any level
  with a boundary, such as `"Ulaanbaatar"` or `"Khovd"`).

- crs:

  Coordinate reference system of the result. `NULL` (default) keeps
  longitude/latitude (EPSG:4326). Use `"albers"`, `"lcc"` or `"utm"` for
  a projection suited to Mongolia (see
  [`mn_crs()`](https://temuulene.github.io/mongolmaps/reference/mn_crs.md)),
  or any value accepted by
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html).

- stations:

  If `TRUE`, `mn_railways()` returns railway stations as points instead
  of the lines.

- type:

  Place types for `mn_places()`: any of `"city"`, `"town"`, `"village"`,
  `"hamlet"`, `"suburb"` and `"isolated_dwelling"`.

- lang:

  Language of the `name` column: `"en"` (English, as in NSO tables),
  `"mn"` (Cyrillic) or `"mns"` (Latin with diacritics, MNS 5217).
  Defaults to `getOption("mongolmaps.lang", "en")`.

## Value

An `sf` tibble with `osm_id`, `name` (in the chosen language, where
OpenStreetMap has it), `name_en`, `name_mn` and layer-specific columns:
`highway`, `class` and `surface` for roads; `railway` for railways;
`place` and `population` for places.

## Details

Use `within` to get a layer for one place: only the features in that
place's bounding box are read from disk, then lines are cut at its
border.

## Licence

OpenStreetMap data are available under the Open Database Licence (ODbL).
Credit "(c) OpenStreetMap contributors" when you publish maps;
`mn_citation("osm_roads")` gives the text.

## See also

Other thematic layers:
[`mn_neighbours()`](https://temuulene.github.io/mongolmaps/reference/mn_neighbours.md),
[`mn_protected_areas()`](https://temuulene.github.io/mongolmaps/reference/mn_protected_areas.md),
[`mn_settlements()`](https://temuulene.github.io/mongolmaps/reference/mn_settlements.md)

## Examples

``` r
ub_roads <- mn_roads(class = c("main", "minor"), within = "Ulaanbaatar")
#> ℹ Downloading Roads and streets (OpenStreetMap) (29.2 MB); this happens once.
mn_railways()
#> ℹ Downloading Railways, stations and airports (OpenStreetMap) (0.5 MB); this
#>   happens once.
#> Simple feature collection with 2193 features and 5 fields
#> Geometry type: LINESTRING
#> Dimension:     XY
#> Bounding box:  xmin: 101.2877 ymin: 42.43314 xmax: 116.3212 ymax: 50.33492
#> Geodetic CRS:  WGS 84
#> # A tibble: 2,193 × 6
#>    osm_id         name         name_en name_mn railway                  geometry
#>    <chr>          <chr>        <chr>   <chr>   <chr>            <LINESTRING [°]>
#>  1 way/1410189427 NA           NA      NA      rail    (107.1644 47.78966, 107.…
#>  2 way/1410189426 NA           NA      NA      rail    (107.1649 47.78965, 107.…
#>  3 way/1410189428 Trans-Mongo… Trans-… Транс-… rail    (107.1633 47.78983, 107.…
#>  4 way/1410189429 Trans-Mongo… Trans-… Транс-… rail    (107.163 47.78986, 107.1…
#>  5 way/534729400  Trans-Mongo… Trans-… Транс-… rail    (107.1402 47.79823, 107.…
#>  6 way/534729401  Trans-Mongo… Trans-… Транс-… rail    (107.1401 47.79822, 107.…
#>  7 way/534729405  Trans-Mongo… Trans-… Транс-… rail    (107.1439 47.80119, 107.…
#>  8 way/534729406  Trans-Mongo… Trans-… Транс-… rail    (107.144 47.80116, 107.1…
#>  9 way/304225179  Trans-Mongo… Trans-… Транс-… rail    (107.1564 47.80403, 107.…
#> 10 way/304225184  Trans-Mongo… Trans-… Транс-… rail    (107.1566 47.8042, 107.1…
#> # ℹ 2,183 more rows
mn_airports()
#> Simple feature collection with 33 features and 4 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 89.92158 ymin: 43.01848 xmax: 114.6454 ymax: 50.4411
#> Geodetic CRS:  WGS 84
#> # A tibble: 33 × 5
#>    osm_id            name              name_en name_mn            geometry
#>    <chr>             <chr>             <chr>   <chr>           <POINT [°]>
#>  1 way/297823696     Otgontenger Airp… Otgont… Отгонт… (96.52599 47.70695)
#>  2 way/216874909     Khovd Airport     Khovd … Аэропо… (91.63058 47.94923)
#>  3 way/570437198     Choibalsan Airpo… Choiba… Чойбал… (114.6454 48.13632)
#>  4 node/1042101442   Airport           Airport Онгоцн…   (110.608 48.6067)
#>  5 way/835351242     Dadal             Dadal   NA      (111.5078 49.01496)
#>  6 way/28902695      Buyant-Ukhaa Int… Buyant… Буянт-… (106.7668 47.84298)
#>  7 relation/13024511 Airstrip Moron    Airstr… Airstr… (100.0968 49.66393)
#>  8 node/346155959    NA                NA      NA      (94.37249 49.66509)
#>  9 way/215497442     Ulaangom Airport  Ulaang… Аэропо… (91.93597 50.06667)
#> 10 way/395690126     Khatgal Airport   Khatga… Хатгал   (100.1338 50.4411)
#> # ℹ 23 more rows
mn_places(within = "Khovd")
#> ℹ Downloading Populated places (OpenStreetMap) (0.1 MB); this happens once.
#> Simple feature collection with 22 features and 6 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 91.37414 ymin: 45.80627 xmax: 93.61881 ymax: 48.50362
#> Geodetic CRS:  WGS 84
#> # A tibble: 22 × 7
#>    osm_id       name  name_en name_mn place population            geometry
#>    <chr>        <chr> <chr>   <chr>   <chr>      <int>         <POINT [°]>
#>  1 node/199804… Chan… Chandm… Чандма… town          NA (92.81577 47.66628)
#>  2 node/308452… Khovd Khovd   Ховд    city       28601 (91.64524 48.00064)
#>  3 node/386056… Khov… Khovd … Ховд с… town          NA (91.37414 48.12881)
#>  4 node/377479… Buya… Buyant  Буянт   town          NA  (91.7626 48.17352)
#>  5 node/226202… Myan… Myangad Мянгад  town          NA (91.92434 48.23306)
#>  6 way/1891502… Durg… Durgun  Дөргөн  town          NA (92.63081 48.33447)
#>  7 node/199803… Dörg… Dörgön  Дөргөн  town          NA (92.63167 48.33631)
#>  8 node/199804… Erde… Erdene… Эрдэнэ… town          NA (91.44844 48.50362)
#>  9 node/235178… Bor-… Bor-Üz… Бор-Үз… vill…         NA (92.28821 45.80627)
#> 10 node/238101… Altai Altai   Алтай   town          NA (92.52295 46.01333)
#> # ℹ 12 more rows
```
