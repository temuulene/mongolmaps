# National and urban maps with Ulaanbaatar inset panels

Compose ordinary ggplots without shifting any analytical coordinates.
All panels share fill limits and breaks. When supplying different data
to the national and urban panels, their fill expressions must have
compatible units. Insets have independent map scales.

## Usage

``` r
mn_inset_ub(
  x = NULL,
  ub = NULL,
  fill = NULL,
  label = FALSE,
  title = NULL,
  limits = NULL,
  breaks = NULL,
  ...
)

mn_map_ub(
  x = NULL,
  fill = NULL,
  label = FALSE,
  title = NULL,
  limits = NULL,
  breaks = NULL,
  ...
)
```

## Arguments

- x:

  A national map for `mn_inset_ub()`, or a UB district/khoroo map for
  `mn_map_ub()`. Defaults to aimags or UB districts respectively.

- ub:

  Optional urban data for the inset. By default, select Ulaanbaatar
  units from `x`; if none exist, stop rather than invent data.

- fill:

  An unquoted fill column/expression, as in
  [`mn_map()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_map.md).

- label:

  Label units in each panel.

- title:

  Overall title.

- limits, breaks:

  Shared fill scale limits and breaks.

- ...:

  Additional arguments to
  [`mn_map()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_map.md),
  such as `lang`, `trans`, `bins` or `midpoint`.

## Value

A patchwork object; requires the optional patchwork package. No input
geometry is modified.

## See also

Other mapping helpers:
[`mn_aimag_grid`](https://temuulene.github.io/mongolmaps/dev/reference/mn_aimag_grid.md),
[`mn_crs()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_crs.md),
[`mn_erase_water()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_erase_water.md),
[`mn_label_points()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_label_points.md),
[`mn_leaflet()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_leaflet.md),
[`mn_map()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_map.md),
[`mn_ub_grid`](https://temuulene.github.io/mongolmaps/dev/reference/mn_ub_grid.md),
[`theme_mn()`](https://temuulene.github.io/mongolmaps/dev/reference/theme_mn.md)

## Examples

``` r
mn_inset_ub(fill = area_km2)

mn_map_ub(fill = area_km2)
```
