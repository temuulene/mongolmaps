# Data sources, licences and citations

`mn_sources()` lists every data layer in the package: who provides it,
under which licence, whether it ships with the package or is downloaded,
and how current it is. `mn_citation()` returns the attribution text to
put under a map;
[`mn_map()`](https://temuulene.github.io/mongolmaps/reference/mn_map.md)
adds it as a caption automatically.

## Usage

``` r
mn_sources(layer = NULL)

mn_citation(layers = "admin")
```

## Arguments

- layer, layers:

  Layer ids, such as `"admin"`, `"khoroos"` or `"settlements"`. `NULL`
  lists all layers.

## Value

`mn_sources()`: a tibble with columns `id`, `title`, `group`, `delivery`
(`"bundled"`, `"release"` or `"upstream"`), `provider`, `license`,
`license_url`, `valid_on`, `source_url`, `attribution` and `notes`.
`mn_citation()`: a single string.

## Details

Please credit the data providers when you publish maps. Most layers are
under licences that require attribution (CC BY, ODbL).

## See also

Other data sources and cache:
[`mn_cache_dir()`](https://temuulene.github.io/mongolmaps/reference/mn_cache_dir.md)

## Examples

``` r
mn_sources()
#> # A tibble: 16 × 11
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
#> # ℹ 2 more variables: attribution <chr>, notes <chr>
mn_citation(c("admin", "khoroos"))
#> [1] "Boundaries: NSO Mongolia & OCHA (COD-AB), CC BY-IGO; Khoroos: khoroo-map (0BSD), unofficial"
```
