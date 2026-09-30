# Summarise a raster over map units

Adds a column to `x` with a summary of the raster cells in each unit,
for example the total population of every soum or the mean elevation of
every aimag.

## Usage

``` r
mn_zonal(
  r,
  x = NULL,
  fun = c("sum", "mean", "min", "max", "median"),
  name = "value"
)
```

## Arguments

- r:

  A `terra` SpatRaster (one layer), such as from
  [`mn_population()`](https://temuulene.github.io/mongolmaps/reference/mn_population.md).

- x:

  An `sf` object of polygons, such as
  [`mn_soums()`](https://temuulene.github.io/mongolmaps/reference/mn_soums.md).
  Defaults to the aimags.

- fun:

  Summary function name: `"sum"` (default), `"mean"`, `"min"`, `"max"`
  or `"median"`.

- name:

  Name of the new column.

## Value

`x` with a new column.

## See also

Other raster layers:
[`mn_elevation()`](https://temuulene.github.io/mongolmaps/reference/mn_elevation.md),
[`mn_landcover()`](https://temuulene.github.io/mongolmaps/reference/mn_landcover.md),
[`mn_population()`](https://temuulene.github.io/mongolmaps/reference/mn_population.md)

## Examples

``` r
soum_pop <- mn_zonal(mn_population(2025), mn_soums(), name = "population")
mn_map(soum_pop, fill = population / area_km2, trans = "log10")
```
