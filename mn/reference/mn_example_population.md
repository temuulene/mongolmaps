# Монгол Улсын жилийн дундаж хүн ам (жишээ өгөгдөл)

2015, 2020, 2025 оны засаг захиргааны нэгжээрх хүн ам, Үндэсний
статистикийн хорооны (ҮСХ) DT_NSO_0300_002V4 хүснэгтээс mongolstats
багцаар татсан хэлбэрээрээ. ҮСХ-ны хүснэгтүүдийн нэгэн адил `Region`
багана олон түвшнийг (улсын дүн, бүс, аймаг, сум, баг, хороо) агуулдаг
тул
[`mn_join()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_join.md)-ийн
сайн жишээ болно.

## Usage

``` r
mn_example_population
```

## Format

6,672 мөр, 4 баганатай хүснэгт:

- Region:

  ҮСХ-ны нэгжийн код, жишээ нь `"0"` (Монгол Улс), `"183"` (Баян-Өлгий),
  `"18301"` (Өлгий сум), `"5110751"` (Баянгол дүүргийн 1-р хороо).

- Region_en:

  Нэгжийн англи нэр.

- Year:

  Он.

- value:

  Жилийн дундаж хүн ам.

## Source

Үндэсний статистикийн хороо, <https://data.1212.mn/pxweb/>,
2026-09-29-нд татсан.

## See also

Өгөгдөл холбох бусад:
[`mn_join()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_join.md)

## Examples

``` r
head(mn_example_population)
#> # A tibble: 6 × 4
#>   Region  Region_en           Year   value
#>   <chr>   <chr>              <int>   <dbl>
#> 1 0       Total               2015 2964085
#> 2 1       Western region      2015  381840
#> 3 181     Zavkhan             2015   69637
#> 4 18101   Uliastai            2015   15871
#> 5 1810151 1-r bag, Jinst      2015    3333
#> 6 1810153 2-r bag, Jargalant  2015    2978
```
