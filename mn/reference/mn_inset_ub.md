# Улаанбаатарыг томруулсан үндэсний болон хотын зураг

Шинжилгээний координатыг шилжүүлэхгүйгээр энгийн ggplot зургуудыг
patchwork-аар нэгтгэнэ. Панель бүр өнгөний ижил хязгаар болон таслах
цэгтэй боловч газарзүйн тусдаа масштабтай.

## Usage

``` r
mn_inset_ub(
  x = NULL,
  ub = NULL,
  fill = NULL,
  label = FALSE,
  title = NULL,
  limits = NULL,
  breaks = NULL,
  ...
)

mn_map_ub(
  x = NULL,
  fill = NULL,
  label = FALSE,
  title = NULL,
  limits = NULL,
  breaks = NULL,
  ...
)
```

## Arguments

- x:

  `mn_inset_ub()`-д улсын зураг; `mn_map_ub()`-д нийслэлийн дүүрэг эсвэл
  хорооны зураг. Анхдагчаар аймаг эсвэл дүүргийг авна.

- ub:

  Томруулах хотын өгөгдөл. Өгөөгүй бол `x`-ээс нийслэлийн нэгжийг
  сонгоно; байхгүй бол алдаа өгнө.

- fill:

  Өнгөөр харуулах багана эсвэл илэрхийлэл.

- label:

  Нэгжийн нэрийг бичих эсэх.

- title:

  Ерөнхий гарчиг.

- limits, breaks:

  Өнгөний нийтлэг хязгаар, тайлбарын таслах цэг.

- ...:

  [`mn_map()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_map.md)-д
  дамжуулах `lang`, `trans`, `bins`, `midpoint` зэрэг тохиргоо.

## Value

Нэмэлт patchwork багц шаарддаг patchwork объект. Оролтын геометр
өөрчлөгдөхгүй.

## See also

Газрын зураг зурах бусад функц:
[`mn_aimag_grid`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimag_grid.md),
[`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md),
[`mn_erase_water()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_erase_water.md),
[`mn_label_points()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_label_points.md),
[`mn_leaflet()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_leaflet.md),
[`mn_map()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_map.md),
[`mn_ub_grid`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub_grid.md),
[`theme_mn()`](https://temuulene.github.io/mongolmaps/mn/reference/theme_mn.md)

## Examples

``` r
mn_inset_ub(fill = area_km2)

mn_map_ub(fill = area_km2)
```
