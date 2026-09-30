# Олон жижиг газрын зурагт зориулсан аймгийн торон байрлал

21 аймаг ба Улаанбаатарыг газарзүйн ойролцоо байрлалаар нь 4 х 9 торонд
байрлуулсан, geofacet багцын хэрэглэдэг хэлбэрээр.

## Usage

``` r
mn_aimag_grid
```

## Format

22 мөр, 4 баганатай хүснэгт: `row`, `col`, `code` (аймгийн pcode),
`name` (англи нэр).

## See also

Газрын зураг зурах бусад функц:
[`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md),
[`mn_label_points()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_label_points.md),
[`mn_leaflet()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_leaflet.md),
[`mn_map()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_map.md),
[`theme_mn()`](https://temuulene.github.io/mongolmaps/mn/reference/theme_mn.md)

## Examples

``` r
library(ggplot2)
pop <- mn_example_population[nchar(mn_example_population$Region) == 3, ]
pop$code <- mn_match(pop$Region)
ggplot(pop, aes(Year, value / 1000)) +
  geom_line() +
  geofacet::facet_geo(~code, grid = mn_aimag_grid, label = "name") +
  labs(y = "Population (thousands)")
#> Note: You provided a user-specified grid. If this is a generally-useful
#>   grid, please consider submitting it to become a part of the geofacet
#>   package. You can do this easily by calling:
#>   grid_submit(__grid_df_name__)
```
