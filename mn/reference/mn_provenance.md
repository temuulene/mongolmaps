# Өгөгдлийн гарал үүсэл болон боломжит хилийн хувилбар

Эхийн хувилбар, геометр болон кодын үе, эрх бүхий эсэх, лицензийг
шалгана. Эхийг татсан огноо нь хил хүчин төгөлдөр болсон огноо биш.

## Usage

``` r
mn_provenance(x)

mn_vintages(layer = NULL)
```

## Arguments

- x:

  mongolmaps-аас буцсан объект.

- layer:

  [`mn_sources()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_sources.md)-д
  ашигладаг эхийн id; `NULL` бол бүх захиргааны эх.

## Value

`mn_provenance()` нь объектод хавсаргасан эхийн мэдээлэл, байхгүй бол
хоосон tibble буцаана. `mn_vintages()` нь одоогоор боломжит захиргааны
хилийн эхийн хувилбарыг жагсаана.

## See also

Эх сурвалж, кэшийн бусад функц:
[`mn_cache_dir()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_cache_dir.md),
[`mn_sources()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_sources.md)

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
