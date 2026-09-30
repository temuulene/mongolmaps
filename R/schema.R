# Every admin getter returns the same columns in the same order.
.mm_schema <- c(
  "pcode", "name", "name_en", "name_mn", "name_mns", "level", "type", "number",
  "iso_code", "nso_code", "parent_pcode", "region_pcode", "aimag_pcode", "soum_pcode", "area_km2"
)

.mm_name_for_lang <- function(x, lang) {
  switch(lang,
    en = x$name_en,
    mn = x$name_mn,
    mns = x$name_mns
  )
}

# Attaches the unit attributes to geometry (an sf with a `pcode` column) and
# returns an sf tibble in schema order.
.mm_as_mn_sf <- function(geom, lang = "en", units = .mm_units) {
  attrs <- units[match(geom$pcode, units$pcode), setdiff(.mm_schema, "name")]
  attrs$pcode <- geom$pcode
  attrs$name <- .mm_name_for_lang(attrs, lang)
  attrs <- tibble::as_tibble(attrs[.mm_schema])
  attrs$geometry <- sf::st_geometry(geom)
  sf::st_as_sf(attrs, sf_column_name = "geometry")
}

# TRUE where the unit lies inside one of `targets` (or is one of them, when
# `include_self` is TRUE).
.mm_in_targets <- function(pcodes, targets, include_self = TRUE, units = .mm_units) {
  u <- units[match(pcodes, units$pcode), ]
  inside <- u$parent_pcode %in% targets |
    (u$region_pcode %in% targets & u$region_pcode != pcodes) |
    (u$aimag_pcode %in% targets & u$aimag_pcode != pcodes) |
    (u$soum_pcode %in% targets & u$soum_pcode != pcodes) |
    ("MN" %in% targets & pcodes != "MN")
  inside <- inside %in% TRUE
  if (include_self) inside <- inside | pcodes %in% targets
  inside
}

# Bundled layers keep the CRS definition written by the PROJ version that
# built them, which differs between systems. Re-stamp EPSG:4326 from the local
# PROJ (coordinates are unchanged) so CRS comparisons hold everywhere.
.mm_bundled <- function(x) {
  sf::st_geometry(x) <- sf::st_set_crs(sf::st_set_crs(sf::st_geometry(x), NA), 4326)
  x
}
