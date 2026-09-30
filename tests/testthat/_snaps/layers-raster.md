# 90 m elevation needs a small area

    Code
      mn_elevation("90m")
    Condition
      Error in `mn_elevation()`:
      ! 90 m elevation is read for one area at a time: give `within`.
      i For the whole country, use `resolution = "1km"`.

---

    Code
      .mm_check_tiles(40, 16, "90 m elevation")
    Condition
      Error:
      ! The area is too large for 90 m elevation (40 tiles; the limit is 16).
      i Choose a smaller `within` or use `resolution = "1km"`.

---

    Code
      mn_landcover("10m", within = "Khovd")
    Condition
      Error in `mn_landcover()`:
      ! The area is too large for 10 m land cover (76061 km2; the limit is 6000 km2).
      i Choose a soum or district for `within`, or use `resolution = "1km"`.

# remote reads stop cleanly when offline

    Code
      .mm_remote_mosaic("https://example.org/a.tif", NULL, "elevation")
    Condition
      Error:
      ! Can't read elevation data: no internet connection or offline mode is on.

# mn_population() checks the year and downloads the right file

    Code
      mn_population(2014)
    Condition
      Error in `mn_population()`:
      ! `year` must be a single year from 2015 to 2030.

# mn_zonal() summarises a raster over polygons

    Code
      mn_zonal("r")
    Condition
      Error in `mn_zonal()`:
      ! `r` must be a <SpatRaster>, not a string.

---

    Code
      mn_zonal(r, data.frame(a = 1))
    Condition
      Error in `mn_zonal()`:
      ! `x` must be an <sf> object, not a data frame.

# mn_protected_areas() downloads, caches and clips

    Code
      x <- mn_protected_areas()
    Message
      i The WDPA is for non-commercial use with attribution and may not be redistributed; see `?mongolmaps::mn_protected_areas()`.
      This message is displayed once per session.

