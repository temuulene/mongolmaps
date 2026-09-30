# Manage downloaded map data

Full-resolution boundaries and the larger thematic layers are downloaded
the first time you use them and kept in a cache folder, so later calls
work offline.

## Usage

``` r
mn_cache_dir()

mn_cache_list()

mn_cache_clear(layers = NULL, old_versions = FALSE)

mn_download(layers = "all")
```

## Arguments

- layers:

  Layer ids or groups (see
  [`mn_sources()`](https://temuulene.github.io/mongolmaps/reference/mn_sources.md)),
  such as `"admin_high"` or `"osm"`. `NULL` (the default for
  `mn_cache_clear()`) means all; `"all"` (the default for
  `mn_download()`) means every downloadable layer.

- old_versions:

  If `TRUE`, `mn_cache_clear()` removes only data left by older versions
  of the package.

## Value

`mn_cache_dir()`: a path. `mn_cache_list()`: a tibble with one row per
cached file. `mn_cache_clear()` and `mn_download()`: the affected paths,
invisibly.

## Details

- `mn_cache_dir()` returns the cache folder. Change it with
  `options(mongolmaps.cache_dir = "path")`.

- `mn_cache_list()` lists what is cached.

- `mn_cache_clear()` deletes cached files.

- `mn_download()` downloads layers now, for example before fieldwork
  without internet. See
  [`mn_sources()`](https://temuulene.github.io/mongolmaps/reference/mn_sources.md)
  for the layer ids.

## See also

Other data sources and cache:
[`mn_sources()`](https://temuulene.github.io/mongolmaps/reference/mn_sources.md)

## Examples

``` r
mn_cache_dir()
#> [1] "/home/runner/.cache/R/mongolmaps"
mn_cache_list()
#> # A tibble: 0 × 4
#> # ℹ 4 variables: data_version <chr>, file <chr>, size_mb <dbl>, path <chr>
mn_download("admin_high")
#> ℹ Downloading Full-resolution administrative boundaries (3.7 MB); this happens
#>   once.
```
