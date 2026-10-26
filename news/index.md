# Changelog

## mongolmaps (development version)

- Fixed shifted raster pixels across empty rows or columns, including
  terrain maps of detached Ulaanbaatar districts. Empty cells remain
  transparent.
- Reworked all English and Mongolian guides with clearer examples,
  readable legends, complete district charts and an interactive khoroo
  map. Website builds now check figures, image files, article links and
  unexpected warnings.

## mongolmaps 0.2.0

CRAN release: 2026-10-25

- Raster summaries now use fractional cell coverage by default; empty
  coverage returns NA. Median extraction explicitly requires exact =
  FALSE. Population export reprojection preserves the retained
  native-grid total and records its normalization; native-grid
  extraction remains recommended for analysis.

- Joins respect global geographic scope during matching and level
  detection. Ulaanbaatar region/capital records are reconciled within
  statistical strata, with explicit value columns, conflict policies and
  inspectable row decisions.

- Added strict joins, duplicate-key controls, detailed name matching and
  [`mn_join_audit()`](https://temuulene.github.io/mongolmaps/reference/mn_join_audit.md).

- Bag imports dissolve multipart records, measure areas, check
  whole-polygon nesting and refresh after file changes. Registered bags
  also work as clipping targets and appear as available in the code
  dictionary.

- Added
  [`mn_provenance()`](https://temuulene.github.io/mongolmaps/reference/mn_provenance.md),
  [`mn_vintages()`](https://temuulene.github.io/mongolmaps/reference/mn_provenance.md)
  and boundary-version validation. The catalog reports the available
  snapshot honestly; no historical geometry has been added. Thematic
  captions and leaflet credits use source metadata.

- Cache downloads are verified and replaced with rollback on publication
  failure. Failed protected-area refreshes retain valid cached data.
  Archive extraction is checked; old revisions are retained until
  explicitly cleared.

- Added
  [`mn_assets()`](https://temuulene.github.io/mongolmaps/reference/mn_cache_dir.md),
  WorldPop asset prefetch/clearing and
  [`mn_cache_verify()`](https://temuulene.github.io/mongolmaps/reference/mn_cache_dir.md).
  Partial cloud-tile coverage errors by default.

- Added
  [`mn_inset_ub()`](https://temuulene.github.io/mongolmaps/reference/mn_inset_ub.md),
  [`mn_map_ub()`](https://temuulene.github.io/mongolmaps/reference/mn_inset_ub.md),
  shared map limits/breaks, binned and diverging polygon scales,
  `mn_ub_grid` and
  [`mn_erase_water()`](https://temuulene.github.io/mongolmaps/reference/mn_erase_water.md).
  Insets preserve analytical coordinates, and large raster maps limit
  display work before reprojection.

- Added an audited-workflows guide and corrected boundary source, CRS
  and generalized land-cover descriptions. The minimum dplyr version is
  1.1.1.

- [`mn_join()`](https://temuulene.github.io/mongolmaps/reference/mn_join.md)
  fills missing Ulaanbaatar values from NSO region code 5 when capital
  code 511 is empty or absent. Conflicting values prefer the capital row
  by default with a warning; `ub_policy` makes the decision explicit.

- The package has a hex logo.

## mongolmaps 0.1.0

CRAN release: 2026-10-10

- First CRAN release.
- Boundaries at every open level, with a shared set of columns:
  [`mn_country()`](https://temuulene.github.io/mongolmaps/reference/mn_country.md),
  [`mn_regions()`](https://temuulene.github.io/mongolmaps/reference/mn_country.md),
  [`mn_aimags()`](https://temuulene.github.io/mongolmaps/reference/mn_aimags.md),
  [`mn_soums()`](https://temuulene.github.io/mongolmaps/reference/mn_soums.md)
  (including Ulaanbaatar districts),
  [`mn_ub()`](https://temuulene.github.io/mongolmaps/reference/mn_ub.md),
  [`mn_ub_districts()`](https://temuulene.github.io/mongolmaps/reference/mn_ub.md)
  and
  [`mn_khoroos()`](https://temuulene.github.io/mongolmaps/reference/mn_ub.md),
  all built on
  [`mn_admin()`](https://temuulene.github.io/mongolmaps/reference/mn_admin.md).
  Simplified boundaries ship with the package; `resolution = "high"`
  downloads full-resolution ones once.
- Bag level ready for NSO data:
  [`mn_bags()`](https://temuulene.github.io/mongolmaps/reference/mn_bags.md)
  and
  [`mn_read_bags()`](https://temuulene.github.io/mongolmaps/reference/mn_bags.md)
  read and check a bag boundary file, and codes and names of all bags
  are built in.
- Names and codes:
  [`mn_match()`](https://temuulene.github.io/mongolmaps/reference/mn_match.md)
  resolves English spellings, Cyrillic, NSO codes, ISO 3166-2 codes and
  P-codes;
  [`mn_codes()`](https://temuulene.github.io/mongolmaps/reference/mn_codes.md)
  lists every unit;
  [`mn_translit()`](https://temuulene.github.io/mongolmaps/reference/mn_translit.md)
  romanises Mongolian Cyrillic (MNS 5217 or NSO style).
- [`mn_join()`](https://temuulene.github.io/mongolmaps/reference/mn_join.md)
  joins data to boundaries in one step, detecting the level and dropping
  totals from NSO tables.
- Mapping:
  [`mn_map()`](https://temuulene.github.io/mongolmaps/reference/mn_map.md)
  and
  [`theme_mn()`](https://temuulene.github.io/mongolmaps/reference/theme_mn.md)
  for ggplot2,
  [`mn_leaflet()`](https://temuulene.github.io/mongolmaps/reference/mn_leaflet.md)
  for interactive maps,
  [`mn_label_points()`](https://temuulene.github.io/mongolmaps/reference/mn_label_points.md),
  [`mn_crs()`](https://temuulene.github.io/mongolmaps/reference/mn_crs.md)
  and the `mn_aimag_grid` layout for geofacet.
- Thematic layers:
  [`mn_settlements()`](https://temuulene.github.io/mongolmaps/reference/mn_settlements.md),
  [`mn_neighbours()`](https://temuulene.github.io/mongolmaps/reference/mn_neighbours.md),
  [`mn_rivers()`](https://temuulene.github.io/mongolmaps/reference/mn_neighbours.md)
  and
  [`mn_lakes()`](https://temuulene.github.io/mongolmaps/reference/mn_neighbours.md)
  (major features bundled, all OpenStreetMap features with
  `detail = "all"`), and
  [`mn_roads()`](https://temuulene.github.io/mongolmaps/reference/mn_roads.md),
  [`mn_railways()`](https://temuulene.github.io/mongolmaps/reference/mn_roads.md),
  [`mn_airports()`](https://temuulene.github.io/mongolmaps/reference/mn_roads.md)
  and
  [`mn_places()`](https://temuulene.github.io/mongolmaps/reference/mn_roads.md)
  from OpenStreetMap, downloaded once and cached.
- Rasters (with terra):
  [`mn_elevation()`](https://temuulene.github.io/mongolmaps/reference/mn_elevation.md)
  and
  [`mn_hillshade()`](https://temuulene.github.io/mongolmaps/reference/mn_elevation.md)
  (Copernicus DEM, 1 km national or 90 m by area),
  [`mn_landcover()`](https://temuulene.github.io/mongolmaps/reference/mn_landcover.md)
  (ESA WorldCover, 1 km or 10 m),
  [`mn_population()`](https://temuulene.github.io/mongolmaps/reference/mn_population.md)
  (WorldPop 2015-2030, 1 km or 100 m) and
  [`mn_zonal()`](https://temuulene.github.io/mongolmaps/reference/mn_zonal.md)
  to summarise them over any map units.
  [`mn_map()`](https://temuulene.github.io/mongolmaps/reference/mn_map.md)
  draws rasters as well as polygons.
- [`mn_protected_areas()`](https://temuulene.github.io/mongolmaps/reference/mn_protected_areas.md)
  downloads the World Database on Protected Areas.
- Data sources and cache:
  [`mn_sources()`](https://temuulene.github.io/mongolmaps/reference/mn_sources.md),
  [`mn_citation()`](https://temuulene.github.io/mongolmaps/reference/mn_sources.md),
  [`mn_download()`](https://temuulene.github.io/mongolmaps/reference/mn_cache_dir.md)
  (layer ids or groups such as `"osm"`),
  [`mn_cache_dir()`](https://temuulene.github.io/mongolmaps/reference/mn_cache_dir.md),
  [`mn_cache_list()`](https://temuulene.github.io/mongolmaps/reference/mn_cache_dir.md)
  and
  [`mn_cache_clear()`](https://temuulene.github.io/mongolmaps/reference/mn_cache_dir.md).
- Example data: `mn_example_population`.
