# Газрын бүрхэвч

ESA WorldCover 2021-ийн газрын бүрхэвч, бэлчээр, ил хөрс, тариалан,
барилгажсан талбай зэрэг 11 ангилалтай. Үр дүн нь ангиллын нэр, албан
ёсны өнгөтэй ангиллын растер тул
[`terra::plot()`](https://rspatial.github.io/terra/reference/plot.html)
үүнийг тайлбартай нь зурна.

## Usage

``` r
mn_landcover(
  resolution = c("1km", "10m"),
  within = NULL,
  mask = TRUE,
  crs = NULL
)
```

## Arguments

- resolution:

  `"1km"` эсвэл `"10m"`.

- within:

  Буцаах газар (нэр эсвэл код). Онлайнаар уншдаг нарийвчлалд заавал
  өгнө: өндөршилд `"90m"`, газрын бүрхэвчид `"10m"`.

- mask:

  `TRUE` (анхдагч) бол Монголоос (эсвэл `within`-ээс) гадуурх нүдийг
  `NA` болгоно.

- crs:

  Үр дүнгийн координатын систем. `NULL` (анхдагч) бол уртраг, өргөрөг
  (EPSG:4326) хэвээр. Монголд тохирсон проекцод `"albers"`, `"lcc"`
  эсвэл `"utm"`-ийг
  ([`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md)-ийг
  үзнэ үү), эсвэл
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html)-ийн
  хүлээн авах дурын утгыг өгнө.

## Value

Ангиллын `terra` SpatRaster.

## Details

- `resolution = "1km"` (анхдагч): улсын тор, квадрат километр бүрийн
  зонхилох ангилал, нэг удаа (ойролцоогоор 2 МБ) татна.

- `resolution = "10m"`: `within` дахь газрын (сум, дүүрэг эсвэл жижиг
  аймаг) анхны 10 м-ийн өгөгдөл, үүлнээс уншина.

## Эх сурвалж

ESA WorldCover 10 m 2021 v200, (c) ESA WorldCover project / contains
modified Copernicus Sentinel data (2021) processed by the ESA WorldCover
consortium. CC BY 4.0.

## See also

Растерийн бусад давхарга:
[`mn_elevation()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_elevation.md),
[`mn_population()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_population.md),
[`mn_zonal()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_zonal.md)

## Examples

``` r
lc <- mn_landcover()
terra::plot(lc)

terra::plot(mn_landcover("10m", within = "Nalaikh"))
```
