# Тусгай хамгаалалттай газар

Дэлхийн тусгай хамгаалалттай газрын мэдээллийн сангаас (WDPA) Монгол
Улсын байгалийн цогцолборт газар, дархан цаазат газар болон бусад
хамгаалалттай газар. Өгөгдлийг анх удаа UNEP-WCMC-ээс татаж, 90 хоногийн
дараа шинэчилнэ; дахин тараах эрхгүй тул багцад хэзээ ч орохгүй.

## Usage

``` r
mn_protected_areas(within = NULL, refresh = FALSE, crs = NULL)
```

## Arguments

- within:

  Зөвхөн эдгээр газар доторх хэсгийг үлдээнэ (нэр эсвэл код).

- refresh:

  `TRUE` бол одоо дахин татна.

- crs:

  Үр дүнгийн координатын систем. `NULL` (анхдагч) бол уртраг, өргөрөг
  (EPSG:4326) хэвээр. Монголд тохирсон проекцод `"albers"`, `"lcc"`
  эсвэл `"utm"`-ийг
  ([`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md)-ийг
  үзнэ үү), эсвэл
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html)-ийн
  хүлээн авах дурын утгыг өгнө.

## Value

WDPA-гийн шинжүүдтэй `sf` tibble, үүнд `name_eng`, `desig_eng`
(ангилал), `iucn_cat`, `status_yr` багтана.

## Ашиглах нөхцөл

UNEP-WCMC and IUCN, Protected Planet: The World Database on Protected
Areas (WDPA), Cambridge, UK.
<https://www.protectedplanet.net/en/legal>-ийг үзнэ үү. WDPA-г арилжааны
бус зорилгоор эх сурвалжийг дурдан ашиглаж болно; дахин тарааж болохгүй.

## See also

Сэдэвчилсэн бусад давхарга:
[`mn_neighbours()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_neighbours.md),
[`mn_roads()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_roads.md),
[`mn_settlements()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_settlements.md)

## Examples

``` r
pa <- mn_protected_areas()
mn_map(pa, fill = desig_eng)
```
