# mn_roads() filters by class and place

    Code
      mn_roads(class = "highway")
    Condition
      Error in `mn_roads()`:
      ! `class` must be one of "main", "minor", "track", "path", or "all", not "highway".

# places without a boundary cannot be used to clip layers

    Code
      mn_roads(within = "MN6770")
    Condition
      Error in `mn_roads()`:
      ! `within` names places without a boundary: "MN6770".

