# Татаж авсан газрын зургийн өгөгдлийг удирдах

Бүрэн нарийвчлалтай хил болон томоохон сэдэвчилсэн давхаргуудыг анх
ашиглахад татаж, кэш хавтаст хадгалдаг тул дараагийн удаа интернетгүй
ажиллана.

## Usage

``` r
mn_cache_dir()

mn_cache_list()

mn_cache_clear(layers = NULL, old_versions = FALSE)

mn_download(layers = "all")
```

## Arguments

- layers:

  Давхаргын id эсвэл бүлэг
  ([`mn_sources()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_sources.md)-ийг
  үзнэ үү), жишээ нь `"admin_high"`, `"osm"`. `NULL`
  (`mn_cache_clear()`-ийн анхдагч) бол бүгдийг; `"all"`
  (`mn_download()`-ийн анхдагч) бол татаж болох бүх давхаргыг.

- old_versions:

  `TRUE` бол `mn_cache_clear()` зөвхөн багцын өмнөх хувилбаруудаас
  үлдсэн өгөгдлийг устгана.

## Value

`mn_cache_dir()`: зам. `mn_cache_list()`: кэшд буй файл бүрт нэг мөртэй
tibble. `mn_cache_clear()` ба `mn_download()`: хамаарах замууд,
харагдахгүйгээр.

## Details

- `mn_cache_dir()` кэш хавтсыг буцаана.
  `options(mongolmaps.cache_dir = "path")`-ээр өөрчилнө.

- `mn_cache_list()` кэшд юу байгааг жагсаана.

- `mn_cache_clear()` кэшийн файлыг устгана.

- `mn_download()` давхаргыг одоо татна, жишээ нь интернетгүй газар
  хээрийн ажилд гарахын өмнө. Давхаргын id-г
  [`mn_sources()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_sources.md)-ээс
  харна уу.

## See also

Эх сурвалж, кэшийн бусад функц:
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
