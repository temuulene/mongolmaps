# Монгол Улс ба эдийн засгийн бүсүүд

`mn_country()` Монгол Улсын хилийг буцаана. `mn_regions()` ҮСХ-ны
статистикт хэрэглэдэг эдийн засгийн таван бүсийг буцаана: Баруун,
Хангай, Төв, Зүүн бүс ба Улаанбаатар.

## Usage

``` r
mn_country(resolution = c("low", "high"), lang = NULL, crs = NULL)

mn_regions(resolution = c("low", "high"), lang = NULL, crs = NULL)
```

## Arguments

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

## Value

`sf` tibble; баганыг
[`mn_admin()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_admin.md)-аас
үзнэ үү.

## See also

Хил хязгаарын бусад функц:
[`mn_admin()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_admin.md),
[`mn_aimags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimags.md),
[`mn_bags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_bags.md),
[`mn_soums()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_soums.md),
[`mn_ub()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub.md)

## Examples

``` r
mn_country()
#> Simple feature collection with 1 feature and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 87.7345 ymin: 41.58183 xmax: 119.9315 ymax: 52.14835
#> Geodetic CRS:  WGS 84
#> # A tibble: 1 × 16
#>   pcode name       name_en name_mn name_mns level type  number iso_code nso_code
#>   <chr> <chr>      <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#> 1 MN    Монгол Улс Mongol… Монгол… Mongol … coun… coun…     NA MN       0       
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
#> 1 MNR1  Баруун бүс Wester… Баруун… Baruun … regi… regi…     NA NA       1       
#> 2 MNR2  Хангайн б… Khanga… Хангай… Khangai… regi… regi…     NA NA       2       
#> 3 MNR3  Төвийн бүс Centra… Төвийн… Töviin … regi… regi…     NA NA       3       
#> 4 MNR4  Зүүн бүс   Easter… Зүүн б… Züün büs regi… regi…     NA NA       4       
#> 5 MNR5  Улаанбаат… Ulaanb… Улаанб… Ulaanba… regi… regi…     NA NA       5       
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
```
