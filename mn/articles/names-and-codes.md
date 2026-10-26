# Нэр ба код

Нэг газар хэд хэдэн бичлэгтэй байж болно. Khovsgol, Khuvsgul, Khövsgöl,
Хөвсгөл нь нэг аймгийг заана. mongolmaps эдгээр нэрийг нэг кодтой
холбодог. Өгөгдөл холбохдоо код, зурагт тэмдэглэхдээ нэр ашиглах нь
тохиромжтой.

``` r

library(mongolmaps)
options(mongolmaps.lang = "mn")
```

## Газрын кодыг олох

[`mn_match()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_match.md)
анхдагчаар P-код буцаана. `to`-гоор `name_mn`, `nso_code` зэрэг өөр
багана хүсэж болно.

``` r

mn_match(c("Khuvsgul", "Hovsgol", "Khövsgöl", "Хөвсгөл", "MN-041", "267"))
#> [1] "MN67" "MN67" "MN67" "MN67" "MN67" "MN67"
mn_match(c("MN84", "MN8401"), to = "name_mn")
#> [1] "Ховд"      "Жаргалант"
```

## Кодын систем сонгох

- `pcode`: багцын бүх түвшинд давтагдахгүй код.
- `nso_code`: ҮСХ-ны статистикийн хүснэгтийн код.
- `iso_code`: аймаг, нийслэлийн ISO 3166-2 код. Бүх түвшинд байхгүй.

Доорх хүснэгтийг багцын кодын жагсаалтаас үүсгэсэн. Кодыг текстээр
хадгалбал бичлэг нь өөрчлөгдөхгүй.

``` r

examples <- mn_codes()
examples <- examples[examples$pcode %in% c(
  "MN", "MNR1", "MN84", "MN8401", "MN11", "MN1107", "MN110751"
), ]
knitr::kable(examples[c("name_en", "pcode", "nso_code", "iso_code")])
```

| name_en        | pcode    | nso_code | iso_code |
|:---------------|:---------|:---------|:---------|
| Mongolia       | MN       | 0        | MN       |
| Western region | MNR1     | 1        | NA       |
| Ulaanbaatar    | MN11     | 511      | MN-1     |
| Khovd          | MN84     | 184      | MN-043   |
| Bayangol       | MN1107   | 51107    | NA       |
| Jargalant      | MN8401   | 18401    | NA       |
| 1-r khoroo     | MN110751 | 5110751  | NA       |

`mn_codes("aimag")` бүх аймаг, нийслэлийг жагсаана. Хороодын код болон
хил зааг байгаа эсэхийг ингэж харна:

``` r

knitr::kable(mn_codes("bag", within = "Baganuur")[
  c("name_en", "pcode", "nso_code", "has_geometry")
])
```

| name_en    | pcode    | nso_code | has_geometry |
|:-----------|:---------|:---------|:-------------|
| 1-r khoroo | MN110151 | 5110151  | TRUE         |
| 2-r khoroo | MN110153 | 5110153  | TRUE         |
| 3-r khoroo | MN110155 | 5110155  | TRUE         |
| 4-r khoroo | MN110157 | 5110157  | TRUE         |
| 5-r khoroo | MN110159 | 5110159  | TRUE         |

Хөдөөгийн баг, тосгодын нэр, код бий ч хил зааг багцаар ирэхгүй.
`has_geometry = FALSE` ийм нэгжийг заана. [Багийн хил заагийн файл
ашиглах](https://temuulene.github.io/mongolmaps/mn/articles/bags-from-nso.md)-ыг
үзнэ үү.

## Давхардсан нэрийг ялгах

Баян-Уул зэрэг нэр олон суманд бий. Харьяалах нэгжийг `within`-ээр өгнө.

``` r

mn_match("Bayan-Uul", level = "soum", within = "Dornod")
#> [1] "MN2110"
mn_match("Sukhbaatar district", within = "Ulaanbaatar")
#> [1] "MN1119"
```

Мэдээлэл дутвал
[`mn_match()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_match.md)
нь `NA` болон боломжит тохирлуудын анхааруулга өгнө. Сонгохоосоо өмнө
нэр дэвшигчдийг шалгана:

``` r

matches <- mn_match("Bayan-Uul", level = "soum", details = TRUE)
#> Warning: 1 value matches more than one unit and became "NA":
#> • Bayan-Uul: Bayan-Uul (MN2110, Dornod); Bayan-Uul (MN8207, Govi-Altai)
#> ℹ Use `within` (for example the aimag) to choose one.
matches[c("x", "pcode", "status")]
#> # A tibble: 1 × 3
#>   x         pcode status   
#>   <chr>     <chr> <chr>    
#> 1 Bayan-Uul NA    ambiguous
```

Энэ жишээний анхааруулга зориудынх. Олон аймгийн мөрийг холбохдоо
`by_parent` хэрэглэнэ. [Өгөгдөл холбох гарын
авлага](https://temuulene.github.io/mongolmaps/mn/articles/joining-data.md)-ыг
үзнэ үү.

## Бичлэгийн засварыг шалгах

Функц том, жижиг үсэг болон цэг тэмдгийн ялгааг үл тооцож, аймаг, дүүрэг
зэрэг үгийг түвшин танихад ашиглана. Ойролцоо бичлэг санал болгож болно.
Ашиглахаасаа өмнө шалгана.

``` r

mn_match("Ulanbaatr", details = TRUE)[c("x", "pcode", "status")]
#> # A tibble: 1 × 3
#>   x         pcode status
#>   <chr>     <chr> <chr> 
#> 1 Ulanbaatr MN11  fuzzy
```

`fuzzy = FALSE` нь ойролцоо бичлэгээр тохируулахгүй. Тодорхойгүй тохирол
дээр зогсоох холболтод `mn_join(..., strict = TRUE)` хэрэглэнэ.

## Кириллээс латин руу хөрвүүлэх

[`mn_translit()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_translit.md)
зөвхөн бичлэг хөрвүүлнэ; тухайн газар байгаа эсэхийг шалгахгүй.

``` r

x <- c("Өвөрхангай", "Сүхбаатар")
mn_translit(x)
#> [1] "Övörkhangai" "Sükhbaatar"
mn_translit(x, to = "nso")
#> [1] "Uvurkhangai" "Sukhbaatar"
```

Анхдагч нь MNS 5217:2012. `to = "nso"` нь ҮСХ-ны англи хүснэгтэд
хэрэглэдэг энгийн латин бичлэгийг өгнө.
