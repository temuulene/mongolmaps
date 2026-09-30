# mn_cache_list() and mn_cache_clear() manage files

    Code
      mn_cache_clear("admin_high")
    Message
      v Removed 2 cached items.

# old data versions are pruned

    Code
      mn_cache_clear(old_versions = TRUE)
    Message
      i Removed cached data from older versions (0.0 MB).

# mn_download() rejects unknown layers and fetches known ones

    Code
      mn_download("nope")
    Condition
      Error in `mn_download()`:
      ! Unknown downloadable layer: "nope".
      i Downloadable layers: "admin_high", "osm_roads", "osm_transport", "osm_water", "osm_places", "elevation_1km", "landcover_1km", and "wdpa".

