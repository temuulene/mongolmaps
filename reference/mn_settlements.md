# Settlements: the capital, aimag centres and soum centres

Points for Ulaanbaatar, the 21 aimag centres and the soum centres, handy
for labelling maps. Locations come from Wikidata; a few soums without
coordinates there use a point inside the soum (see `location_source`).

## Usage

``` r
mn_settlements(
  type = c("capital", "aimag_centre", "soum_centre"),
  within = NULL,
  lang = NULL,
  crs = NULL
)
```

## Arguments

- type:

  Which settlements to return: any of `"capital"`, `"aimag_centre"` and
  `"soum_centre"`. By default, all.

- within:

  Keep only settlements inside these places (names or codes).

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

An `sf` tibble of points with columns `admin_pcode` (the aimag or soum
the settlement is the centre of), `soum_pcode`, `aimag_pcode`, `type`,
`name`, `name_en`, `name_mn`, `name_mns` and `location_source`.

## See also

Other thematic layers:
[`mn_neighbours()`](https://temuulene.github.io/mongolmaps/reference/mn_neighbours.md),
[`mn_protected_areas()`](https://temuulene.github.io/mongolmaps/reference/mn_protected_areas.md),
[`mn_roads()`](https://temuulene.github.io/mongolmaps/reference/mn_roads.md)

## Examples

``` r
mn_settlements(type = c("capital", "aimag_centre"))
#> Simple feature collection with 22 features and 9 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 89.96321 ymin: 43.57 xmax: 114.5228 ymax: 50.36529
#> Geodetic CRS:  WGS 84
#> # A tibble: 22 × 10
#>    admin_pcode soum_pcode aimag_pcode type        name  name_en name_mn name_mns
#>    <chr>       <chr>      <chr>       <chr>       <chr> <chr>   <chr>   <chr>   
#>  1 MN11        NA         MN11        capital     Ulaa… Ulaanb… Улаанб… Ulaanba…
#>  2 MN21        MN2101     MN21        aimag_cent… Choi… Choiba… Чойбал… Choibal…
#>  3 MN22        MN2201     MN22        aimag_cent… Baru… Baruun… Баруун… Baruun-…
#>  4 MN23        MN2301     MN23        aimag_cent… Chin… Chingis Чингис  Chingis 
#>  5 MN41        MN4101     MN41        aimag_cent… Zuun… Zuunmod Зуунмод Zuunmod 
#>  6 MN42        MN4201     MN42        aimag_cent… Choir Choir   Чойр    Choir   
#>  7 MN43        MN4301     MN43        aimag_cent… Sukh… Sukhba… Сүхбаа… Sükhbaa…
#>  8 MN44        MN4401     MN44        aimag_cent… Sain… Sainsh… Сайнша… Sainsha…
#>  9 MN45        MN4501     MN45        aimag_cent… Dark… Darkhan Дархан  Darkhan 
#> 10 MN46        MN4601     MN46        aimag_cent… Dala… Dalanz… Даланз… Dalanza…
#> # ℹ 12 more rows
#> # ℹ 2 more variables: location_source <chr>, geometry <POINT [°]>
mn_settlements(within = "Khovd")
#> Simple feature collection with 17 features and 9 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 91.375 ymin: 45.80778 xmax: 93.61833 ymax: 48.50361
#> Geodetic CRS:  WGS 84
#> # A tibble: 17 × 10
#>    admin_pcode soum_pcode aimag_pcode type        name  name_en name_mn name_mns
#>    <chr>       <chr>      <chr>       <chr>       <chr> <chr>   <chr>   <chr>   
#>  1 MN84        MN8401     MN84        aimag_cent… Khovd Khovd   Ховд    Khovd   
#>  2 MN8404      MN8404     MN84        soum_centre Altai Altai   Алтай   Altai   
#>  3 MN8407      MN8407     MN84        soum_centre Bulg… Bulgan  Булган  Bulgan  
#>  4 MN8410      MN8410     MN84        soum_centre Buya… Buyant  Буянт   Buyant  
#>  5 MN8413      MN8413     MN84        soum_centre Darvi Darvi   Дарви   Darvi   
#>  6 MN8416      MN8416     MN84        soum_centre Durg… Durgun  Дөргөн  Dörgön  
#>  7 MN8419      MN8419     MN84        soum_centre Duut  Duut    Дуут    Duut    
#>  8 MN8422      MN8422     MN84        soum_centre Zereg Zereg   Зэрэг   Zereg   
#>  9 MN8425      MN8425     MN84        soum_centre Mank… Mankhan Манхан  Mankhan 
#> 10 MN8428      MN8428     MN84        soum_centre Munk… Munkhk… Мөнхха… Mönkhkh…
#> 11 MN8431      MN8431     MN84        soum_centre Must  Must    Мөст    Möst    
#> 12 MN8434      MN8434     MN84        soum_centre Myan… Myangad Мянгад  Myangad 
#> 13 MN8437      MN8437     MN84        soum_centre Uyen… Uyench  Үенч    Üyench  
#> 14 MN8440      MN8440     MN84        soum_centre Khovd Khovd   Ховд    Khovd   
#> 15 MN8443      MN8443     MN84        soum_centre Tset… Tsetseg Цэцэг   Tsetseg 
#> 16 MN8446      MN8446     MN84        soum_centre Chan… Chandm… Чандма… Chandma…
#> 17 MN8449      MN8449     MN84        soum_centre Erde… Erdene… Эрдэнэ… Erdeneb…
#> # ℹ 2 more variables: location_source <chr>, geometry <POINT [°]>
```
