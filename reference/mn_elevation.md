# Elevation and hillshade

Terrain rasters for Mongolia from the Copernicus DEM GLO-90.

## Usage

``` r
mn_elevation(
  resolution = c("1km", "90m"),
  within = NULL,
  mask = TRUE,
  crs = NULL
)

mn_hillshade(
  resolution = c("1km", "90m"),
  within = NULL,
  mask = TRUE,
  angle = 40,
  direction = 315,
  crs = NULL
)
```

## Arguments

- resolution:

  `"1km"` or `"90m"`.

- within:

  Area to return (names or codes). Required for the online resolutions:
  `"90m"` elevation and `"10m"` land cover.

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

- angle, direction:

  Sun elevation and direction (degrees) for the hillshade.

## Value

A `terra` SpatRaster: elevation in metres, or hillshade values between 0
and 1.

## Details

- `resolution = "1km"` (default): a national grid in the Albers
  projection, downloaded once (about 5 MB) and cached.

- `resolution = "90m"`: the original 90 m data, read directly from the
  cloud for the area in `within` (an aimag or smaller). Nothing is
  cached.

`mn_hillshade()` computes shaded relief from the elevation, for a
background under other layers.

## Source

Copernicus DEM GLO-90, (c) DLR e.V. 2010-2014 and (c) Airbus Defence and
Space GmbH 2014-2018, provided under COPERNICUS by the European Union
and ESA. Free to use with attribution.

## See also

Other raster layers:
[`mn_landcover()`](https://temuulene.github.io/mongolmaps/reference/mn_landcover.md),
[`mn_population()`](https://temuulene.github.io/mongolmaps/reference/mn_population.md),
[`mn_zonal()`](https://temuulene.github.io/mongolmaps/reference/mn_zonal.md)

## Examples

``` r
elev <- mn_elevation()
#> ℹ Downloading Elevation, 1 km (Copernicus DEM) (4.1 MB); this happens once.
terra::plot(elev)

ub <- mn_elevation("90m", within = "Ulaanbaatar")
terra::plot(mn_hillshade(within = "Khovd"), col = grey.colors(100), legend = FALSE)
```
