# Write the bundled data (R/sysdata.rda and data/*.rda), the full-resolution
# release assets, and the manifest that tells the package where each layer
# lives.

source("data-raw/00_config.R")

units <- readRDS(build_path("units.rds"))
aliases <- readRDS(build_path("aliases.rds"))
layers <- readRDS(build_path("layers.rds"))
settlements <- readRDS(build_path("settlements.rds"))
context <- readRDS(build_path("context.rds"))

geom_pcodes <- unique(unlist(map(layers$low, "pcode")))
units <- units |>
  left_join(layers$areas, by = "pcode") |>
  mutate(has_geometry = pcode %in% geom_pcodes)

# Store geometry as pcode + geometry only; attributes are joined at run time.
# Rounding to 1e-5 degrees (about 1 m) shrinks the data; it can make a few
# polygons self-intersect, which GEOS repairs (S2 repairs are not always
# valid under GEOS).
round_geom <- function(x, digits = 5) {
  st_geometry(x) <- st_as_sfc(st_as_binary(st_geometry(x), precision = 10^digits), crs = 4326)
  old <- sf_use_s2(FALSE)
  on.exit(suppressMessages(sf_use_s2(old)))
  x <- st_make_valid(x) |> st_cast("MULTIPOLYGON")
  check(all(st_is_valid(x)) && all(s2::s2_is_valid(x)), "Rounded geometry is invalid")
  tibble::as_tibble(x) |> st_as_sf()
}
.mm_low <- map(layers$low, \(x) round_geom(select(x, pcode)))
.mm_labels <- tibble::as_tibble(layers$labels)
.mm_units <- tibble::as_tibble(units)
.mm_aliases <- tibble::as_tibble(aliases)
.mm_settlements <- tibble::as_tibble(settlements) |> st_as_sf()
.mm_context <- map(context, function(x) {
  st_geometry(x) <- "geometry"
  tibble::as_tibble(x) |> st_as_sf()
})
.mm_data_version <- data_version

usethis::use_data(
  .mm_units, .mm_aliases, .mm_low, .mm_labels, .mm_settlements, .mm_context, .mm_data_version,
  internal = TRUE, overwrite = TRUE, compress = "xz"
)

# Exported example data (ASCII only).
pop <- readRDS(raw_path("nso", "population.rds"))
mn_example_population <- tibble::tibble(
  Region = pop$Region,
  Region_en = stringi::stri_trim_both(ifelse(.mm_has_cyrillic(pop$Region_en), mn_translit(pop$Region_en, "nso"), pop$Region_en)),
  Year = as.integer(pop$Year_en),
  value = pop$value
) |>
  arrange(Year, Region)
check(all(stringi::stri_enc_isascii(mn_example_population$Region_en)), "Example data must be ASCII")

mn_aimag_grid <- tibble::tribble(
  ~row, ~col, ~code,
  1, 1, "MN83", 1, 2, "MN85", 1, 4, "MN67", 1, 5, "MN63", 1, 6, "MN43", 1, 8, "MN23", 1, 9, "MN21",
  2, 2, "MN84", 2, 3, "MN81", 2, 4, "MN65", 2, 5, "MN61", 2, 6, "MN45", 2, 7, "MN11", 2, 8, "MN41", 2, 9, "MN22",
  3, 3, "MN82", 3, 4, "MN64", 3, 5, "MN62", 3, 6, "MN48", 3, 7, "MN42", 3, 8, "MN44",
  4, 5, "MN46"
) |>
  mutate(row = as.integer(row), col = as.integer(col), name = units$name_en[match(code, units$pcode)]) |>
  as.data.frame()
check(nrow(mn_aimag_grid) == 22 && !anyDuplicated(mn_aimag_grid[c("row", "col")]), "Aimag grid is malformed")

usethis::use_data(mn_example_population, mn_aimag_grid, overwrite = TRUE, compress = "xz")

# Full-resolution release asset.
release_dir <- build_path("release")
dir.create(release_dir, showWarnings = FALSE)
gpkg <- file.path(release_dir, "admin_high.gpkg")
unlink(gpkg)
iwalk(layers$high, \(x, layer) st_write(select(x, pcode), gpkg, layer = layer, quiet = TRUE))
zip_file <- file.path(release_dir, "admin_high.gpkg.zip")
unlink(zip_file)
utils::zip(zip_file, gpkg, flags = "-j9Xq")

# Manifest: static metadata plus checksums of released files.
sources <- utils::read.csv("data-raw/manual/sources.csv", encoding = "UTF-8", colClasses = "character")
release_url <- paste0("https://github.com/temuulene/mongolmaps/releases/download/", data_version, "/")
sources$data_version <- data_version
sources$url <- ifelse(sources$delivery == "release", paste0(release_url, sources$file), "")
sources$url[sources$id == "wdpa"] <- paste0(
  "https://data-gis.unep-wcmc.org/server/rest/services/ProtectedPlanet/WDPCA/FeatureServer/1/query?",
  "where=iso3%3D%27MNG%27&outFields=*&f=geojson"
)
sources$data_version[sources$delivery == "upstream"] <- "upstream"
sources$sha256 <- ""
sources$fallback_url <- ""
sources$bytes <- ""
rel <- sources$delivery == "release"
for (i in which(rel)) {
  f <- file.path(release_dir, sources$file[i])
  check(file.exists(f), "Release file missing: ", f)
  sources$sha256[i] <- as.character(openssl::sha256(file(f)))
  sources$bytes[i] <- as.character(file.size(f))
}
utils::write.csv(sources, "inst/extdata/manifest.csv", row.names = FALSE, fileEncoding = "UTF-8")

size <- file.size("R/sysdata.rda") / 1024^2
message(sprintf("R/sysdata.rda: %.2f MB; data/: %.2f MB", size, sum(file.size(list.files("data", full.names = TRUE))) / 1024^2))
check(size <= 2.5, "Bundled data exceeds the 2.5 MB budget")
