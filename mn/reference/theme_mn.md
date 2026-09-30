# Газрын зургийн цэвэр загвар

Газрын зурагт зориулсан энгийн ggplot2 загвар: тэнхлэг, тор байхгүй,
тайлбар баруун талд, эх сурвалжийн жижиг саарал бичвэр.

## Usage

``` r
theme_mn(base_size = 11, base_family = "")
```

## Arguments

- base_size:

  Үндсэн бичгийн хэмжээ.

- base_family:

  Үндсэн фонт.

## Value

ggplot2 загвар.

## See also

Газрын зураг зурах бусад функц:
[`mn_aimag_grid`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimag_grid.md),
[`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md),
[`mn_label_points()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_label_points.md),
[`mn_leaflet()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_leaflet.md),
[`mn_map()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_map.md)

## Examples

``` r
library(ggplot2)
ggplot(mn_aimags()) + geom_sf() + theme_mn()
```
