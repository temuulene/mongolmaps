# A geographic small-multiple grid for Ulaanbaatar districts

Approximate positions of the nine districts, suitable for geofacet. This
layout is a cartographic arrangement, not a coordinate system.

## Usage

``` r
mn_ub_grid
```

## Format

A data frame with nine rows and columns `row`, `col`, `code` (district
pcode) and `name` (English name).

## See also

Other mapping helpers:
[`mn_aimag_grid`](https://temuulene.github.io/mongolmaps/reference/mn_aimag_grid.md),
[`mn_crs()`](https://temuulene.github.io/mongolmaps/reference/mn_crs.md),
[`mn_erase_water()`](https://temuulene.github.io/mongolmaps/reference/mn_erase_water.md),
[`mn_inset_ub()`](https://temuulene.github.io/mongolmaps/reference/mn_inset_ub.md),
[`mn_label_points()`](https://temuulene.github.io/mongolmaps/reference/mn_label_points.md),
[`mn_leaflet()`](https://temuulene.github.io/mongolmaps/reference/mn_leaflet.md),
[`mn_map()`](https://temuulene.github.io/mongolmaps/reference/mn_map.md),
[`theme_mn()`](https://temuulene.github.io/mongolmaps/reference/theme_mn.md)

## Examples

``` r
data <- mn_ub_grid
data$value <- seq_len(nrow(data))
ggplot2::ggplot(data, ggplot2::aes(1, value)) +
  ggplot2::geom_col() +
  geofacet::facet_geo(~code, grid = mn_ub_grid, label = "name")
#> Note: You provided a user-specified grid. If this is a generally-useful
#>   grid, please consider submitting it to become a part of the geofacet
#>   package. You can do this easily by calling:
#>   grid_submit(__grid_df_name__)
#> Warning: no non-missing arguments to min; returning Inf
#> Warning: no non-missing arguments to max; returning -Inf
#> Warning: no non-missing arguments to min; returning Inf
#> Warning: no non-missing arguments to max; returning -Inf
#> Warning: no non-missing arguments to min; returning Inf
#> Warning: no non-missing arguments to max; returning -Inf
#> Warning: no non-missing arguments to min; returning Inf
#> Warning: no non-missing arguments to max; returning -Inf
#> Warning: no non-missing arguments to min; returning Inf
#> Warning: no non-missing arguments to max; returning -Inf
#> Warning: no non-missing arguments to min; returning Inf
#> Warning: no non-missing arguments to max; returning -Inf
#> Warning: no non-missing arguments to min; returning Inf
#> Warning: no non-missing arguments to max; returning -Inf
```
