# mongolmaps 0.2.0

* Raster summaries now use fractional cell coverage by default; empty coverage
  returns NA. Median extraction explicitly requires exact = FALSE. Population
  export reprojection preserves the retained native-grid total and records its
  normalization; native-grid extraction remains recommended for analysis.
* Joins respect global geographic scope during matching and level detection.
  Ulaanbaatar region/capital records are reconciled within statistical strata,
  with explicit value columns, conflict policies and inspectable row decisions.
* Added strict joins, duplicate-key controls, detailed name matching and
  `mn_join_audit()`.
* Bag imports dissolve multipart records, measure areas, check whole-polygon
  nesting and refresh after file changes. Registered bags also work as clipping
  targets and appear as available in the code dictionary.
* Added `mn_provenance()`, `mn_vintages()` and boundary-version validation.
  The catalog reports the available snapshot honestly; no historical geometry
  has been added. Thematic captions and leaflet credits use source metadata.
* Cache downloads are verified and replaced with rollback on publication
  failure. Failed protected-area refreshes retain valid cached data. Archive
  extraction is checked; old revisions are retained until explicitly cleared.
* Added `mn_assets()`, WorldPop asset prefetch/clearing and
  `mn_cache_verify()`. Partial cloud-tile coverage errors by default.
* Added `mn_inset_ub()`, `mn_map_ub()`, shared map limits/breaks, binned and
  diverging polygon scales, `mn_ub_grid` and `mn_erase_water()`. Insets preserve
  analytical coordinates, and large raster maps limit display work before
  reprojection.
* Added an audited-workflows guide and corrected boundary source, CRS and
  generalized land-cover descriptions. The minimum dplyr version is 1.1.1.

* `mn_join()` fills missing Ulaanbaatar values from NSO region code 5 when
  capital code 511 is empty or absent. Conflicting values prefer the capital
  row by default with a warning; `ub_policy` makes the decision explicit.
* The package has a hex logo.

# mongolmaps 0.1.0

* First CRAN release.
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
