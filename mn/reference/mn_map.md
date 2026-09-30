# ggplot2-оор Монголын газрын зургийг хурдан зурах

Багцын дурын газрын зураг, эсвэл өөрийн өгөгдөлтэй холбосон газрын
зургийг тохиромжтой анхдагч тохиргоотой зурна: Монголд тохирсон проекц,
өнгөний харалган хүмүүст ялгагдах өнгөний хуваарь, өгөгдөлгүй газарт
саарал өнгө, нэр, эргэн тойрныг сонголтоор, өгөгдлийн эх сурвалжийг
тайлбар мөрөөр. Үр дүн нь энгийн ggplot тул давхарга, хуваарь, загвар
нэмж болно.

## Usage

``` r
mn_map(
  x = NULL,
  fill = NULL,
  trans = "identity",
  label = FALSE,
  context = FALSE,
  crs = NULL,
  lang = NULL,
  caption = TRUE,
  title = NULL,
  label_size = 2.6
)
```

## Arguments

- x:

  `sf` объект, ихэвчлэн
  [`mn_aimags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimags.md),
  [`mn_soums()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_soums.md),
  [`mn_khoroos()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub.md)
  эсвэл
  [`mn_join()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_join.md)-ийн
  үр дүн, эсвэл
  [`mn_elevation()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_elevation.md),
  [`mn_landcover()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_landcover.md),
  [`mn_population()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_population.md)
  зэрэг `terra` растер. Анхдагч нь аймгууд.

- fill:

  Олигоныг будах багана (хашилтгүй), эсвэл `"steelblue"` гэх мэт нэг
  өнгө. Тоонд тасралтгүй viridis хуваарь, тэмдэгт мөр ба factor-т
  салангид хуваарь өгнө.

- trans:

  Тоон `fill` хуваарийн хувиргалт, жишээ нь `"log10"`, `"sqrt"`.
  Улаанбаатар бусдыг дарах үед хэрэгтэй.

- label:

  `TRUE` бол нэгж бүрийг нэрээр (хороог дугаараар) нь тэмдэглэнэ, эсвэл
  тэмдэглэх хашилтгүй баганыг өгнө.

- context:

  `TRUE` бол газрын зургийн эргэн тойронд хөрш орнууд, томоохон гол,
  нуурыг зурна.

- crs:

  Проекц. `NULL` бол автоматаар сонгоно: улс эсвэл түүний томоохон
  хэсэгт Альберсийн тэнцүү талбайт проекц, Улаанбаатар болон төвийн
  бүсийн жижиг газарт UTM-ийн 48N бүс.
  [`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md)-ийг
  үзнэ үү.

- lang:

  `label = TRUE` үеийн нэрийн хэл: `"en"`, `"mn"` эсвэл `"mns"`.

- caption:

  `TRUE` бол
  [`mn_citation()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_sources.md)-аас
  өгөгдлийн эх сурвалжийг нэмнэ; `FALSE` бол нэмэхгүй; тэмдэгт мөр өгвөл
  түүнийг хэвээр ашиглана.

- title:

  Зургийн гарчиг (заавал биш).

- label_size:

  Нэрийн бичгийн хэмжээ.

## Value

`ggplot` объект.

## See also

Газрын зураг зурах бусад функц:
[`mn_aimag_grid`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimag_grid.md),
[`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md),
[`mn_label_points()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_label_points.md),
[`mn_leaflet()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_leaflet.md),
[`theme_mn()`](https://temuulene.github.io/mongolmaps/mn/reference/theme_mn.md)

## Examples

``` r
mn_map()

mn_map(mn_aimags(), fill = area_km2, label = TRUE)

mn_map(mn_khoroos(district = "Bayangol"), label = TRUE)


pop <- mn_example_population[mn_example_population$Year == 2025, ]
pop_map <- mn_join(pop, "Region", level = "aimag")
#> ℹ Joining at the aimag level; dropped 6 rows for larger units ("country" and
#>   "region") and 2196 rows for smaller units ("soum" and "bag").
mn_map(pop_map, fill = value, trans = "log10", title = "Population, 2025")

mn_map(mn_landcover())

mn_map(mn_elevation()) + ggplot2::geom_sf(data = mn_aimags(), fill = NA, colour = "white")
```
