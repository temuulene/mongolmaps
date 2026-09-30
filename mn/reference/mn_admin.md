# Монгол Улсын засаг захиргааны хил, дурын түвшинд

[`mn_country()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_country.md),
[`mn_regions()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_country.md),
[`mn_aimags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimags.md),
[`mn_soums()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_soums.md),
[`mn_khoroos()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub.md),
[`mn_bags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_bags.md)
функцүүдийн цаад хөдөлгүүр. Бүх функц ижил баганатай үр дүн буцаадаг тул
өөр өөр түвшний газрын зургийг нэгтгэж, өгөгдөлтэй адилхан холбож болно.

## Usage

``` r
mn_admin(
  level = "aimag",
  within = NULL,
  resolution = c("low", "high"),
  lang = NULL,
  crs = NULL
)
```

## Arguments

- level:

  Буцаах түвшин:

  - `"country"`: Монгол Улс.

  - `"region"`: ҮСХ-ны ашигладаг эдийн засгийн таван бүс (Баруун,
    Хангай, Төв, Зүүн, Улаанбаатар).

  - `"aimag"`: 21 аймаг ба нийслэл Улаанбаатар.

  - `"soum"`: 330 сум ба Улаанбаатарын 9 дүүрэг.

  - `"bag"`: Улаанбаатарын 204 хороо, мөн багийн хилийн файл бүртгэсэн
    бол хөдөөгийн багууд
    ([`mn_bags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_bags.md)-ийг
    үзнэ үү).

  `"province"`, `"district"`, `"adm1"`, `"khoroo"` зэрэг ижил утгатай
  нэрийг ч хүлээн авна.

- within:

  Зөвхөн эдгээр газар доторх нэгжүүд, эсвэл эдгээр газрыг өөрсдийг нь
  үлдээнэ: дурын түвшний нэр эсвэл код, жишээ нь `"Ховд"`, `"MN84"`,
  `"Баруун бүс"`.

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

Нэгж бүрт нэг мөртэй, дараах баганатай `sf` tibble:

- pcode:

  Давтагдашгүй код
  ([`mn_codes()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_codes.md)-ийг
  үзнэ үү).

- name:

  `lang`-аар сонгосон хэл дээрх нэр.

- name_en, name_mn, name_mns:

  Англи, кирил, MNS латин нэр.

- level, type:

  Түвшин (`"aimag"`, `"soum"`, ...) ба төрөл (`"capital"`, `"district"`,
  `"khoroo"`, ...).

- number:

  Сум эсвэл дүүрэг доторх баг, хорооны дугаар.

- iso_code:

  ISO 3166-2 код (зөвхөн аймагт).

- nso_code:

  ҮСХ-ны статистикийн хүснэгтэд хэрэглэдэг код.

- parent_pcode, region_pcode, aimag_pcode, soum_pcode:

  Энэ нэгжийг агуулах дээд нэгжүүдийн код.

- area_km2:

  Бүрэн нарийвчлалтай хилээр тооцсон талбай, км².

- geometry:

  Олон олигон хил.

## See also

Хил хязгаарын бусад функц:
[`mn_aimags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimags.md),
[`mn_bags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_bags.md),
[`mn_country()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_country.md),
[`mn_soums()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_soums.md),
[`mn_ub()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub.md)

## Examples

``` r
mn_admin("aimag")
#> Simple feature collection with 22 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 87.7345 ymin: 41.58183 xmax: 119.9315 ymax: 52.14835
#> Geodetic CRS:  WGS 84
#> # A tibble: 22 × 16
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
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
mn_admin("soum", within = "Khovd")
#> Simple feature collection with 17 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 90.65037 ymin: 44.99983 xmax: 94.30692 ymax: 48.96636
#> Geodetic CRS:  WGS 84
#> # A tibble: 17 × 16
#>    pcode  name     name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr>  <chr>    <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN8401 Жаргала… Jargal… Жаргал… Jargala… soum  soum      NA NA       18401   
#>  2 MN8404 Алтай    Altai   Алтай   Altai    soum  soum      NA NA       18404   
#>  3 MN8407 Булган   Bulgan  Булган  Bulgan   soum  soum      NA NA       18407   
#>  4 MN8410 Буянт    Buyant  Буянт   Buyant   soum  soum      NA NA       18410   
#>  5 MN8413 Дарви    Darvi   Дарви   Darvi    soum  soum      NA NA       18413   
#>  6 MN8416 Дөргөн   Durgun  Дөргөн  Dörgön   soum  soum      NA NA       18416   
#>  7 MN8419 Дуут     Duut    Дуут    Duut     soum  soum      NA NA       18419   
#>  8 MN8422 Зэрэг    Zereg   Зэрэг   Zereg    soum  soum      NA NA       18422   
#>  9 MN8425 Манхан   Mankhan Манхан  Mankhan  soum  soum      NA NA       18425   
#> 10 MN8428 Мөнххай… Munkhk… Мөнхха… Mönkhkh… soum  soum      NA NA       18428   
#> 11 MN8431 Мөст     Must    Мөст    Möst     soum  soum      NA NA       18431   
#> 12 MN8434 Мянгад   Myangad Мянгад  Myangad  soum  soum      NA NA       18434   
#> 13 MN8437 Үенч     Uyench  Үенч    Üyench   soum  soum      NA NA       18437   
#> 14 MN8440 Ховд     Khovd   Ховд    Khovd    soum  soum      NA NA       18440   
#> 15 MN8443 Цэцэг    Tsetseg Цэцэг   Tsetseg  soum  soum      NA NA       18443   
#> 16 MN8446 Чандмань Chandm… Чандма… Chandma… soum  soum      NA NA       18446   
#> 17 MN8449 Эрдэнэб… Erdene… Эрдэнэ… Erdeneb… soum  soum      NA NA       18449   
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
mn_admin("aimag", within = c("Khovd", "Uvs"), lang = "mn")
#> Simple feature collection with 2 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 89.99998 ymin: 44.99983 xmax: 95.68892 ymax: 50.88443
#> Geodetic CRS:  WGS 84
#> # A tibble: 2 × 16
#>   pcode name  name_en name_mn name_mns level type  number iso_code nso_code
#>   <chr> <chr> <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#> 1 MN84  Ховд  Khovd   Ховд    Khovd    aimag aimag     NA MN-043   184     
#> 2 MN85  Увс   Uvs     Увс     Uvs      aimag aimag     NA MN-046   185     
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
```
