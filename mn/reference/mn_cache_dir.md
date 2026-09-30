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
  [`mn_sources()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_sources.md)),
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
  [`mn_sources()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_sources.md)
  for the layer ids.

## See also

Other data sources and cache:
[`mn_sources()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_sources.md)

## Examples

``` r
mn_cache_dir()
#> [1] "/home/runner/.cache/R/mongolmaps"
mn_cache_list()
#> # A tibble: 14 × 4
#>    data_version file                                 size_mb path               
#>    <chr>        <chr>                                  <dbl> <chr>              
#>  1 data-v1      admin_high.gpkg.zip                     3.72 /home/runner/.cach…
#>  2 data-v1      admin_high/admin_high.gpkg              6.37 /home/runner/.cach…
#>  3 data-v1      elevation_1km.tif                       4.09 /home/runner/.cach…
#>  4 data-v1      landcover_1km.tif                       0.33 /home/runner/.cach…
#>  5 data-v1      osm_places.gpkg.zip                     0.06 /home/runner/.cach…
#>  6 data-v1      osm_places/osm_places.gpkg              0.23 /home/runner/.cach…
#>  7 data-v1      osm_roads.gpkg.zip                     29.2  /home/runner/.cach…
#>  8 data-v1      osm_roads/osm_roads.gpkg               54.6  /home/runner/.cach…
#>  9 data-v1      osm_transport.gpkg.zip                  0.47 /home/runner/.cach…
#> 10 data-v1      osm_transport/osm_transport.gpkg        1.01 /home/runner/.cach…
#> 11 data-v1      osm_water.gpkg.zip                     19.9  /home/runner/.cach…
#> 12 data-v1      osm_water/osm_water.gpkg               31.9  /home/runner/.cach…
#> 13 upstream     mng_pop_2025_CN_1km_R2025A_UA_v1.tif    0.39 /home/runner/.cach…
#> 14 upstream     wdpa_mng.geojson                        0.74 /home/runner/.cach…
mn_download("admin_high")
```
