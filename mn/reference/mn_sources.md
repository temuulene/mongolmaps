# Өгөгдлийн эх сурвалж, лиценз, иш татах

Эх үүсвэр, үйлчилгээ үзүүлэгч, лиценз, эхийн хувилбар, геометр болон
кодын үе, эрх бүхий эсэхийг жагсаана. Эхийн авсан огноо нь захиргааны
хил хүчин төгөлдөр болсон огноотой адил биш. `mn_citation()` нь
давхаргын id эсвэл мета өгөгдөлтэй объектын эхийг ишлэх текст буцаана.

## Usage

``` r
mn_sources(layer = NULL)

mn_citation(layers = "admin")
```

## Arguments

- layer, layers:

  Давхаргын id, жишээ нь `"admin"`, `"khoroos"`, `"settlements"`. `NULL`
  бол бүх давхаргыг жагсаана.

## Value

`mn_sources()`: `id`, `title`, `group`, `delivery` (`"bundled"`,
`"release"` эсвэл `"upstream"`), `provider`, `license`, `license_url`,
`valid_on`, `source_url`, `attribution`, `notes` баганатай tibble.
`mn_citation()`: нэг тэмдэгт мөр.

## Details

Газрын зураг нийтлэхдээ өгөгдөл нийлүүлэгчийг дурдана уу. Ихэнх давхарга
эх сурвалжийг дурдахыг шаарддаг лицензтэй (CC BY, ODbL).

## See also

Эх сурвалж, кэшийн бусад функц:
[`mn_cache_dir()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_cache_dir.md),
[`mn_provenance()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_provenance.md)

## Examples

``` r
mn_sources()
#> # A tibble: 16 × 17
#>    id      title group delivery provider license license_url valid_on source_url
#>    <chr>   <chr> <chr> <chr>    <chr>    <chr>   <chr>       <chr>    <chr>     
#>  1 admin   Admi… admin bundled  Nationa… CC BY-… https://cr… 2020-10… https://d…
#>  2 khoroos Ulaa… admin bundled  khoroo-… 0BSD    https://op… 2026-05… https://g…
#>  3 codes   Unit… admin bundled  Nationa… Open d… https://ww… 2025     https://d…
#>  4 settle… Capi… sett… bundled  Wikidata CC0 1.0 https://cr… NA       https://w…
#>  5 natura… Neig… cont… bundled  Natural… Public… https://ww… NA       https://w…
#>  6 admin_… Full… admin release  Nationa… CC BY-… https://cr… 2020-10… https://d…
#>  7 osm_ro… Road… osm   release  OpenStr… ODbL 1… https://op… 2026-09… https://d…
#>  8 osm_tr… Rail… osm   release  OpenStr… ODbL 1… https://op… 2026-09… https://d…
#>  9 osm_wa… Rive… osm   release  OpenStr… ODbL 1… https://op… 2026-09… https://d…
#> 10 osm_pl… Popu… osm   release  OpenStr… ODbL 1… https://op… 2026-09… https://d…
#> 11 elevat… Elev… rast… release  Coperni… Copern… https://sp… 2021     https://r…
#> 12 landco… Land… rast… release  ESA Wor… CC BY … https://cr… 2021     https://e…
#> 13 copern… Elev… rast… upstream Coperni… Copern… https://sp… 2021     https://r…
#> 14 worldc… Land… rast… upstream ESA Wor… CC BY … https://cr… 2021     https://e…
#> 15 worldp… Popu… rast… upstream WorldPo… CC BY … https://cr… R2025A   https://w…
#> 16 wdpa    Prot… envi… upstream UNEP-WC… WDPA t… https://ww… NA       https://w…
#> # ℹ 8 more variables: attribution <chr>, notes <chr>, data_version <chr>,
#> #   source_revision <chr>, geometry_vintage <chr>, code_vintage <chr>,
#> #   effective_date <chr>, authority <chr>
mn_citation(c("admin", "khoroos"))
#> [1] "Boundaries: NSO Mongolia & OCHA (COD-AB), CC BY-IGO; Khoroos: khoroo-map (0BSD), unofficial"
```
