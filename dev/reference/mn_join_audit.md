# Inspect the input records behind a map join

Inspect the input records behind a map join

## Usage

``` r
mn_join_audit(x)
```

## Arguments

- x:

  An object returned by
  [`mn_join()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_join.md).

## Value

A tibble with one row per original input record. `action` distinguishes
joined, coalesced, superseded, outside-scope, other-level, missing,
unmatched, ambiguous and boundaryless rows. Original row numbers refer
to the original input, even after filtering the map. The audit is an
attribute; rebuilding an object can remove it.

## See also

Other joining data:
[`mn_example_population`](https://temuulene.github.io/mongolmaps/dev/reference/mn_example_population.md),
[`mn_join()`](https://temuulene.github.io/mongolmaps/dev/reference/mn_join.md)

## Examples

``` r
x <- mn_join(data.frame(place = c("Khovd", "Uvs"), value = 1:2), "place")
mn_join_audit(x)
#> # A tibble: 2 × 13
#>     row x     key   within_pcode pcode name_en status alias distance candidates
#>   <int> <chr> <chr> <chr>        <chr> <chr>   <chr>  <chr>    <int> <list>    
#> 1     1 Khovd hubd  NA           MN84  Khovd   exact  NA           0 <NULL>    
#> 2     2 Uvs   ubs   NA           MN85  Uvs     exact  NA           0 <NULL>    
#> # ℹ 3 more variables: suggestion <chr>, action <chr>, other_level <chr>
```
