# Татаж авсан газрын зургийн өгөгдлийг удирдах

`mn_assets()` нь татаж болох файлууд, WorldPop-ийн он, нарийвчлалыг
жагсаана. `mn_download()` урьдчилан татаж, `mn_cache_list()` кэшийг
харуулж, `mn_cache_verify()` шалгах нийлбэрийг дахин тооцно.
`mn_cache_clear()` сонгосон файлыг цэвэрлэнэ. Хуучин хувилбарыг
автоматаар устгахгүй.

## Usage

``` r
mn_cache_dir()

mn_cache_list()

mn_cache_clear(layers = NULL, old_versions = FALSE)

mn_download(layers = "all")

mn_assets()

mn_cache_verify(layers = NULL)
```

## Arguments

- layers:

  Давхаргын id эсвэл бүлэг. `"all"` нь тогтмол файлуудыг татах бөгөөд
  WorldPop-ийн бүх он, нарийвчлалыг татахгүй. Жишээ нь
  `"worldpop_2025_1km"`-ийг тусад нь сонгоно. `"worldpop"` нь бүх
  хувилбарыг сонгоно.

- old_versions:

  `TRUE` бол `mn_cache_clear()` зөвхөн багцын өмнөх хувилбаруудаас
  үлдсэн өгөгдлийг устгана.

## Value

Кэшийн зам, файлын мэдээлэл, татах файлын бүртгэл эсвэл шалгах
нийлбэрийн тайлан. Татах болон цэвэрлэх функц нөлөөлсөн замуудыг үл
харагдах байдлаар буцаана.

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
[`mn_provenance()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_provenance.md),
[`mn_sources()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_sources.md)

## Examples

``` r
mn_cache_dir()
#> [1] "/home/runner/.cache/R/mongolmaps"
mn_cache_list()
#> # A tibble: 14 × 7
#>    data_version file        size_mb path  modified            layer has_checksum
#>    <chr>        <chr>         <dbl> <chr> <dttm>              <chr> <lgl>       
#>  1 data-v1      admin_high…    3.72 /hom… 2026-10-24 07:13:06 admi… TRUE        
#>  2 data-v1      admin_high…    6.37 /hom… 2026-10-24 07:13:06 NA    TRUE        
#>  3 data-v1      elevation_…    4.09 /hom… 2026-10-24 07:13:10 elev… TRUE        
#>  4 data-v1      landcover_…    0.33 /hom… 2026-10-24 07:13:22 land… TRUE        
#>  5 data-v1      osm_places…    0.06 /hom… 2026-10-24 07:17:52 osm_… TRUE        
#>  6 data-v1      osm_places…    0.23 /hom… 2026-10-24 07:17:52 NA    TRUE        
#>  7 data-v1      osm_roads.…   29.2  /hom… 2026-10-24 07:17:44 osm_… TRUE        
#>  8 data-v1      osm_roads/…   54.6  /hom… 2026-10-24 07:17:45 NA    TRUE        
#>  9 data-v1      osm_transp…    0.47 /hom… 2026-10-24 07:17:52 osm_… TRUE        
#> 10 data-v1      osm_transp…    1.01 /hom… 2026-10-24 07:17:52 NA    TRUE        
#> 11 data-v1      osm_water.…   19.9  /hom… 2026-10-24 07:13:36 osm_… TRUE        
#> 12 data-v1      osm_water/…   31.9  /hom… 2026-10-24 07:13:36 NA    TRUE        
#> 13 upstream     mng_pop_20…    0.39 /hom… 2026-10-24 07:13:38 worl… TRUE        
#> 14 upstream     wdpa_mng.g…    1.09 /hom… 2026-10-24 07:17:43 wdpa  TRUE        
mn_download("admin_high")
```
