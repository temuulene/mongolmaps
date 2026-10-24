# Улаанбаатарын дүүргийн жижиг олон зурагт зориулсан тор

Есөн дүүргийн ойролцоо газарзүйн байрлалтай geofacet тор. Энэ нь
дүрслэлийн зохион байгуулалт бөгөөд координатын систем биш.

## Usage

``` r
mn_ub_grid
```

## Format

Есөн мөртэй data frame: `row`, `col`, `code` (дүүргийн P-код), `name`
(англи нэр).

## See also

Газрын зураг зурах бусад функц:
[`mn_aimag_grid`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimag_grid.md),
[`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md),
[`mn_erase_water()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_erase_water.md),
[`mn_inset_ub()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_inset_ub.md),
[`mn_label_points()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_label_points.md),
[`mn_leaflet()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_leaflet.md),
[`mn_map()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_map.md),
[`theme_mn()`](https://temuulene.github.io/mongolmaps/mn/reference/theme_mn.md)

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
