# Нэр ба код

``` r

library(mongolmaps)
options(mongolmaps.lang = "mn")
```

Монгол газар нутгийн нэрийг олон янзаар бичдэг: Khovsgol, Khuvsgul,
Hovsgol, Khövsgöl, Хөвсгөл бүгд нэг аймаг. mongolmaps нэгж бүрт нэг код
өгч, бусад бичлэгийг нь таньдаг.

## Код

`pcode` бүх түвшинд давтагдашгүй:

| Нэгж                 | pcode      | ҮСХ-ны код | ISO 3166-2 |
|----------------------|------------|------------|------------|
| Монгол Улс           | `MN`       | `0`        | `MN`       |
| Баруун бүс           | `MNR1`     | `1`        |            |
| Ховд аймаг           | `MN84`     | `184`      | `MN-043`   |
| Жаргалант сум (Ховд) | `MN8401`   | `18401`    |            |
| Улаанбаатар          | `MN11`     | `511`      | `MN-1`     |
| Баянгол дүүрэг       | `MN1107`   | `51107`    |            |
| Баянгол, 1-р хороо   | `MN110751` | `5110751`  |            |

pcode нь хүмүүнлэгийн тусламжийн Common Operational Dataset (COD)-ийн
кодтой ижил бөгөөд ҮСХ-ны кодоос эхний бүсийн цифрийг хассантай тэнцүү.
[`mn_codes()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_codes.md)
бүгдийг жагсаана:

``` r

mn_codes("aimag")
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
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>, has_geometry <lgl>
mn_codes("bag", within = "Багануур")
#> # A tibble: 5 × 16
#>   pcode    name    name_en name_mn name_mns level type  number iso_code nso_code
#>   <chr>    <chr>   <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#> 1 MN110151 1-р хо… 1-r kh… 1-р хо… 1-r kho… bag   khor…      1 NA       5110151 
#> 2 MN110153 2-р хо… 2-r kh… 2-р хо… 2-r kho… bag   khor…      2 NA       5110153 
#> 3 MN110155 3-р хо… 3-r kh… 3-р хо… 3-r kho… bag   khor…      3 NA       5110155 
#> 4 MN110157 4-р хо… 4-r kh… 4-р хо… 4-r kho… bag   khor…      4 NA       5110157 
#> 5 MN110159 5-р хо… 5-r kh… 5-р хо… 5-r kho… bag   khor…      5 NA       5110159 
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>, has_geometry <lgl>
```

Баг, тосгон код, нэртэй ч нээлттэй хилгүй (`has_geometry` нь `FALSE`).

## Нэр тааруулах

[`mn_match()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_match.md)
нэр эсвэл кодыг pcode (эсвэл өөр багана) болгоно:

``` r

mn_match(c("Khuvsgul", "Hovsgol", "Khövsgöl", "Хөвсгөл", "MN-041", "267"))
#> [1] "MN67" "MN67" "MN67" "MN67" "MN67" "MN67"
mn_match(c("MN84", "MN8401"), to = "name_en")
#> [1] "Khovd"     "Jargalant"
```

Том жижиг үсэг, цэг таслал, “аймаг”, “сум”, “дүүрэг” гэх мэт үгийг
тоохгүй — харин нэр давхардсан үед эдгээр үгийг сэжүүр болгон ашиглана:

``` r

mn_match(c("Сүхбаатар", "Сүхбаатар дүүрэг", "Сүхбаатар сум"), within = c(NA, NA, "Сэлэнгэ"))
#> [1] "MN22"   "MN1119" "MN4301"
```

Жижиг үсгийн алдааг тааруулж, мэдэгдэнэ:

``` r

mn_match("Ulanbaatr")
#> ℹ Matched 1 value approximately; please check:
#> • Ulanbaatr → Ulaanbaatar (MN11)
#> [1] "MN11"
```

Хэд хэдэн нэгж ижил нэртэй бол
[`mn_match()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_match.md)
`NA` буцааж, аль нь болохыг хэлнэ; `within`-ээр сонгоно:

``` r

mn_match("Баян-Уул", level = "soum")
#> Warning: 1 value matches more than one unit and became "NA":
#> • Баян-Уул: Bayan-Uul (MN2110, Dornod); Bayan-Uul (MN8207, Govi-Altai)
#> ℹ Use `within` (for example the aimag) to choose one.
#> [1] NA
mn_match("Баян-Уул", level = "soum", within = "Дорнод")
#> [1] "MN2110"
```

## Галиглах

[`mn_translit()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_translit.md)
кирилийг тогтмол хүснэгтээр латин үсэгт буулгана:

``` r

x <- c("Өвөрхангай", "Сүхбаатар")
mn_translit(x)
#> [1] "Övörkhangai" "Sükhbaatar"
mn_translit(x, to = "nso")
#> [1] "Uvurkhangai" "Sukhbaatar"
```

Анхдагч нь үндэсний стандарт MNS 5217:2012; `to = "nso"` нь ҮСХ-ны англи
хүснэгтэд хэрэглэдэг зөвхөн ASCII бичлэгийг өгнө.
