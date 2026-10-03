# Join your data to a map of Mongolia

Attaches a data frame to boundaries in one step. The column in `by` can
hold names in any common spelling, Cyrillic names, NSO codes, ISO codes
or P-codes; they are matched with
[`mn_match()`](https://temuulene.github.io/mongolmaps/reference/mn_match.md).
Every unit of the level is kept, so places without data still appear on
the map (with `NA`).

## Usage

``` r
mn_join(
  data,
  by,
  level = NULL,
  by_parent = NULL,
  within = NULL,
  drop_other_levels = TRUE,
  resolution = c("low", "high"),
  lang = NULL,
  crs = NULL
)
```

## Arguments

- data:

  A data frame.

- by:

  The column of `data` with place names or codes, as a string or a bare
  column name.

- level:

  The level of the places in `by`. `NULL` detects it.

- by_parent:

  Optional column of `data` naming each row's parent (for example the
  aimag of each soum). Needed when soum or bag names repeat across the
  country.

- within:

  Keep only units inside these places, or these places themselves: names
  or codes of any level, such as `"Khovd"`, `"MN84"` or
  `"Western region"`.

- drop_other_levels:

  If `TRUE` (default), rows for units at other levels, such as national
  or aimag totals in a soum table, are dropped with a single message. If
  `FALSE` they are reported as unmatched.

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

## Value

An `sf` tibble: the boundaries of every unit at the level, with the
columns of `data` added. Columns of `data` whose names clash with
boundary columns get the suffix `.data`.

## Details

**Level.** When `level` is `NULL`, the level with the most matches is
used. NSO tables often list several levels in one column (the national
total, regions, aimags, soums ...); rows at other levels are dropped
with a message (see `drop_other_levels`). Join NSO tables by their code
column (such as `Region`) rather than the label column: labels such as
"Ulaanbaatar" name both a region and an aimag.

**Ulaanbaatar.** The Ulaanbaatar region (NSO code `5`) and the capital
(`511`) cover the same area. Many NSO tables, health tables in
particular, give the capital's figures only on the region row and leave
`511` empty or out. At the aimag level, when the region rows hold more
values than the `511` rows, they are used for Ulaanbaatar, with a
message. A few tables use `511` for something else (for example
"Other"); check the labels of such tables before joining.

**Several rows per unit.** Data with several rows per place (for example
one per year) give several copies of that place's polygon, ready for
[`ggplot2::facet_wrap()`](https://ggplot2.tidyverse.org/reference/facet_wrap.html).

**Places without boundaries.** Villages (tosgon) and rural bags have NSO
codes but no boundary; their rows are reported and left out.

## See also

Other joining data:
[`mn_example_population`](https://temuulene.github.io/mongolmaps/reference/mn_example_population.md)

## Examples

``` r
# Mid-year population from NSO, by aimag and year
pop <- mn_example_population[mn_example_population$Year == 2025, ]
mn_join(pop, by = "Region", level = "aimag")
#> ℹ Joining at the aimag level; dropped 6 rows for larger units ("country" and
#>   "region") and 2196 rows for smaller units ("soum" and "bag").
#> Simple feature collection with 22 features and 19 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 87.7345 ymin: 41.58183 xmax: 119.9315 ymax: 52.14835
#> Geodetic CRS:  WGS 84
#> # A tibble: 22 × 20
#>    pcode name      name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr> <chr>     <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN11  Ulaanbaa… Ulaanb… Улаанб… Ulaanba… aimag capi…     NA MN-1     511     
#>  2 MN21  Dornod    Dornod  Дорнод  Dornod   aimag aimag     NA MN-061   421     
#>  3 MN22  Sukhbaat… Sukhba… Сүхбаа… Sükhbaa… aimag aimag     NA MN-051   422     
#>  4 MN23  Khentii   Khentii Хэнтий  Khentii  aimag aimag     NA MN-039   423     
#>  5 MN41  Tuv       Tuv     Төв     Töv      aimag aimag     NA MN-047   341     
#>  6 MN42  Govisumb… Govisu… Говьсү… Govisüm… aimag aimag     NA MN-064   342     
#>  7 MN43  Selenge   Selenge Сэлэнгэ Selenge  aimag aimag     NA MN-049   343     
#>  8 MN44  Dornogovi Dornog… Дорног… Dornogo… aimag aimag     NA MN-063   344     
#>  9 MN45  Darkhan-… Darkha… Дархан… Darkhan… aimag aimag     NA MN-037   345     
#> 10 MN46  Umnugovi  Umnugo… Өмнөго… Ömnögovi aimag aimag     NA MN-053   346     
#> # ℹ 12 more rows
#> # ℹ 10 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>, Region <chr>, Region_en <chr>, Year <int>,
#> #   value <dbl>

# Khoroos of Ulaanbaatar, from the same table
mn_join(pop, by = "Region", level = "bag", within = "Ulaanbaatar")
#> ℹ Joining at the bag level; dropped 371 rows for larger units ("country",
#>   "region", "aimag", and "soum").
#> Simple feature collection with 204 features and 19 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 106.3626 ymin: 47.30196 xmax: 108.5008 ymax: 48.27193
#> Geodetic CRS:  WGS 84
#> # A tibble: 204 × 20
#>    pcode    name   name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr>    <chr>  <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN110151 1-r k… 1-r kh… 1-р хо… 1-r kho… bag   khor…      1 NA       5110151 
#>  2 MN110153 2-r k… 2-r kh… 2-р хо… 2-r kho… bag   khor…      2 NA       5110153 
#>  3 MN110155 3-r k… 3-r kh… 3-р хо… 3-r kho… bag   khor…      3 NA       5110155 
#>  4 MN110157 4-r k… 4-r kh… 4-р хо… 4-r kho… bag   khor…      4 NA       5110157 
#>  5 MN110159 5-r k… 5-r kh… 5-р хо… 5-r kho… bag   khor…      5 NA       5110159 
#>  6 MN110451 1-r k… 1-r kh… 1-р хо… 1-r kho… bag   khor…      1 NA       5110451 
#>  7 MN110453 2-r k… 2-r kh… 2-р хо… 2-r kho… bag   khor…      2 NA       5110453 
#>  8 MN110751 1-r k… 1-r kh… 1-р хо… 1-r kho… bag   khor…      1 NA       5110751 
#>  9 MN110752 26-r … 26-r k… 26-р х… 26-r kh… bag   khor…     26 NA       5110752 
#> 10 MN110753 2-r k… 2-r kh… 2-р хо… 2-r kho… bag   khor…      2 NA       5110753 
#> # ℹ 194 more rows
#> # ℹ 10 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>, Region <chr>, Region_en <chr>, Year <int>,
#> #   value <dbl>

# Names in any spelling work
df <- data.frame(aimag = c("Khovsgol", "Hovd", "\\u0423\\u0432\\u0441"), value = 1:3)
mn_join(df, aimag)
#> Warning: 1 value could not be matched and became "NA":
#> • \u0423\u0432\u0441
#> Simple feature collection with 22 features and 17 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 87.7345 ymin: 41.58183 xmax: 119.9315 ymax: 52.14835
#> Geodetic CRS:  WGS 84
#> # A tibble: 22 × 18
#>    pcode name      name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr> <chr>     <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN11  Ulaanbaa… Ulaanb… Улаанб… Ulaanba… aimag capi…     NA MN-1     511     
#>  2 MN21  Dornod    Dornod  Дорнод  Dornod   aimag aimag     NA MN-061   421     
#>  3 MN22  Sukhbaat… Sukhba… Сүхбаа… Sükhbaa… aimag aimag     NA MN-051   422     
#>  4 MN23  Khentii   Khentii Хэнтий  Khentii  aimag aimag     NA MN-039   423     
#>  5 MN41  Tuv       Tuv     Төв     Töv      aimag aimag     NA MN-047   341     
#>  6 MN42  Govisumb… Govisu… Говьсү… Govisüm… aimag aimag     NA MN-064   342     
#>  7 MN43  Selenge   Selenge Сэлэнгэ Selenge  aimag aimag     NA MN-049   343     
#>  8 MN44  Dornogovi Dornog… Дорног… Dornogo… aimag aimag     NA MN-063   344     
#>  9 MN45  Darkhan-… Darkha… Дархан… Darkhan… aimag aimag     NA MN-037   345     
#> 10 MN46  Umnugovi  Umnugo… Өмнөго… Ömnögovi aimag aimag     NA MN-053   346     
#> # ℹ 12 more rows
#> # ℹ 8 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>, aimag <chr>, value <int>
```
