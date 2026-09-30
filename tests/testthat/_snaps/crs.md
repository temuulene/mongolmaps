# mn_crs() returns Mongolia projections

    Code
      mn_crs("mercator")
    Condition
      Error in `mn_crs()`:
      ! `type` must be one of "albers", "lcc", "utm", or "wgs84", not "mercator".

# .mm_resolve_crs() handles NULL, keywords and bad input

    Code
      .mm_resolve_crs(NA)
    Condition
      Error:
      ! `crs` must be "albers", "lcc", "utm", "wgs84", an EPSG code or an <crs>.
      x Could not interpret `NA`.

