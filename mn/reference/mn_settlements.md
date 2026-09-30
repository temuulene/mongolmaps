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
  [`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md)),
  or any value accepted by
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html).

## Value

An `sf` tibble of points with columns `admin_pcode` (the aimag or soum
the settlement is the centre of), `soum_pcode`, `aimag_pcode`, `type`,
`name`, `name_en`, `name_mn`, `name_mns` and `location_source`.

## See also

Other thematic layers:
[`mn_neighbours()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_neighbours.md),
[`mn_protected_areas()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_protected_areas.md),
[`mn_roads()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_roads.md)

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
#>  1 MN11        NA         MN11        capital     Улаа… Ulaanb… Улаанб… Ulaanba…
#>  2 MN21        MN2101     MN21        aimag_cent… Чойб… Choiba… Чойбал… Choibal…
#>  3 MN22        MN2201     MN22        aimag_cent… Бару… Baruun… Баруун… Baruun-…
#>  4 MN23        MN2301     MN23        aimag_cent… Чинг… Chingis Чингис  Chingis 
#>  5 MN41        MN4101     MN41        aimag_cent… Зуун… Zuunmod Зуунмод Zuunmod 
#>  6 MN42        MN4201     MN42        aimag_cent… Чойр  Choir   Чойр    Choir   
#>  7 MN43        MN4301     MN43        aimag_cent… Сүхб… Sukhba… Сүхбаа… Sükhbaa…
#>  8 MN44        MN4401     MN44        aimag_cent… Сайн… Sainsh… Сайнша… Sainsha…
#>  9 MN45        MN4501     MN45        aimag_cent… Дарх… Darkhan Дархан  Darkhan 
#> 10 MN46        MN4601     MN46        aimag_cent… Дала… Dalanz… Даланз… Dalanza…
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
#>  1 MN84        MN8401     MN84        aimag_cent… Ховд  Khovd   Ховд    Khovd   
#>  2 MN8404      MN8404     MN84        soum_centre Алтай Altai   Алтай   Altai   
#>  3 MN8407      MN8407     MN84        soum_centre Булг… Bulgan  Булган  Bulgan  
#>  4 MN8410      MN8410     MN84        soum_centre Буянт Buyant  Буянт   Buyant  
#>  5 MN8413      MN8413     MN84        soum_centre Дарви Darvi   Дарви   Darvi   
#>  6 MN8416      MN8416     MN84        soum_centre Дөрг… Durgun  Дөргөн  Dörgön  
#>  7 MN8419      MN8419     MN84        soum_centre Дуут  Duut    Дуут    Duut    
#>  8 MN8422      MN8422     MN84        soum_centre Зэрэг Zereg   Зэрэг   Zereg   
#>  9 MN8425      MN8425     MN84        soum_centre Манх… Mankhan Манхан  Mankhan 
#> 10 MN8428      MN8428     MN84        soum_centre Мөнх… Munkhk… Мөнхха… Mönkhkh…
#> 11 MN8431      MN8431     MN84        soum_centre Мөст  Must    Мөст    Möst    
#> 12 MN8434      MN8434     MN84        soum_centre Мянг… Myangad Мянгад  Myangad 
#> 13 MN8437      MN8437     MN84        soum_centre Үенч  Uyench  Үенч    Üyench  
#> 14 MN8440      MN8440     MN84        soum_centre Ховд  Khovd   Ховд    Khovd   
#> 15 MN8443      MN8443     MN84        soum_centre Цэцэг Tsetseg Цэцэг   Tsetseg 
#> 16 MN8446      MN8446     MN84        soum_centre Чанд… Chandm… Чандма… Chandma…
#> 17 MN8449      MN8449     MN84        soum_centre Эрдэ… Erdene… Эрдэнэ… Erdeneb…
#> # ℹ 2 more variables: location_source <chr>, geometry <POINT [°]>
```
