# OpenStreetMap layers from the Humanitarian OpenStreetMap Team exports
# (ODbL). Each theme becomes a separate release asset, so ODbL data never mix
# with the other layers.

source("data-raw/00_config.R")
sf_use_s2(FALSE)

themes <- c("roads", "railways", "airports", "waterways", "populated_places")
hot <- map(rlang::set_names(themes), function(theme) {
  url <- sprintf("https://production-raw-data-api.s3.amazonaws.com/ISO3/MNG/%s/hotosm_mng_%s_osm_gpkg.zip", theme, theme)
  dest <- raw_path("hot", basename(url))
  download_pinned(paste0("hot_", theme), url, dest)
  exdir <- raw_path("hot", theme)
  if (!dir.exists(exdir)) utils::unzip(dest, exdir = exdir)
  f <- list.files(exdir, "\\.gpkg$", full.names = TRUE, recursive = TRUE)[1]
  st_read(f, quiet = TRUE) |> st_set_geometry("geometry")
})

# Names: keep OSM's own name tags; fill English from the Latin or
# transliterated name, and Mongolian from a Cyrillic `name`.
tidy_names <- function(x) {
  name_mn <- coalesce(x$name_mn, if_else(.mm_has_cyrillic(x$name), x$name, NA_character_))
  name_en <- coalesce(x$name_en, x$name_latin, if_else(!is.na(name_mn), mn_translit(name_mn, "nso"), x$name))
  x$name_en <- name_en
  x$name_mn <- name_mn
  x
}
lines_only <- function(x) x[st_geometry_type(x) %in% c("LINESTRING", "MULTILINESTRING"), ]
polys_only <- function(x) x[st_geometry_type(x) %in% c("POLYGON", "MULTIPOLYGON"), ]
as_points <- function(x) {
  st_geometry(x) <- st_point_on_surface(st_geometry(x))
  x
}

# Roads: all highway lines, with a simple class for filtering.
main <- c("motorway", "trunk", "primary", "secondary", "tertiary")
roads <- hot$roads |>
  lines_only() |>
  tidy_names() |>
  transmute(
    osm_id = as.character(id),
    name_en, name_mn,
    highway,
    class = case_when(
      sub("_link$", "", highway) %in% main ~ "main",
      highway %in% c("unclassified", "residential", "living_street", "service", "road", "pedestrian") ~ "minor",
      highway == "track" ~ "track",
      TRUE ~ "path"
    ),
    surface
  )

railways <- hot$railways |> lines_only() |> tidy_names() |>
  transmute(osm_id = as.character(id), name_en, name_mn, railway)
stations <- hot$railways |> filter(railway == "station") |> as_points() |> tidy_names() |>
  transmute(osm_id = as.character(id), name_en, name_mn)
airports <- hot$airports |> filter(aeroway == "aerodrome") |> as_points() |> tidy_names() |>
  transmute(osm_id = as.character(id), name_en, name_mn)

waterways <- hot$waterways |> lines_only() |> filter(!is.na(waterway)) |> tidy_names() |>
  transmute(osm_id = as.character(id), name_en, name_mn, class = waterway)
water <- hot$waterways |> polys_only() |> tidy_names() |>
  transmute(osm_id = as.character(id), name_en, name_mn, class = coalesce(water, natural_class, "water")) |>
  st_make_valid() |>
  st_cast("MULTIPOLYGON")

places <- hot$populated_places |>
  filter(place %in% c("city", "town", "village", "hamlet", "suburb", "isolated_dwelling")) |>
  as_points() |>
  tidy_names() |>
  transmute(osm_id = as.character(id), name_en, name_mn, place, population = suppressWarnings(as.integer(population)))

assets <- list(
  osm_roads = list(roads = roads),
  osm_transport = list(railways = railways, stations = stations, airports = airports),
  osm_water = list(waterways = waterways, water = water),
  osm_places = list(places = places)
)

release_dir <- build_path("release")
dir.create(release_dir, showWarnings = FALSE)
for (id in names(assets)) {
  gpkg <- file.path(release_dir, paste0(id, ".gpkg"))
  unlink(gpkg)
  iwalk(assets[[id]], \(x, layer) st_write(st_transform(x, 4326), gpkg, layer = layer, quiet = TRUE))
  zip_file <- paste0(gpkg, ".zip")
  unlink(zip_file)
  utils::zip(zip_file, gpkg, flags = "-j9Xq")
  message(sprintf(
    "%-14s %s; zip %.1f MB", id,
    paste(names(assets[[id]]), map_int(assets[[id]], nrow), sep = "=", collapse = ", "),
    file.size(zip_file) / 1024^2
  ))
}
