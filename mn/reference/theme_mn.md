# A clean map theme

A minimal ggplot2 theme for maps: no axes or grid, legend at the right,
small grey caption.

## Usage

``` r
theme_mn(base_size = 11, base_family = "")
```

## Arguments

- base_size:

  Base font size.

- base_family:

  Base font family.

## Value

A ggplot2 theme.

## See also

Other mapping helpers:
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
