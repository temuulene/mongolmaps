# Land cover

Land cover from ESA WorldCover 2021, in 11 classes such as grassland,
bare ground, cropland and built-up areas. The result is a categorical
raster with class names and the official colours, so
[`terra::plot()`](https://rspatial.github.io/terra/reference/plot.html)
draws it with a legend.

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

  `"1km"` or `"10m"`.

- within:

  Area to return (names or codes). Required for `"90m"`.

- mask:

  If `TRUE` (default), cells outside Mongolia (or outside `within`) are
  set to `NA`.

- crs:

  Coordinate reference system of the result. `NULL` (default) keeps
  longitude/latitude (EPSG:4326). Use `"albers"`, `"lcc"` or `"utm"` for
  a projection suited to Mongolia (see
  [`mn_crs()`](https://temuulene.github.io/mongolmaps/reference/mn_crs.md)),
  or any value accepted by
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html).

## Value

A categorical `terra` SpatRaster.

## Details

- `resolution = "1km"` (default): national grid, majority class of each
  square kilometre, downloaded once (about 2 MB).

- `resolution = "10m"`: the original 10 m data for the area in `within`
  (a soum, district or smaller aimag), read from the cloud.

## Source

ESA WorldCover 10 m 2021 v200, (c) ESA WorldCover project / contains
modified Copernicus Sentinel data (2021) processed by the ESA WorldCover
consortium. CC BY 4.0.

## See also

Other raster layers:
[`mn_elevation()`](https://temuulene.github.io/mongolmaps/reference/mn_elevation.md),
[`mn_population()`](https://temuulene.github.io/mongolmaps/reference/mn_population.md),
[`mn_zonal()`](https://temuulene.github.io/mongolmaps/reference/mn_zonal.md)

## Examples

``` r
lc <- mn_landcover()
#> ℹ Downloading Land cover, 1 km (ESA WorldCover 2021) (0.3 MB); this happens
#>   once.
terra::plot(lc)

terra::plot(mn_landcover("10m", within = "Nalaikh"))
```
