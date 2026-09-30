# Context layers from Natural Earth (public domain): neighbouring countries,
# major rivers and lakes around Mongolia.

source("data-raw/00_config.R")
sf_use_s2(FALSE)

layers <- readRDS(build_path("layers.rds"))
mn_alb <- st_transform(layers$high$country, crs_albers)
frame <- st_as_sfc(st_bbox(st_buffer(mn_alb, 300000)))

clip_frame <- function(x) {
  x |>
    st_transform(crs_albers) |>
    st_make_valid() |>
    st_intersection(frame) |>
    st_transform(4326)
}

neighbours <- rnaturalearth::ne_countries(scale = 10, returnclass = "sf") |>
  filter(iso_a3 %in% c("RUS", "CHN", "KAZ")) |>
  transmute(iso3 = iso_a3, name_en = name_en) |>
  clip_frame() |>
  st_collection_extract("POLYGON") |>
  group_by(iso3, name_en) |>
  summarise(.groups = "drop") |>
  rmapshaper::ms_simplify(keep = 0.15, keep_shapes = TRUE) |>
  st_make_valid() |>
  st_cast("MULTIPOLYGON")

ne_dir <- raw_path("naturalearth")
rivers <- st_read(list.files(ne_dir, "rivers_lake_centerlines.*\\.gpkg$", full.names = TRUE)[1], quiet = TRUE) |>
  transmute(name_en = name_en, scalerank = as.integer(scalerank), feature = featurecla) |>
  clip_frame() |>
  st_collection_extract("LINESTRING") |>
  group_by(name_en, scalerank, feature) |>
  summarise(.groups = "drop")

lakes <- st_read(list.files(ne_dir, "lakes.*\\.gpkg$", full.names = TRUE)[1], quiet = TRUE) |>
  transmute(name_en = name_en, scalerank = as.integer(scalerank)) |>
  clip_frame() |>
  st_collection_extract("POLYGON") |>
  st_make_valid() |>
  st_cast("MULTIPOLYGON")

fix_ascii <- \(x) stringi::stri_trans_general(x, "Latin-ASCII")
rivers$name_en <- fix_ascii(rivers$name_en)
lakes$name_en <- fix_ascii(lakes$name_en)
neighbours$name_en <- fix_ascii(neighbours$name_en)

message("Context: ", nrow(neighbours), " neighbours, ", nrow(rivers), " rivers, ", nrow(lakes), " lakes")
saveRDS(list(neighbours = neighbours, rivers = rivers, lakes = lakes), build_path("context.rds"))
