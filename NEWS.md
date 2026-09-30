# mongolmaps 0.0.0.9000

* First version.
* Boundaries at every open level, with a shared set of columns: `mn_country()`,
  `mn_regions()`, `mn_aimags()`, `mn_soums()` (including Ulaanbaatar
  districts), `mn_ub()`, `mn_ub_districts()` and `mn_khoroos()`, all built on
  `mn_admin()`. Simplified boundaries ship with the package;
  `resolution = "high"` downloads full-resolution ones once.
* Bag level ready for NSO data: `mn_bags()` and `mn_read_bags()` read and
  check a bag boundary file, and codes and names of all bags are built in.
* Names and codes: `mn_match()` resolves English spellings, Cyrillic, NSO
  codes, ISO 3166-2 codes and P-codes; `mn_codes()` lists every unit;
  `mn_translit()` romanises Mongolian Cyrillic (MNS 5217 or NSO style).
* `mn_join()` joins data to boundaries in one step, detecting the level and
  dropping totals from NSO tables.
* Mapping: `mn_map()` and `theme_mn()` for ggplot2, `mn_leaflet()` for
  interactive maps, `mn_label_points()`, `mn_crs()` and the `mn_aimag_grid`
  layout for geofacet.
* Thematic layers: `mn_settlements()`, `mn_neighbours()`, `mn_rivers()` and
  `mn_lakes()` (major features bundled, all OpenStreetMap features with
  `detail = "all"`), and `mn_roads()`, `mn_railways()`, `mn_airports()` and
  `mn_places()` from OpenStreetMap, downloaded once and cached.
* Rasters (with terra): `mn_elevation()` and `mn_hillshade()` (Copernicus DEM,
  1 km national or 90 m by area), `mn_landcover()` (ESA WorldCover, 1 km or
  10 m), `mn_population()` (WorldPop 2015-2030, 1 km or 100 m) and
  `mn_zonal()` to summarise them over any map units. `mn_map()` draws
  rasters as well as polygons.
* `mn_protected_areas()` downloads the World Database on Protected Areas.
* Data sources and cache: `mn_sources()`, `mn_citation()`, `mn_download()`
  (layer ids or groups such as `"osm"`),
  `mn_cache_dir()`, `mn_cache_list()` and `mn_cache_clear()`.
* Example data: `mn_example_population`.
