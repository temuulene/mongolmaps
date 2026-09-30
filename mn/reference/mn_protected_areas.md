# Protected areas

National parks, nature reserves and other protected and conserved areas
of Mongolia from the World Database on Protected Areas (WDPA). The data
are downloaded from UNEP-WCMC the first time and refreshed after 90
days; they may not be redistributed, so they never ship with the
package.

## Usage

``` r
mn_protected_areas(within = NULL, refresh = FALSE, crs = NULL)
```

## Arguments

- within:

  Keep only areas inside these places (names or codes).

- refresh:

  If `TRUE`, download again now.

- crs:

  Coordinate reference system of the result. `NULL` (default) keeps
  longitude/latitude (EPSG:4326). Use `"albers"`, `"lcc"` or `"utm"` for
  a projection suited to Mongolia (see
  [`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md)),
  or any value accepted by
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html).

## Value

An `sf` tibble with the WDPA attributes, including `name_eng`,
`desig_eng` (designation), `iucn_cat` and `status_yr`.

## Terms of use

UNEP-WCMC and IUCN, Protected Planet: The World Database on Protected
Areas (WDPA), Cambridge, UK. See
<https://www.protectedplanet.net/en/legal>. The WDPA may be used for
non-commercial purposes with attribution; it may not be redistributed.

## See also

Other thematic layers:
[`mn_neighbours()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_neighbours.md),
[`mn_roads()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_roads.md),
[`mn_settlements()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_settlements.md)

## Examples

``` r
pa <- mn_protected_areas()
mn_map(pa, fill = desig_eng)
```
