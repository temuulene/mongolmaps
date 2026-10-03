# Changelog

## mongolmaps 0.1.0

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
  totals from NSO tables. Ulaanbaatar’s values come from the Ulaanbaatar
  region row (code 5) when a table leaves the capital’s own row
  511. empty or out, as many NSO health tables do.
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
