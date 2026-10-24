# Remove water from display geometry

Return a new polygon layer with water removed. The input object and its
`area_km2` field are unchanged; `land_area_km2` describes the new
geometry. Land area is not inhabited area. Water source/resolution
affects this cartographic operation and any land-only density
interpretation.

## Usage

``` r
mn_erase_water(x, water = NULL, min_area_km2 = 0)
```

## Arguments

- x:

  An sf polygon object.

- water:

  An sf polygon water layer, defaulting to
  [`mn_lakes()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_neighbours.md).

- min_area_km2:

  Ignore water polygons smaller than this area.

## Value

An sf object with `land_area_km2`, preserving one row per input unit,
including empty geometry for entirely water-covered units.

## See also

Other mapping helpers:
[`mn_aimag_grid`](https://temuulene.github.io/mongolmaps/dev/reference/mn_aimag_grid.md),
[`mn_crs()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_crs.md),
[`mn_inset_ub()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_inset_ub.md),
[`mn_label_points()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_label_points.md),
[`mn_leaflet()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_leaflet.md),
[`mn_map()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_map.md),
[`mn_ub_grid`](https://temuulene.github.io/mongolmaps/dev/reference/mn_ub_grid.md),
[`theme_mn()`](https://temuulene.github.io/mongolmaps/dev/reference/theme_mn.md)

## Examples

``` r
land <- mn_erase_water(mn_aimags())
head(land$land_area_km2)
#> [1]   4736.117 122836.781  82321.392  80742.444  73986.515   5539.957
```
