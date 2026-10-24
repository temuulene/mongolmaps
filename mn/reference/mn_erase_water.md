# Дүрслэх геометрээс усны талбайг хасах

Усыг хассан шинэ олон өнцөгтийн давхарга буцаана. Оролтын объект болон
`area_km2` өөрчлөгдөхгүй; `land_area_km2` нь шинэ геометрийн талбай.
Хуурай газар нь хүн амьдардаг газартай адил биш.

## Usage

``` r
mn_erase_water(x, water = NULL, min_area_km2 = 0)
```

## Arguments

- x:

  `sf` олон өнцөгтийн объект.

- water:

  Усны олон өнцөгтийн давхарга; анхдагч
  [`mn_lakes()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_neighbours.md).

- min_area_km2:

  Үүнээс жижиг усны талбайг тооцохгүй.

## Value

Оролтын нэгж бүрд нэг мөртэй `sf` объект. Бүхэлдээ усанд хамрагдсан нэгж
хоосон геометртэй үлдэнэ. `land_area_km2` нэмэгдэнэ.

## See also

Газрын зураг зурах бусад функц:
[`mn_aimag_grid`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimag_grid.md),
[`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md),
[`mn_inset_ub()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_inset_ub.md),
[`mn_label_points()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_label_points.md),
[`mn_leaflet()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_leaflet.md),
[`mn_map()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_map.md),
[`mn_ub_grid`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub_grid.md),
[`theme_mn()`](https://temuulene.github.io/mongolmaps/mn/reference/theme_mn.md)

## Examples

``` r
land <- mn_erase_water(mn_aimags())
head(land$land_area_km2)
#> [1]   4736.117 122836.781  82321.392  80742.444  73986.515   5539.957
```
