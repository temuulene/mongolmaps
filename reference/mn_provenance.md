# Inspect source provenance and available boundary revisions

Provenance records distinguish the source snapshot from its effective
date, which is unknown for several layers. A high resolution or recent
download does not make an unofficial source authoritative.

## Usage

``` r
mn_provenance(x)

mn_vintages(layer = NULL)
```

## Arguments

- x:

  An object returned by mongolmaps.

- layer:

  Optional source layer ids, as in
  [`mn_sources()`](https://temuulene.github.io/mongolmaps/reference/mn_sources.md).

## Value

`mn_provenance()`: a tibble of source metadata attached to the object,
or an empty tibble for an untagged object. `mn_vintages()`: a catalog of
currently available administrative source snapshots. `effective_date` is
missing unless independently established. Metadata are attributes, so
reconstructing objects may remove them.

## See also

Other data sources and cache:
[`mn_cache_dir()`](https://temuulene.github.io/mongolmaps/reference/mn_cache_dir.md),
[`mn_sources()`](https://temuulene.github.io/mongolmaps/reference/mn_sources.md)

## Examples

``` r
mn_provenance(mn_aimags())
#> # A tibble: 1 × 20
#>   id    title    group delivery provider license license_url valid_on source_url
#>   <chr> <chr>    <chr> <chr>    <chr>    <chr>   <chr>       <chr>    <chr>     
#> 1 admin Adminis… admin bundled  Nationa… CC BY-… https://cr… 2020-10… https://d…
#> # ℹ 11 more variables: attribution <chr>, notes <chr>, data_version <chr>,
#> #   source_revision <chr>, geometry_vintage <chr>, code_vintage <chr>,
#> #   effective_date <chr>, authority <chr>, resolution <chr>,
#> #   retrieved_on <chr>, crs <chr>
mn_vintages()
#> # A tibble: 4 × 8
#>   id         data_version geometry_vintage          code_vintage source_revision
#>   <chr>      <chr>        <chr>                     <chr>        <chr>          
#> 1 admin      data-v1      COD 2020; Ulaanbaatar kh… NSO 2025 sn… 2020-10-19     
#> 2 khoroos    data-v1      2026 source snapshot; ef… NSO 2025 sn… bb1bf18f27e57d…
#> 3 codes      data-v1      NA                        NSO 2025 sn… 2025           
#> 4 admin_high data-v1      COD 2020; Ulaanbaatar kh… NSO 2025 sn… 2020-10-19     
#> # ℹ 3 more variables: effective_date <chr>, authority <chr>, notes <chr>
```
