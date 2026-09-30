# Bags: using boundaries from NSO

``` r

library(mongolmaps)
```

Bags (baga) are the smallest rural units: each soum is divided into a
few bags, about 1,650 in all. mongolmaps knows every bag’s code and
name:

``` r

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
```

but **not their boundaries**. No open dataset publishes them: GADM,
geoBoundaries, the humanitarian COD and OpenStreetMap all stop at soums.
The National Statistics Office of Mongolia (NSO) shares bag boundaries
on request.

## Getting the file

Write to NSO at <international@nso.mn> and ask for:

- bag boundaries as a shapefile or GeoPackage;
- each bag’s NSO code (7 digits, such as `1830151`) or its soum code and
  bag number;
- the date the boundaries are valid for;
- the terms of use (can you share maps? can the file be redistributed?).

## Using the file

Point mongolmaps at the file:

``` r

bags <- mn_bags(path = "bags_from_nso.gpkg")
mn_map(mn_bags(aimag = "Khovd", path = "bags_from_nso.gpkg"), label = TRUE)
```

or register it once, for example in your `.Rprofile`, and forget about
it:

``` r

options(mongolmaps.bags_path = "C:/data/bags_from_nso.gpkg")

mn_bags(aimag = "Khovd")
mn_admin("bag") # khoroos and bags together
mn_join(my_bag_table, by = "code", level = "bag")
```

[`mn_read_bags()`](https://temuulene.github.io/mongolmaps/reference/mn_bags.md)
checks the file when it is first read:

- it finds the column of bag codes (or use `code_col`);
- every code must be a known NSO bag code;
- every bag must lie inside its soum (turn off with
  `check_nesting = FALSE`).

Bags then get the same columns as every other map in the package, so
joining NSO bag tables works like joining aimag tables.
