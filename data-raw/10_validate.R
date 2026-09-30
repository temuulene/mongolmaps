# Validate every built layer before it is bundled or released. Stops on the
# first failure.

source("data-raw/00_config.R")

units <- readRDS(build_path("units.rds"))
aliases <- readRDS(build_path("aliases.rds"))
layers <- readRDS(build_path("layers.rds"))
settlements <- readRDS(build_path("settlements.rds"))

expected <- c(country = 1, region = 5, aimag = 22, soum = 339, ub = 1, ub_district = 9, khoroo = 204)
for (res in c("low", "high")) {
  n <- map_int(layers[[res]][names(expected)], nrow)
  check(identical(unname(n), unname(as.integer(expected))), res, " layer counts wrong: ", toString(n))
  for (nm in names(expected)) {
    x <- layers[[res]][[nm]]
    check(!anyDuplicated(x$pcode), res, "/", nm, ": duplicate pcodes")
    check(all(x$pcode %in% units$pcode), res, "/", nm, ": pcodes missing from units")
    sf_use_s2(FALSE)
    check(all(st_is_valid(x)), res, "/", nm, ": invalid under GEOS")
    sf_use_s2(TRUE)
    check(all(s2::s2_is_valid(x)), res, "/", nm, ": invalid under S2")
  }
}

kh_counts <- units |>
  filter(pcode %in% layers$low$khoroo$pcode) |>
  count(parent_pcode) |>
  arrange(parent_pcode)
check(identical(kh_counts$n, c(5L, 2L, 34L, 43L, 8L, 43L, 20L, 25L, 24L)), "Khoroo counts per district changed")

sf_use_s2(FALSE)
alb <- \(x) st_transform(x, crs_albers)
parent_of <- setNames(units$parent_pcode, units$pcode)
aimag_of <- setNames(units$aimag_pcode, units$pcode)

# Label points lie inside their polygon and inside the parent polygon.
lab <- layers$labels |> st_as_sf(coords = c("x", "y"), crs = 4326)
for (nm in c("region", "aimag", "soum", "ub_district", "khoroo")) {
  pts <- lab |> filter(layer == nm)
  poly <- layers$low[[nm]][match(pts$pcode, layers$low[[nm]]$pcode), ]
  ok <- map_lgl(seq_len(nrow(pts)), \(i) lengths(st_intersects(pts[i, ], poly[i, ])) > 0)
  check(all(ok), "Label points outside their ", nm, ": ", toString(pts$pcode[!ok]))
}
soum_pts <- lab |> filter(layer == "soum")
aim <- layers$low$aimag[match(aimag_of[soum_pts$pcode], layers$low$aimag$pcode), ]
ok <- map_lgl(seq_len(nrow(soum_pts)), \(i) lengths(st_intersects(soum_pts[i, ], aim[i, ])) > 0)
check(all(ok), "Soum label points outside their aimag: ", toString(soum_pts$pcode[!ok]))

# Full-resolution nesting of soums in aimags.
soum_h <- alb(layers$high$soum)
aim_h <- alb(layers$high$aimag)
nest <- map_dbl(seq_len(nrow(soum_h)), function(i) {
  a <- aim_h[aim_h$pcode == aimag_of[[soum_h$pcode[i]]], ]
  km2(st_intersection(st_geometry(soum_h)[i], st_geometry(a))) / km2(st_geometry(soum_h)[i])
})
message("Soum-in-aimag nesting: min share ", round(min(nest), 5))
check(min(nest) >= 0.999, "Soums spill outside their aimag")

# No overlaps and no missing area in the national soum layer.
for (res in c("low", "high")) {
  s <- alb(layers[[res]]$soum)
  overlap <- km2(st_geometry(s)) - km2(st_union(s))
  country_gap <- km2(alb(layers[[res]]$country)) - km2(st_union(s))
  message(res, ": soum overlap ", round(overlap, 3), " km2; country minus soums ", round(country_gap, 3), " km2")
  check(overlap < 1, res, ": soums overlap")
  check(abs(country_gap) / km2(alb(layers[[res]]$country)) < 0.001, res, ": soums do not cover the country")
}

# Simplified areas stay close to full resolution.
area_err <- function(nm) {
  lo <- alb(layers$low[[nm]])
  hi <- alb(layers$high[[nm]])
  a_lo <- as.numeric(st_area(lo)) / 1e6
  a_hi <- as.numeric(st_area(hi))[match(lo$pcode, hi$pcode)] / 1e6
  abs(a_lo - a_hi) / a_hi
}
tol <- c(country = 0.01, region = 0.01, aimag = 0.02, soum = 0.05, ub_district = 0.03, khoroo = 0.10)
for (nm in names(tol)) {
  e <- area_err(nm)
  message(sprintf("%-11s max area error %.2f%%", nm, 100 * max(e)))
  check(max(e) <= tol[[nm]], nm, ": simplified area differs too much")
}

# Names and codes.
check(!anyDuplicated(units$pcode), "Duplicate pcodes in units")
check(all(stringi::stri_enc_isascii(units$name_en)), "name_en must be ASCII")
check(all(stringi::stri_enc_isascii(settlements$name_en)), "Settlement names must be ASCII")
check(all(aliases$pcode %in% units$pcode), "Aliases point at unknown units")

message("All validation checks passed.")
