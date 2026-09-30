# Reconcile the khoroo polygons (GitHub Tuvshin-Level/khoroo-map, 0BSD) into
# a clean tiling of Ulaanbaatar.
#
# The outer UB boundary comes from COD, so UB fits the national layers. The
# internal district and khoroo lines come from the khoroo data, which is newer
# than COD (2020) and follows current district lines in the city centre.
# Overlaps are removed and holes are given to the neighbouring khoroo with
# the longest shared edge. UB districts are then the union of their khoroos.
# All geometry work is in UTM 48N.

source("data-raw/00_config.R")
sf_use_s2(FALSE)

cod <- readRDS(build_path("cod.rds"))
units <- readRDS(build_path("units.rds"))
empty_poly <- st_sfc(st_polygon(), crs = crs_utm)

records <- jsonlite::fromJSON(raw_path("khoroo", "khoroos.json"), simplifyVector = FALSE)
fc <- list(
  type = "FeatureCollection",
  features = map(records, \(r) list(
    type = "Feature",
    properties = list(district = r$district, khoroo = r$khoroo, number = r$khoroo_number),
    geometry = r$geometry
  ))
)
kh <- st_read(jsonlite::toJSON(fc, auto_unbox = TRUE, digits = NA), quiet = TRUE) |>
  st_set_crs(4326)
check(nrow(kh) == 204, "Expected 204 khoroos")

districts <- units |> filter(level == "soum", aimag_pcode == "MN11")
kh$district_pcode <- districts$pcode[match(.mm_key(kh$district), .mm_key(districts$name_mn))]
check(!anyNA(kh$district_pcode), "Every khoroo district must match an NSO district")

nso_kh <- units |> filter(type == "khoroo") |> select(pcode, parent_pcode, number)
kh <- kh |> left_join(nso_kh, by = join_by(district_pcode == parent_pcode, number))
check(!anyNA(kh$pcode), "Every khoroo must match an NSO khoroo code")
check(setequal(kh$pcode, nso_kh$pcode), "Khoroo polygons and NSO khoroo codes must match one to one")

kh <- kh |>
  select(pcode, district_pcode, number) |>
  arrange(pcode) |>
  st_transform(crs_utm) |>
  st_make_valid()
kh$area_orig_km2 <- as.numeric(st_area(kh)) / 1e6

ub <- cod$adm1 |> filter(pcode == "MN11") |> st_transform(crs_utm) |> st_geometry()

as_poly <- function(g) {
  if (length(g) == 0 || all(st_is_empty(g))) return(empty_poly)
  if (any(st_geometry_type(g) == "GEOMETRYCOLLECTION")) g <- st_collection_extract(g, "POLYGON")
  g <- g[st_geometry_type(g) %in% c("POLYGON", "MULTIPOLYGON")]
  if (length(g) == 0) empty_poly else st_union(g)
}

# 1. Snap onto the UB outline and clip to it.
st_geometry(kh) <- st_snap(st_geometry(kh), st_boundary(ub), tolerance = 25)
kh <- st_make_valid(kh)
st_geometry(kh) <- do.call(c, map(st_geometry(kh), \(g) as_poly(st_intersection(st_sfc(g, crs = crs_utm), ub))))

# 2. Remove overlaps: lower codes keep contested area.
taken <- empty_poly
for (i in seq_len(nrow(kh))) {
  g <- st_geometry(kh)[i]
  if (!st_is_empty(taken)) g <- as_poly(st_difference(g, taken))
  st_geometry(kh)[i] <- g
  taken <- st_union(c(taken, g))
}

# 3. Fill holes: each hole joins the neighbour with the longest shared edge,
# preferring neighbours from the district that surrounds it most.
holes <- st_difference(ub, st_union(st_geometry(kh)))
holes <- st_cast(holes, "POLYGON")
holes <- holes[as.numeric(st_area(holes)) > 0]
message("Holes to fill: ", length(holes), " (", round(sum(as.numeric(st_area(holes))) / 1e6, 3), " km2)")

owner <- map_int(seq_along(holes), function(j) {
  g <- holes[j]
  near <- which(lengths(st_intersects(st_geometry(kh), st_buffer(g, 1))) > 0)
  if (!length(near)) return(st_nearest_feature(g, st_geometry(kh)))
  if (length(near) == 1) return(near)
  edge <- st_boundary(g)
  shared <- map_dbl(near, \(i) sum(as.numeric(st_length(st_intersection(edge, st_buffer(st_geometry(kh)[i], 1))))))
  near[which.max(shared)]
})
for (r in unique(owner)) {
  st_geometry(kh)[r] <- st_union(c(st_geometry(kh)[r], holes[owner == r]))
}

kh <- st_make_valid(kh) |> st_cast("MULTIPOLYGON")
kh$area_final_km2 <- as.numeric(st_area(kh)) / 1e6
kh$pct_change <- round(100 * (kh$area_final_km2 - kh$area_orig_km2) / kh$area_orig_km2, 2)

recon <- kh |>
  st_drop_geometry() |>
  mutate(across(c(area_orig_km2, area_final_km2), \(x) round(x, 4))) |>
  select(pcode, district_pcode, number, area_orig_km2, area_final_km2, pct_change)
utils::write.csv(recon, "data-raw/khoroo_reconciliation.csv", row.names = FALSE)

# Two edge khoroos (Baganuur 2, Khan-Uul 11) move 10-12% because COD draws
# the outer UB line differently; anything larger needs a manual look.
big <- recon |> filter(abs(pct_change) > 15)
if (nrow(big)) print(big)
check(nrow(big) == 0, "Some khoroos changed area by more than 15%")

# UB districts are the union of their khoroos.
ub_districts <- kh |>
  group_by(pcode = district_pcode) |>
  summarise(geometry = st_union(geometry), .groups = "drop") |>
  st_make_valid() |>
  st_cast("MULTIPOLYGON")

cod_d <- cod$adm2 |> filter(pcode %in% districts$pcode) |> st_transform(crs_utm)
dist_cmp <- map_dfr(seq_len(nrow(ub_districts)), function(i) {
  a <- st_geometry(ub_districts)[i]
  b <- st_geometry(cod_d)[cod_d$pcode == ub_districts$pcode[i]]
  tibble(
    pcode = ub_districts$pcode[i],
    cod_km2 = round(km2(b), 3),
    final_km2 = round(km2(a), 3),
    symdiff_km2 = round(km2(st_sym_difference(a, b)), 3)
  )
})
utils::write.csv(dist_cmp, "data-raw/ub_district_reconciliation.csv", row.names = FALSE)
print(dist_cmp)
check(nrow(dist_cmp) == 9, "Expected 9 UB districts")

tiling <- km2(st_sym_difference(st_union(st_geometry(ub_districts)), ub))
message("UB outline vs union of districts: ", signif(tiling, 3), " km2")
check(tiling < 0.01, "UB districts must tile the UB outline")

saveRDS(list(khoroo = kh |> select(pcode), ub_district = ub_districts), build_path("ub_utm.rds"))
message("Khoroos reconciled; median |change| ", median(abs(recon$pct_change)), "%, max ", max(abs(recon$pct_change)), "%")
