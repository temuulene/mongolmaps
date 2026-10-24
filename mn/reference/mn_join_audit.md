# Газрын зурагтай нэгтгэсэн мөр бүрийн шийдвэрийг шалгах

[`mn_join()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_join.md)-ийн
анхны оролтын мөр бүрийн тааруулалт, нөхөлт болон хасагдсан шалтгааныг
харуулна.

## Usage

``` r
mn_join_audit(x)
```

## Arguments

- x:

  [`mn_join()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_join.md)-ээс
  буцсан объект.

## Value

Анхны мөрийн дугаар, оролтын утга, хэвийн түлхүүр, эцэг код, таарсан
код, арга, засварын зай, боломжит нэгж болон `action`-ыг агуулсан
tibble.

## See also

Өгөгдөл холбох бусад:
[`mn_example_population`](https://temuulene.github.io/mongolmaps/mn/reference/mn_example_population.md),
[`mn_join()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_join.md)

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
