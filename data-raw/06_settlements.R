# Settlement points: the capital, aimag centres and soum centres (Wikidata,
# CC0). NSO numbers the soum that holds an aimag centre as "01", which
# anchors each aimag centre to a known soum. A point outside its soum falls
# back to an inner point of the soum polygon.

source("data-raw/00_config.R")
sf_use_s2(FALSE)

units <- readRDS(build_path("units.rds"))
layers <- readRDS(build_path("layers.rds"))
soum_high <- layers$high$soum
inner <- layers$labels |> filter(layer == "soum") |> select(pcode, x, y)

wkt_cols <- function(d) bind_cols(d, wkt_point_xy(d$coord))

wd_soums <- utils::read.csv(raw_path("wikidata", "soums.csv"), encoding = "UTF-8", colClasses = "character") |>
  wkt_cols() |>
  inner_join(readRDS(build_path("wikidata_soum_pcodes.rds")), by = "item") |>
  filter(!is.na(x)) |>
  select(pcode, x, y)

iso_tbl <- utils::read.csv("data-raw/manual/iso_3166_2.csv")
wd_aimags <- utils::read.csv(raw_path("wikidata", "aimags.csv"), encoding = "UTF-8", colClasses = "character") |>
  wkt_cols() |>
  filter(!is.na(x)) |>
  transmute(
    aimag_pcode = iso_tbl$pcode[match(iso, iso_tbl$iso_code)],
    pcode = paste0(aimag_pcode, "01"),
    centre_mn = capital_mn, x, y
  )

# Keep the first candidate that lies inside its soum polygon.
inside <- function(cand) {
  if (!nrow(cand)) return(cand[0, ])
  pts <- st_as_sf(cand, coords = c("x", "y"), crs = 4326, remove = FALSE)
  poly <- soum_high[match(cand$pcode, soum_high$pcode), ]
  ok <- map_lgl(seq_len(nrow(pts)), \(i) !is.na(poly$pcode[i]) && lengths(st_intersects(pts[i, ], poly[i, ])) > 0)
  cand[ok, ] |> distinct(pcode, .keep_all = TRUE)
}

aimag_ctr <- inside(wd_aimags)
soum_ctr <- inside(wd_soums)

soums <- units |> filter(level == "soum", type == "soum")
centres <- soums |>
  select(pcode, aimag_pcode, soum_name_en = name_en, soum_name_mn = name_mn) |>
  left_join(aimag_ctr |> select(pcode, ax = x, ay = y, centre_mn), by = "pcode") |>
  left_join(soum_ctr |> select(pcode, sx = x, sy = y), by = "pcode") |>
  left_join(inner |> select(pcode, ix = x, iy = y), by = "pcode") |>
  mutate(
    is_aimag_centre = endsWith(pcode, "01") & aimag_pcode != "MN11",
    x = coalesce(ax, sx, ix),
    y = coalesce(ay, sy, iy),
    location_source = case_when(!is.na(ax) | !is.na(sx) ~ "wikidata", TRUE ~ "inner_point"),
    type = if_else(is_aimag_centre, "aimag_centre", "soum_centre"),
    name_mn = if_else(is_aimag_centre & !is.na(centre_mn) & centre_mn != "", centre_mn, soum_name_mn),
    name_mn = sub("\\s+(\u0441\u0443\u043c|\u0445\u043e\u0442)$", "", name_mn),
    name_en = if_else(type == "aimag_centre", mn_translit(name_mn, "nso"), soum_name_en),
    name_en = sub(" soum$", "", name_en)
  )

capital <- tibble(
  pcode = "MN11", aimag_pcode = "MN11", type = "capital",
  name_en = "Ulaanbaatar", name_mn = "\u0423\u043b\u0430\u0430\u043d\u0431\u0430\u0430\u0442\u0430\u0440",
  x = 106.91761, y = 47.91866, location_source = "manual"
)

settlements <- bind_rows(
  capital,
  centres |> select(pcode, aimag_pcode, type, name_en, name_mn, x, y, location_source)
) |>
  mutate(
    name_mns = mn_translit(name_mn, "mns"),
    admin_pcode = if_else(type == "aimag_centre", aimag_pcode, pcode),
    soum_pcode = if_else(type == "capital", NA_character_, pcode),
    x = round(x, 5), y = round(y, 5)
  ) |>
  select(admin_pcode, soum_pcode, aimag_pcode, type, name_en, name_mn, name_mns, location_source, x, y) |>
  arrange(match(type, c("capital", "aimag_centre", "soum_centre")), admin_pcode) |>
  st_as_sf(coords = c("x", "y"), crs = 4326)

check(sum(settlements$type == "aimag_centre") == 21, "Expected 21 aimag centres")
check(all(stringi::stri_enc_isascii(settlements$name_en)), "Settlement name_en must be ASCII")
message(
  "Settlements: ", nrow(settlements), " (", sum(settlements$location_source == "wikidata"), " from Wikidata, ",
  sum(settlements$location_source == "inner_point"), " inner points)"
)
print(settlements |> st_drop_geometry() |> filter(type != "soum_centre") |> select(admin_pcode, name_en, name_mn, location_source))
saveRDS(settlements, build_path("settlements.rds"))
