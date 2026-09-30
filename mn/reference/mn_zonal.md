# Растерийг газрын зургийн нэгжээр нэгтгэх

`x`-д нэгж бүр доторх растерийн нүдний нэгтгэлийг шинэ баганаар нэмнэ,
жишээ нь сум бүрийн нийт хүн ам, аймаг бүрийн дундаж өндөршил.

## Usage

``` r
mn_zonal(
  r,
  x = NULL,
  fun = c("sum", "mean", "min", "max", "median"),
  name = "value"
)
```

## Arguments

- r:

  `terra` SpatRaster (нэг давхаргатай), жишээ нь
  [`mn_population()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_population.md)-ийн
  үр дүн.

- x:

  Олигоны `sf` объект, жишээ нь
  [`mn_soums()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_soums.md).
  Анхдагч нь аймгууд.

- fun:

  Нэгтгэх функцийн нэр: `"sum"` (анхдагч), `"mean"`, `"min"`, `"max"`
  эсвэл `"median"`.

- name:

  Шинэ баганын нэр.

## Value

Шинэ баганатай `x`.

## See also

Растерийн бусад давхарга:
[`mn_elevation()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_elevation.md),
[`mn_landcover()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_landcover.md),
[`mn_population()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_population.md)

## Examples

``` r
soum_pop <- mn_zonal(mn_population(2025), mn_soums(), name = "population")
mn_map(soum_pop, fill = population / area_km2, trans = "log10")
```
