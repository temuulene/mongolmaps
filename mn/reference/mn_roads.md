# OpenStreetMap-аас авто зам, төмөр зам, нисэх буудал, суурин

Хүмүүнлэгийн OpenStreetMap багийн (HOT) экспортоос бэлтгэсэн тээвэр,
суурин газрын OpenStreetMap давхаргууд. Давхарга бүрийг нэг удаа татаж
(авто зам ойролцоогоор 30 МБ, бусад нь бага) хадгална;
[`mn_download()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_cache_dir.md)-ийг
үзнэ үү.

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

  Үлдээх замын ангилал: `"main"` (хурдны замаас гуравдугаар зэрэглэлийн
  зам хүртэл, анхдагч), `"minor"` (орон сууцны, үйлчилгээний, ангилалгүй
  гудамж), `"track"`, `"path"` эсвэл `"all"`.

- within:

  Зөвхөн эдгээр газар доторх объектыг үлдээнэ (хилтэй дурын түвшний нэр
  эсвэл код, жишээ нь `"Улаанбаатар"`, `"Ховд"`).

- crs:

  Үр дүнгийн координатын систем. `NULL` (анхдагч) бол уртраг, өргөрөг
  (EPSG:4326) хэвээр. Монголд тохирсон проекцод `"albers"`, `"lcc"`
  эсвэл `"utm"`-ийг
  ([`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md)-ийг
  үзнэ үү), эсвэл
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html)-ийн
  хүлээн авах дурын утгыг өгнө.

- stations:

  `TRUE` бол `mn_railways()` шугамын оронд төмөр замын өртөөг цэгээр
  буцаана.

- type:

  `mn_places()`-ийн суурины төрөл: `"city"`, `"town"`, `"village"`,
  `"hamlet"`, `"suburb"`, `"isolated_dwelling"`-ийн аль нь ч.

- lang:

  `name` баганын хэл: `"en"` (англи, ҮСХ-ны хүснэгтийн бичлэгээр),
  `"mn"` (кирил) эсвэл `"mns"` (MNS 5217 стандартын латин, тэмдэгттэй).
  Анхдагч утга нь `getOption("mongolmaps.lang", "en")`.

## Value

`osm_id`, `name` (OpenStreetMap-д байгаа бол сонгосон хэлээр),
`name_en`, `name_mn` болон давхарга бүрийн баганатай `sf` tibble: авто
замд `highway`, `class`, `surface`; төмөр замд `railway`; суурин газарт
`place`, `population`.

## Details

Нэг газрын давхарга авахын тулд `within`-ийг ашиглана: зөвхөн тухайн
газрын хүрээ доторх объектыг дискнээс уншаад, шугамыг хил дээр нь
тасална.

## Лиценз

OpenStreetMap-ийн өгөгдөл Open Database License (ODbL) лицензтэй. Газрын
зураг нийтлэхдээ "(c) OpenStreetMap contributors" гэж дурдана уу;
`mn_citation("osm_roads")` бичвэрийг нь өгнө.

## See also

Сэдэвчилсэн бусад давхарга:
[`mn_neighbours()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_neighbours.md),
[`mn_protected_areas()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_protected_areas.md),
[`mn_settlements()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_settlements.md)

## Examples

``` r
ub_roads <- mn_roads(class = c("main", "minor"), within = "Ulaanbaatar")
mn_railways()
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
#> Simple feature collection with 22 features and 6 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 91.37414 ymin: 45.80627 xmax: 93.61881 ymax: 48.50362
#> Geodetic CRS:  WGS 84
#> # A tibble: 22 × 7
#>    osm_id       name  name_en name_mn place population            geometry
#>    <chr>        <chr> <chr>   <chr>   <chr>      <int>         <POINT [°]>
#>  1 node/199804… Чанд… Chandm… Чандма… town          NA (92.81577 47.66628)
#>  2 node/308452… Ховд  Khovd   Ховд    city       28601 (91.64524 48.00064)
#>  3 node/386056… Ховд… Khovd … Ховд с… town          NA (91.37414 48.12881)
#>  4 node/377479… Буянт Buyant  Буянт   town          NA  (91.7626 48.17352)
#>  5 node/226202… Мянг… Myangad Мянгад  town          NA (91.92434 48.23306)
#>  6 way/1891502… Дөрг… Durgun  Дөргөн  town          NA (92.63081 48.33447)
#>  7 node/199803… Дөрг… Dörgön  Дөргөн  town          NA (92.63167 48.33631)
#>  8 node/199804… Эрдэ… Erdene… Эрдэнэ… town          NA (91.44844 48.50362)
#>  9 node/235178… Бор-… Bor-Üz… Бор-Үз… vill…         NA (92.28821 45.80627)
#> 10 node/238101… Алтай Altai   Алтай   town          NA (92.52295 46.01333)
#> # ℹ 12 more rows
```
