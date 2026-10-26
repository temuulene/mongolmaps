# Maps of Ulaanbaatar

Use
[`mn_ub()`](https://temuulene.github.io/mongolmaps/reference/mn_ub.md)
for the city outline,
[`mn_ub_districts()`](https://temuulene.github.io/mongolmaps/reference/mn_ub.md)
for its nine districts, or
[`mn_khoroos()`](https://temuulene.github.io/mongolmaps/reference/mn_ub.md)
for its 204 khoroos. All three layers are included in the package.

``` r

library(mongolmaps)
library(ggplot2)
```

## Show all nine districts

``` r

districts <- mn_ub_districts()
mn_map(districts, fill = name, label = TRUE,
       title = "Ulaanbaatar: nine districts") +
  guides(fill = "none")
```

![All nine Ulaanbaatar districts in their true
locations.](ulaanbaatar_files/figure-html/districts-1.png)

Baganuur and Bagakhangai sit apart from the main city. To make the main
city easier to see, put them in separate panels. This example also needs
patchwork (`install.packages("patchwork")`).

``` r

mn_map_ub(fill = name, label = TRUE, title = "Ulaanbaatar districts") &
  guides(fill = "none")
```

![Ulaanbaatar with separate panels for Baganuur and
Bagakhangai.](ulaanbaatar_files/figure-html/district-panels-1.png)

Each panel has its own geographic scale. Use the first map to compare
distances between districts.

## Focus on central khoroos

Select districts by name or abbreviations such as `"BZD"`, `"SBD"` and
`"KhUD"`. Cyrillic names and abbreviations work too.

``` r

central <- mn_khoroos(district = c("Bayangol", "Sukhbaatar", "Chingeltei"))
central$district <- districts$name[match(central$parent_pcode, districts$pcode)]
mn_map(central, fill = district, title = "Khoroos in three central districts") +
  labs(fill = "District")
```

![Khoroos in Bayangol, Sukhbaatar and Chingeltei, coloured by
district.](ulaanbaatar_files/figure-html/central-1.png)

Khoroos are numbered within each district. Show one district at a time
and use `label = TRUE` to label them:

``` r

mn_map(mn_khoroos(district = "Sukhbaatar"), label = TRUE,
       title = "Sukhbaatar district: khoroo numbers")
```

![Sukhbaatar district's khoroos labelled with their
numbers.](ulaanbaatar_files/figure-html/khoroos-1.png)

To find a single khoroo, give both its number and district:

``` r

mn_match("15-r khoroo", level = "bag", within = "Bayangol")
#> [1] "MN110779"
```

## Add population data

The included NSO table has mid-year population for 2015, 2020 and 2025.
Keep one year and join its `Region` codes to the khoroos.
`level = "bag"` includes khoroos in the package’s code system.

``` r

pop <- mn_example_population[mn_example_population$Year == 2025, ]
khoroo_pop <- mn_join(pop, by = "Region", level = "bag", within = "Ulaanbaatar")
central_pop <- khoroo_pop[khoroo_pop$parent_pcode %in% central$parent_pcode, ]

mn_map(central_pop, fill = value / area_km2, trans = "log10",
       title = "Population density, 2025") +
  labs(fill = "People per km²", subtitle = "Bayangol, Sukhbaatar and Chingeltei")
```

![Khoroo population density in three central districts in 2025, using a
logarithmic colour scale.](ulaanbaatar_files/figure-html/join-1.png)

The logarithmic colour scale shows differences across a wide range of
densities. Grey means no value was available, rather than zero people.

## Explore an interactive map

Install leaflet once (`install.packages("leaflet")`). Hover for names,
click for details, and use the zoom buttons to explore. Background tiles
need internet access.

``` r

mn_leaflet(central_pop, fill = value)
```

The interactive version is displayed on the package website. In R, run
the same code to open it in the Viewer or your browser.

## Know the boundary limits

The khoroo shapes come from the open khoroo-map project, which does not
document its original data source. Treat them as **unofficial**. The
package fits them to the official city outline and builds district
shapes from their combined khoroos. This makes the layers fit together;
it does not verify their legal boundaries or effective dates. See
[`?mn_khoroos`](https://temuulene.github.io/mongolmaps/reference/mn_ub.md)
for details.
