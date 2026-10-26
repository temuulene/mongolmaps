# Bring your own bag boundaries

Bags are the smallest rural administrative units. mongolmaps includes
their names and codes, but **does not include rural bag boundaries**.
Khoroos in Ulaanbaatar are available separately through
[`mn_khoroos()`](https://temuulene.github.io/mongolmaps/reference/mn_ub.md).

This guide explains how to use a boundary file you have obtained. It
cannot display your bag map until you supply that file.

``` r

library(mongolmaps)
```

## Check the available codes

Use the aimag and soum together when a place name is repeated.

``` r

bag_codes <- mn_codes("bag", within = "MN8401")
knitr::kable(head(bag_codes[c("name_en", "nso_code", "has_geometry")]))
```

| name_en                  | nso_code | has_geometry |
|:-------------------------|:---------|:-------------|
| 1-r bag, Alagtolgoi      | 1840151  | FALSE        |
| 2-r bag, Baatarkhairkhan | 1840153  | FALSE        |
| 3-r bag, Bichigt         | 1840155  | FALSE        |
| 4-r bag, Bugat           | 1840157  | FALSE        |
| 5-r bag, Buyant          | 1840159  | FALSE        |
| 6-r bag, Jargalan        | 1840161  | FALSE        |

`has_geometry = FALSE` means the package has a code but no included
shape. The parent code in this example identifies Jargalant soum in
Khovd; use `mn_codes("soum", within = "Khovd")` to find other soums.

## Obtain a boundary file

Ask NSO for a shapefile or GeoPackage containing:

- A unique NSO bag code for each shape, preferably stored as text.
- The date the boundaries apply to.
- The file’s coordinate reference system.
- Terms covering use of the data, published maps and redistribution.

You can contact NSO through its official website. Confirm availability
and terms with the provider; the package cannot supply this file.

## Read and check your file

The examples below are recipes. Replace the path with your actual file
before running them. If you have a shapefile, keep its `.shp`, `.shx`,
`.dbf` and projection files together.

``` r

bags <- mn_read_bags("bags_from_nso.gpkg", code_col = "nso_code")
khovd_bags <- mn_bags(aimag = "Khovd", path = "bags_from_nso.gpkg")
mn_map(khovd_bags, title = "Bag boundaries in Khovd")
```

Replace `"nso_code"` with the code column in your file, or omit
`code_col` to let the reader detect it. The reader checks the codes,
geometry and nesting inside each soum. If a check fails, inspect the
file and its boundary date before disabling a check.

## Use the file in later calls

Register the file for the current R session:

``` r

options(mongolmaps.bags_path = "C:/data/bags_from_nso.gpkg")
khovd_bags <- mn_bags(aimag = "Khovd")
```

To keep that setting across sessions, add the
[`options()`](https://rdrr.io/r/base/options.html) line to your
`.Rprofile`. With the file registered, `mn_admin("bag")` can combine
available bag and khoroo boundaries.

## Join a statistics table

This recipe expects your own `my_bag_table` with a `code` column.

``` r

bag_map <- mn_join(my_bag_table, by = "code", level = "bag")
mn_join_audit(bag_map)
```

The joined data use the same columns as other package maps. Check for
unmatched codes and missing shapes before drawing the map. See [Putting
your data on a
map](https://temuulene.github.io/mongolmaps/articles/joining-data.md)
for the full workflow.
