# Bags: the smallest rural units

Bags (baga) are the subdivisions of soums; there are about 1,650 of
them. Their codes and names are built in (see `mn_codes("bag")`), but
**their boundaries are not openly published**: the National Statistics
Office of Mongolia (NSO) shares them on request. Once you have a bag
boundary file, `mn_bags()` and every other function in the package can
use it.

## Usage

``` r
mn_bags(
  aimag = NULL,
  soum = NULL,
  path = getOption("mongolmaps.bags_path"),
  resolution = c("low", "high"),
  lang = NULL,
  crs = NULL
)

mn_read_bags(path, code_col = NULL, check_nesting = TRUE)
```

## Arguments

- aimag, soum:

  Keep only bags in these aimags or soums (names or codes).

- path:

  Path to a bag boundary file readable by
  [`sf::st_read()`](https://r-spatial.github.io/sf/reference/st_read.html).
  Defaults to `getOption("mongolmaps.bags_path")`.

- resolution:

  `"low"` (default) uses simplified boundaries that ship with the
  package and suit most maps. `"high"` uses full-resolution boundaries,
  downloaded once (about 10 MB) and cached; see
  [`mn_cache_dir()`](https://temuulene.github.io/mongolmaps/reference/mn_cache_dir.md).

- lang:

  Language of the `name` column: `"en"` (English, as in NSO tables),
  `"mn"` (Cyrillic) or `"mns"` (Latin with diacritics, MNS 5217).
  Defaults to `getOption("mongolmaps.lang", "en")`.

- crs:

  Coordinate reference system of the result. `NULL` (default) keeps
  longitude/latitude (EPSG:4326). Use `"albers"`, `"lcc"` or `"utm"` for
  a projection suited to Mongolia (see
  [`mn_crs()`](https://temuulene.github.io/mongolmaps/reference/mn_crs.md)),
  or any value accepted by
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html).

- code_col:

  Name of the column holding bag codes: 7-digit NSO codes (`"1830151"`)
  or P-codes (`"MN830151"`). `NULL` detects it.

- check_nesting:

  If `TRUE` (default), stop when a bag lies outside its soum.

## Value

An `sf` tibble; see
[`mn_admin()`](https://temuulene.github.io/mongolmaps/reference/mn_admin.md)
for the columns.

## Getting bag boundaries

Write to NSO (<international@nso.mn>) and ask for the bag boundaries as
a shapefile or GeoPackage, with each bag's NSO code. Then either pass
the file to `mn_bags(path = ...)`, or register it once per session with
`options(mongolmaps.bags_path = "path/to/bags.gpkg")` (put that line in
your `.Rprofile` to make it permanent). Registered bags are also
returned by `mn_admin("bag")` and used by
[`mn_join()`](https://temuulene.github.io/mongolmaps/reference/mn_join.md).

`mn_read_bags()` checks the file: every bag must have a known code and
sit inside its soum.

## See also

Other admin boundaries:
[`mn_admin()`](https://temuulene.github.io/mongolmaps/reference/mn_admin.md),
[`mn_aimags()`](https://temuulene.github.io/mongolmaps/reference/mn_aimags.md),
[`mn_country()`](https://temuulene.github.io/mongolmaps/reference/mn_country.md),
[`mn_soums()`](https://temuulene.github.io/mongolmaps/reference/mn_soums.md),
[`mn_ub()`](https://temuulene.github.io/mongolmaps/reference/mn_ub.md)

## Examples

``` r
# Codes and names of all bags, without boundaries:
mn_codes("bag", within = "Khovd")
#> # A tibble: 91 × 16
#>    pcode    name   name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr>    <chr>  <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN840151 1-r b… 1-r ba… 1-р ба… 1-r bag… bag   bag        1 NA       1840151 
#>  2 MN840153 2-r b… 2-r ba… 2-р ба… 2-r bag… bag   bag        2 NA       1840153 
#>  3 MN840155 3-r b… 3-r ba… 3-р ба… 3-r bag… bag   bag        3 NA       1840155 
#>  4 MN840157 4-r b… 4-r ba… 4-р ба… 4-r bag… bag   bag        4 NA       1840157 
#>  5 MN840159 5-r b… 5-r ba… 5-р ба… 5-r bag… bag   bag        5 NA       1840159 
#>  6 MN840161 6-r b… 6-r ba… 6-р ба… 6-r bag… bag   bag        6 NA       1840161 
#>  7 MN840163 7-r b… 7-r ba… 7-р ба… 7-r bag… bag   bag        7 NA       1840163 
#>  8 MN840165 8-r b… 8-r ba… 8-р ба… 8-r bag… bag   bag        8 NA       1840165 
#>  9 MN840167 9-r b… 9-r ba… 9-р ба… 9-r bag… bag   bag        9 NA       1840167 
#> 10 MN840169 10-r … 10-r b… 10-р б… 10-r ba… bag   bag       10 NA       1840169 
#> # ℹ 81 more rows
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>, has_geometry <lgl>

if (FALSE) { # \dontrun{
bags <- mn_bags(path = "bags_from_nso.gpkg")
options(mongolmaps.bags_path = "bags_from_nso.gpkg")
mn_bags(aimag = "Khovd")
} # }
```
