# Өөрийн өгөгдлийг Монголын газрын зурагтай холбох

Хүснэгтийг хил хязгаартай нэг алхамд холбоно. `by` баганад дурын
түгээмэл бичлэгийн нэр, кирил нэр, ҮСХ-ны код, ISO код эсвэл P-код байж
болно; тэдгээрийг
[`mn_match()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_match.md)-ээр
тааруулна. Тухайн түвшний бүх нэгж үлддэг тул өгөгдөлгүй газар ч газрын
зураг дээр (`NA`-тай) харагдана.

## Usage

``` r
mn_join(
  data,
  by,
  level = NULL,
  by_parent = NULL,
  within = NULL,
  drop_other_levels = TRUE,
  resolution = c("low", "high"),
  lang = NULL,
  crs = NULL
)
```

## Arguments

- data:

  Хүснэгт (data frame).

- by:

  `data` дахь газрын нэр эсвэл кодын багана, тэмдэгт мөр эсвэл хашилтгүй
  баганын нэрээр.

- level:

  `by` дахь газруудын түвшин. `NULL` бол автоматаар тодорхойлно.

- by_parent:

  Мөр бүрийн дээд нэгжийг (жишээ нь сум бүрийн аймгийг) заах `data` дахь
  нэмэлт багана. Сум эсвэл багийн нэр улс даяар давхардах үед хэрэгтэй.

- within:

  Зөвхөн эдгээр газар доторх нэгжүүд, эсвэл эдгээр газрыг өөрсдийг нь
  үлдээнэ: дурын түвшний нэр эсвэл код, жишээ нь `"Ховд"`, `"MN84"`,
  `"Баруун бүс"`.

- drop_other_levels:

  `TRUE` (анхдагч) бол бусад түвшний нэгжийн мөрийг, жишээ нь сумын
  хүснэгт дэх улсын болон аймгийн дүнг, нэг мэдэгдэлтэйгээр хасна.
  `FALSE` бол тэдгээрийг тохироогүй гэж мэдээлнэ.

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

`sf` tibble: тухайн түвшний бүх нэгжийн хил, `data`-гийн баганууд
нэмэгдсэн. Хилийн баганатай ижил нэртэй `data`-гийн баганад `.data`
дагавар залгана.

## Details

**Түвшин.** `level` нь `NULL` бол хамгийн олон тохирол бүхий түвшнийг
ашиглана. ҮСХ-ны хүснэгтүүд нэг баганад хэд хэдэн түвшнийг (улсын дүн,
бүс, аймаг, сум ...) агуулдаг; бусад түвшний мөрийг мэдэгдэлтэйгээр
хасна (`drop_other_levels`-ийг үзнэ үү). ҮСХ-ны хүснэгтийг нэрийн бус
кодын баганаар (жишээ нь `Region`) холбоно уу: "Улаанбаатар" гэх мэт нэр
нь бүс, аймгийн аль алиныг заадаг.

**Нэг нэгжид олон мөр.** Нэг газарт олон мөр (жишээ нь жил бүрт нэг)
байвал тухайн газрын олигоныг хэд хэдэн удаа давтаж,
[`ggplot2::facet_wrap()`](https://ggplot2.tidyverse.org/reference/facet_wrap.html)-д
бэлэн болгоно.

**Хилгүй газар.** Тосгон, хөдөөгийн баг ҮСХ-ны кодтой ч хилгүй;
тэдгээрийн мөрийг мэдэгдээд хасна.

## See also

Өгөгдөл холбох бусад:
[`mn_example_population`](https://temuulene.github.io/mongolmaps/mn/reference/mn_example_population.md)

## Examples

``` r
# Mid-year population from NSO, by aimag and year
pop <- mn_example_population[mn_example_population$Year == 2025, ]
mn_join(pop, by = "Region", level = "aimag")
#> ℹ Joining at the aimag level; dropped 6 rows for larger units ("country" and
#>   "region") and 2196 rows for smaller units ("soum" and "bag").
#> Simple feature collection with 22 features and 19 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 87.7345 ymin: 41.58183 xmax: 119.9315 ymax: 52.14835
#> Geodetic CRS:  WGS 84
#> # A tibble: 22 × 20
#>    pcode name      name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr> <chr>     <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
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
#> # ℹ 10 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>, Region <chr>, Region_en <chr>, Year <int>,
#> #   value <dbl>

# Khoroos of Ulaanbaatar, from the same table
mn_join(pop, by = "Region", level = "bag", within = "Ulaanbaatar")
#> ℹ Joining at the bag level; dropped 371 rows for larger units ("country",
#>   "region", "aimag", and "soum").
#> Simple feature collection with 204 features and 19 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 106.3626 ymin: 47.30196 xmax: 108.5008 ymax: 48.27193
#> Geodetic CRS:  WGS 84
#> # A tibble: 204 × 20
#>    pcode    name   name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr>    <chr>  <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN110151 1-р х… 1-r kh… 1-р хо… 1-r kho… bag   khor…      1 NA       5110151 
#>  2 MN110153 2-р х… 2-r kh… 2-р хо… 2-r kho… bag   khor…      2 NA       5110153 
#>  3 MN110155 3-р х… 3-r kh… 3-р хо… 3-r kho… bag   khor…      3 NA       5110155 
#>  4 MN110157 4-р х… 4-r kh… 4-р хо… 4-r kho… bag   khor…      4 NA       5110157 
#>  5 MN110159 5-р х… 5-r kh… 5-р хо… 5-r kho… bag   khor…      5 NA       5110159 
#>  6 MN110451 1-р х… 1-r kh… 1-р хо… 1-r kho… bag   khor…      1 NA       5110451 
#>  7 MN110453 2-р х… 2-r kh… 2-р хо… 2-r kho… bag   khor…      2 NA       5110453 
#>  8 MN110751 1-р х… 1-r kh… 1-р хо… 1-r kho… bag   khor…      1 NA       5110751 
#>  9 MN110752 26-р … 26-r k… 26-р х… 26-r kh… bag   khor…     26 NA       5110752 
#> 10 MN110753 2-р х… 2-r kh… 2-р хо… 2-r kho… bag   khor…      2 NA       5110753 
#> # ℹ 194 more rows
#> # ℹ 10 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>, Region <chr>, Region_en <chr>, Year <int>,
#> #   value <dbl>

# Names in any spelling work
df <- data.frame(aimag = c("Khovsgol", "Hovd", "\\u0423\\u0432\\u0441"), value = 1:3)
mn_join(df, aimag)
#> Warning: 1 value could not be matched and became "NA":
#> • \u0423\u0432\u0441
#> Simple feature collection with 22 features and 17 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 87.7345 ymin: 41.58183 xmax: 119.9315 ymax: 52.14835
#> Geodetic CRS:  WGS 84
#> # A tibble: 22 × 18
#>    pcode name      name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr> <chr>     <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
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
#> # ℹ 8 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>, aimag <chr>, value <int>
```
