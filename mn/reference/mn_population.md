# Хүн амын тор

WorldPop-ын нүд бүрийн хүн амын тооцоо (2015-2030 он, суурьшлын бүсээр
хязгаарласан), 1 км эсвэл 100 м нарийвчлалтай. Тухайн оны улсын файлыг
WorldPop-оос нэг удаа (1 км-т 0.4 МБ, 100 м-т 11 МБ) татаж хадгална.
Аймаг, сум, хороогоор нэгтгэхэд
[`mn_zonal()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_zonal.md)-ийг
ашиглана.

## Usage

``` r
mn_population(
  year = 2025,
  resolution = c("1km", "100m"),
  within = NULL,
  mask = TRUE,
  crs = NULL
)
```

## Arguments

- year:

  2015-2030 оны хооронд он (сүүлийн тооллогоос хойших он нь төсөөлөл).

- resolution:

  `"1km"` эсвэл `"100m"`.

- within:

  Буцаах газар (нэр эсвэл код). Онлайнаар уншдаг нарийвчлалд заавал
  өгнө: өндөршилд `"90m"`, газрын бүрхэвчид `"10m"`.

- mask:

  `TRUE` (анхдагч) бол Монголоос (эсвэл `within`-ээс) гадуурх нүдийг
  `NA` болгоно.

- crs:

  Үр дүнгийн координатын систем. `NULL` (анхдагч) бол уртраг, өргөрөг
  (EPSG:4326) хэвээр. Монголд тохирсон проекцод `"albers"`, `"lcc"`
  эсвэл `"utm"`-ийг
  ([`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md)-ийг
  үзнэ үү), эсвэл
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html)-ийн
  хүлээн авах дурын утгыг өгнө.

## Value

Нүд бүрийн хүний тоо бүхий `terra` SpatRaster.

## Эх сурвалж

WorldPop (www.worldpop.org), Global 2015-2030 constrained population
counts, release R2025A. CC BY 4.0.

## See also

Растерийн бусад давхарга:
[`mn_elevation()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_elevation.md),
[`mn_landcover()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_landcover.md),
[`mn_zonal()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_zonal.md)

## Examples

``` r
pop <- mn_population(2025)
terra::plot(log10(pop))

mn_zonal(pop, mn_aimags())
#> Simple feature collection with 22 features and 16 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 87.7345 ymin: 41.58183 xmax: 119.9315 ymax: 52.14835
#> Geodetic CRS:  WGS 84
#> # A tibble: 22 × 17
#>    pcode name      name_en name_mn name_mns level type  number iso_code nso_code
#>  * <chr> <chr>     <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN11  Улаанбаа… Ulaanb… Улаанб… Ulaanba… aimag capi…     NA MN-1     511     
#>  2 MN21  Дорнод    Dornod  Дорнод  Dornod   aimag aimag     NA MN-061   421     
#>  3 MN22  Сүхбаатар Sukhba… Сүхбаа… Sükhbaa… aimag aimag     NA MN-051   422     
#>  4 MN23  Хэнтий    Khentii Хэнтий  Khentii  aimag aimag     NA MN-039   423     
#>  5 MN41  Төв       Tuv     Төв     Töv      aimag aimag     NA MN-047   341     
#>  6 MN42  Говьсүмб… Govisu… Говьсү… Govisüm… aimag aimag     NA MN-064   342     
#>  7 MN43  Сэлэнгэ   Selenge Сэлэнгэ Selenge  aimag aimag     NA MN-049   343     
#>  8 MN44  Дорноговь Dornog… Дорног… Dornogo… aimag aimag     NA MN-063   344     
#>  9 MN45  Дархан-У… Darkha… Дархан… Darkhan… aimag aimag     NA MN-037   345     
#> 10 MN46  Өмнөговь  Umnugo… Өмнөго… Ömnögovi aimag aimag     NA MN-053   346     
#> # ℹ 12 more rows
#> # ℹ 7 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>, value <dbl>
```
