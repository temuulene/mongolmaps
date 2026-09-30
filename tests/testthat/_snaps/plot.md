# mn_map() validates `x`

    Code
      mn_map(data.frame(a = 1))
    Condition
      Error in `mn_map()`:
      ! `x` must be an <sf> object or a <SpatRaster>, not a data frame.

# mn_label_points() uses precomputed points and falls back

    Code
      mn_label_points(1)
    Condition
      Error in `mn_label_points()`:
      ! `x` must be an <sf> object, not a number.

