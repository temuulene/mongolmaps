# Баг: хөдөөгийн хамгийн жижиг нэгж

Баг бол сумын хуваарь; нийт 1,650 орчим баг бий. Тэдгээрийн код, нэр
багцад бий (`mn_codes("bag")`-ийг үзнэ үү), гэхдээ **хил нь нээлттэй
нийтлэгдээгүй**: Үндэсний статистикийн хороо (ҮСХ) хүсэлтээр өгдөг.
Багийн хилийн файлтай болсон бол `mn_bags()` болон багцын бусад бүх
функц үүнийг ашиглаж чадна.

## Usage

``` r
mn_bags(
  aimag = NULL,
  soum = NULL,
  path = getOption("mongolmaps.bags_path"),
  resolution = c("low", "high"),
  lang = NULL,
  crs = NULL
)

mn_read_bags(path, code_col = NULL, check_nesting = TRUE)
```

## Arguments

- aimag, soum:

  Зөвхөн эдгээр аймаг, сумын багуудыг үлдээнэ (нэр эсвэл код).

- path:

  [`sf::st_read()`](https://r-spatial.github.io/sf/reference/st_read.html)-ээр
  уншигдах багийн хилийн файлын зам. Анхдагч нь
  `getOption("mongolmaps.bags_path")`.

- resolution:

  `"low"` (анхдагч) нь багцтай хамт ирдэг, ихэнх газрын зурагт тохирох
  хялбаршуулсан хилийг ашиглана. `"high"` нь бүрэн нарийвчлалтай хилийг
  нэг удаа (ойролцоогоор 10 МБ) татаж, хадгална;
  [`mn_cache_dir()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_cache_dir.md)-ийг
  үзнэ үү.

- lang:

  `name` баганын хэл: `"en"` (англи, ҮСХ-ны хүснэгтийн бичлэгээр),
  `"mn"` (кирил) эсвэл `"mns"` (MNS 5217 стандартын латин, тэмдэгттэй).
  Анхдагч утга нь `getOption("mongolmaps.lang", "en")`.

- crs:

  Үр дүнгийн координатын систем. `NULL` (анхдагч) бол уртраг, өргөрөг
  (EPSG:4326) хэвээр. Монголд тохирсон проекцод `"albers"`, `"lcc"`
  эсвэл `"utm"`-ийг
  ([`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md)-ийг
  үзнэ үү), эсвэл
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html)-ийн
  хүлээн авах дурын утгыг өгнө.

- code_col:

  Багийн кодын баганын нэр: ҮСХ-ны 7 оронтой код (`"1830151"`) эсвэл
  P-код (`"MN830151"`). `NULL` бол автоматаар олно.

- check_nesting:

  `TRUE` (анхдагч) бол баг сумаасаа гадуур байвал зогсоно.

## Value

`sf` tibble; баганыг
[`mn_admin()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_admin.md)-аас
үзнэ үү.

## Багийн хил авах

ҮСХ-нд (<international@nso.mn>) хандаж, багийн хилийг баг бүрийн ҮСХ-ны
кодтой shapefile эсвэл GeoPackage хэлбэрээр хүснэ үү. Дараа нь файлыг
`mn_bags(path = ...)`-д өгөх, эсвэл нэг удаа
`options(mongolmaps.bags_path = "path/to/bags.gpkg")`-ээр бүртгэнэ
(байнга ашиглах бол энэ мөрийг `.Rprofile`-даа нэмнэ). Бүртгэсэн багийг
`mn_admin("bag")` мөн буцааж,
[`mn_join()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_join.md)
ашиглана.

`mn_read_bags()` файлыг шалгана: баг бүр мэдэгдэж буй кодтой, өөрийн сум
дотор байх ёстой.

## See also

Хил хязгаарын бусад функц:
[`mn_admin()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_admin.md),
[`mn_aimags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimags.md),
[`mn_country()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_country.md),
[`mn_soums()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_soums.md),
[`mn_ub()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub.md)

## Examples

``` r
# Codes and names of all bags, without boundaries:
mn_codes("bag", within = "Khovd")
#> # A tibble: 91 × 16
#>    pcode    name   name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr>    <chr>  <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN840151 1-р б… 1-r ba… 1-р ба… 1-r bag… bag   bag        1 NA       1840151 
#>  2 MN840153 2-р б… 2-r ba… 2-р ба… 2-r bag… bag   bag        2 NA       1840153 
#>  3 MN840155 3-р б… 3-r ba… 3-р ба… 3-r bag… bag   bag        3 NA       1840155 
#>  4 MN840157 4-р б… 4-r ba… 4-р ба… 4-r bag… bag   bag        4 NA       1840157 
#>  5 MN840159 5-р б… 5-r ba… 5-р ба… 5-r bag… bag   bag        5 NA       1840159 
#>  6 MN840161 6-р б… 6-r ba… 6-р ба… 6-r bag… bag   bag        6 NA       1840161 
#>  7 MN840163 7-р б… 7-r ba… 7-р ба… 7-r bag… bag   bag        7 NA       1840163 
#>  8 MN840165 8-р б… 8-r ba… 8-р ба… 8-r bag… bag   bag        8 NA       1840165 
#>  9 MN840167 9-р б… 9-r ba… 9-р ба… 9-r bag… bag   bag        9 NA       1840167 
#> 10 MN840169 10-р … 10-r b… 10-р б… 10-r ba… bag   bag       10 NA       1840169 
#> # ℹ 81 more rows
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>, has_geometry <lgl>

# Without a bag boundary file, mn_bags() explains how to get one:
try(mn_bags())
#> Error in mn_bags() : 
#>   Bag boundaries are not openly published, so they are not included.
#> ℹ Ask NSO for them (international@nso.mn), then use `mn_bags(path =
#>   "bags.gpkg")`.
#> ℹ Bag codes and names are available now: `mn_codes("bag")`.
#> ℹ Khoroos of Ulaanbaatar are available now: `mn_khoroos()`.

# With the file from NSO (not run, as the file is not public):
if (FALSE) { # \dontrun{
mn_bags(aimag = "Khovd", path = "bags_from_nso.gpkg")
} # }
```
