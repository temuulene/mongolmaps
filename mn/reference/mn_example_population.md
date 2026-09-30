# Mid-year resident population of Mongolia (example data)

Population by administrative unit for 2015, 2020 and 2025, exactly as
returned by the National Statistics Office (NSO) table DT_NSO_0300_002V4
via the mongolstats package. The `Region` column mixes levels (national
total, regions, aimags, soums, bags and khoroos), as NSO tables do,
which makes it a good example for
[`mn_join()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_join.md).

## Usage

``` r
mn_example_population
```

## Format

A data frame with 6,672 rows and 4 columns:

- Region:

  NSO unit code, such as `"0"` (Mongolia), `"183"` (Bayan-Ulgii),
  `"18301"` (Ulgii soum) or `"5110751"` (Bayangol district, 1st khoroo).

- Region_en:

  English label of the unit.

- Year:

  Year.

- value:

  Mid-year resident population.

## Source

National Statistics Office of Mongolia, <https://data.1212.mn/pxweb/>,
retrieved 2026-09-29.

## See also

Other joining data:
[`mn_join()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_join.md)

## Examples

``` r
head(mn_example_population)
#> # A tibble: 6 × 4
#>   Region  Region_en           Year   value
#>   <chr>   <chr>              <int>   <dbl>
#> 1 0       Total               2015 2964085
#> 2 1       Western region      2015  381840
#> 3 181     Zavkhan             2015   69637
#> 4 18101   Uliastai            2015   15871
#> 5 1810151 1-r bag, Jinst      2015    3333
#> 6 1810153 2-r bag, Jargalant  2015    2978
```
