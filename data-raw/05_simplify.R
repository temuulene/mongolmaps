# Build full-resolution and simplified ("low") boundary layers.
#
# Two topologies keep borders shared exactly after simplification:
# * national: 339 soums and UB districts, simplified once and dissolved
#   upwards into aimags, regions and the country;
# * Ulaanbaatar: 204 khoroos, simplified more gently and dissolved into
#   districts and the city outline.

source("data-raw/00_config.R")

keep_national <- as.numeric(Sys.getenv("MM_KEEP_NATIONAL", "0.2"))
keep_ub <- as.numeric(Sys.getenv("MM_KEEP_UB", "0.5"))

cod <- readRDS(build_path("cod.rds"))
ub <- readRDS(build_path("ub_utm.rds"))
units <- readRDS(build_path("units.rds"))
parents <- units |> select(pcode, aimag_pcode, region_pcode, parent_pcode)

to_wgs <- function(x) st_transform(x, 4326) |> st_make_valid() |> st_cast("MULTIPOLYGON")

# ---- Full resolution ---------------------------------------------------------

khoroo <- to_wgs(ub$khoroo) |> left_join(parents |> select(pcode, district_pcode = parent_pcode), by = "pcode")
ub_district <- to_wgs(ub$ub_district)
soum <- cod$adm2 |>
  select(pcode) |>
  filter(!pcode %in% ub_district$pcode) |>
  bind_rows(ub_district) |>
  left_join(parents, by = "pcode") |>
  arrange(pcode)
aimag <- cod$adm1 |> select(pcode) |> left_join(parents |> select(pcode, region_pcode), by = "pcode") |> arrange(pcode)
region <- aimag |>
  st_transform(crs_albers) |>
  group_by(pcode = region_pcode) |>
  summarise(geometry = st_union(geometry), .groups = "drop") |>
  to_wgs()
country <- cod$adm0 |> select(pcode)
ub_outline <- aimag |> filter(pcode == "MN11") |> select(pcode)

high <- list(
  country = country, region = region, aimag = select(aimag, pcode), soum = select(soum, pcode),
  ub = ub_outline, ub_district = select(ub_district, pcode), khoroo = select(khoroo, pcode)
)
high <- map(high, \(x) x |> st_make_valid() |> st_cast("MULTIPOLYGON"))

# Areas from full-resolution geometry in the Albers equal-area projection.
areas <- map(high[c("country", "region", "aimag", "soum", "khoroo")], \(x) {
  tibble(pcode = x$pcode, area_km2 = round(as.numeric(st_area(st_transform(x, crs_albers))) / 1e6, 3))
}) |> bind_rows()

# ---- Simplified --------------------------------------------------------------

simplify <- function(x, keep) {
  rmapshaper::ms_simplify(x, keep = keep, keep_shapes = TRUE, snap = TRUE, method = "vis", weighting = 0.7)
}
# Dissolving can leave pinhole gaps (a few m2) where simplified arcs meet;
# drop interior rings under 1 ha. Real enclaves (Orkhon inside Bulgan) are
# hundreds of km2 and stay.
drop_pinholes <- function(x, min_m2 = 1e4) {
  area_ok <- function(ring) {
    ring_sfc <- st_transform(st_sfc(st_polygon(list(ring)), crs = 4326), crs_albers)
    as.numeric(st_area(ring_sfc)) >= min_m2
  }
  fix_poly <- function(p) st_polygon(c(p[1], Filter(area_ok, p[-1])))
  geoms <- map(st_geometry(x), \(g) st_multipolygon(map(st_cast(st_sfc(g), "POLYGON"), fix_poly)))
  st_geometry(x) <- st_sfc(geoms, crs = st_crs(x))
  x
}
dissolve <- function(x, field) {
  out <- if (is.null(field)) rmapshaper::ms_dissolve(x) else rmapshaper::ms_dissolve(x, field = field)
  if (is.null(field)) out$pcode <- "MN"
  if (!is.null(field)) names(out)[names(out) == field] <- "pcode"
  out |> st_set_crs(4326) |> st_cast("MULTIPOLYGON") |> drop_pinholes() |> select(pcode)
}

soum_low <- simplify(soum |> select(pcode, aimag_pcode, region_pcode), keep_national)
aimag_low <- dissolve(soum_low, "aimag_pcode") |> left_join(parents |> select(pcode, region_pcode), by = "pcode")
region_low <- dissolve(aimag_low, "region_pcode")
country_low <- dissolve(region_low, NULL)

khoroo_low <- simplify(khoroo |> select(pcode, district_pcode), keep_ub)
ub_district_low <- dissolve(khoroo_low, "district_pcode")
ub_low <- dissolve(ub_district_low, NULL) |> mutate(pcode = "MN11")

low <- list(
  country = country_low, region = region_low, aimag = select(aimag_low, pcode), soum = select(soum_low, pcode),
  ub = ub_low, ub_district = ub_district_low, khoroo = select(khoroo_low, pcode)
)
low <- map(low, \(x) x |> st_set_crs(4326) |> st_make_valid() |> st_cast("MULTIPOLYGON") |> arrange(pcode))

# Label points: a well-inside point of each simplified polygon.
labels <- imap(low, \(x, layer) {
  pts <- rmapshaper::ms_points(x, location = "inner")
  xy <- st_coordinates(pts)
  tibble(layer = layer, pcode = pts$pcode, x = round(xy[, 1], 5), y = round(xy[, 2], 5))
}) |> bind_rows()

nv <- \(x) nrow(st_coordinates(x))
message(
  "Vertices high/low: ",
  paste(names(high), map_int(high, nv), map_int(low[names(high)], nv), sep = ":", collapse = "  ")
)

saveRDS(list(high = high, low = low, labels = labels, areas = areas), build_path("layers.rds"))
