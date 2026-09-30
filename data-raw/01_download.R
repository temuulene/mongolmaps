# Download every upstream source used to build the bundled data.

source("data-raw/00_config.R")

download_pinned("cod_geojson", urls$cod_geojson, raw_path("cod", "mng_admin_boundaries.geojson.zip"))
utils::unzip(raw_path("cod", "mng_admin_boundaries.geojson.zip"), exdir = raw_path("cod"))
download_pinned("cod_xlsx", urls$cod_xlsx, raw_path("cod", "mng_admin_boundaries.xlsx"))
download_pinned("khoroos", urls$khoroos, raw_path("khoroo", "khoroos.json"))
download_pinned("gb_adm1", urls$gb_adm1, raw_path("geoboundaries", "geoBoundaries-MNG-ADM1_simplified.geojson"))

# NSO PXWeb: the Region dimension of the bag/khoroo population table lists
# every unit from the country down to bags and khoroos, with NSO codes and
# English and Mongolian labels.
if (!file.exists(raw_path("nso", "region_units.rds"))) {
  dir.create(raw_path("nso"), showWarnings = FALSE)
  units <- mongolstats::nso_dim_values(nso_region_table, "Region", labels = "both")
  saveRDS(units, raw_path("nso", "region_units.rds"))
}

# Mid-year population for the example dataset (all units, two years).
if (!file.exists(raw_path("nso", "population.rds"))) {
  years <- mongolstats::nso_dim_values(nso_region_table, "Year", labels = "en")
  units <- readRDS(raw_path("nso", "region_units.rds"))
  pop <- mongolstats::nso_data(
    nso_region_table,
    selections = list(
      Region = units$code,
      Year = years$code[years$label_en %in% c("2015", "2020", "2025")]
    ),
    labels = "en"
  )
  saveRDS(pop, raw_path("nso", "population.rds"))
}

# Wikidata (CC0): aimag ISO codes and capitals, and soum coordinates.
if (!file.exists(raw_path("wikidata", "aimags.csv"))) {
  dir.create(raw_path("wikidata"), showWarnings = FALSE)
  aimags <- wikidata_sparql('
    SELECT ?item ?iso ?en ?mn ?capital ?capital_en ?capital_mn ?coord WHERE {
      ?item wdt:P300 ?iso . FILTER(STRSTARTS(?iso, "MN-"))
      OPTIONAL { ?item rdfs:label ?en FILTER(LANG(?en) = "en") }
      OPTIONAL { ?item rdfs:label ?mn FILTER(LANG(?mn) = "mn") }
      OPTIONAL {
        ?item wdt:P36 ?capital .
        OPTIONAL { ?capital wdt:P625 ?coord . }
        OPTIONAL { ?capital rdfs:label ?capital_en FILTER(LANG(?capital_en) = "en") }
        OPTIONAL { ?capital rdfs:label ?capital_mn FILTER(LANG(?capital_mn) = "mn") }
      }
    }')
  utils::write.csv(aimags, raw_path("wikidata", "aimags.csv"), row.names = FALSE, fileEncoding = "UTF-8")

  soums <- wikidata_sparql('
    SELECT ?item ?en ?mn ?parent ?parent_en ?parent_mn ?coord WHERE {
      ?item wdt:P31 wd:Q1518096 .
      OPTIONAL { ?item wdt:P131 ?parent .
        OPTIONAL { ?parent rdfs:label ?parent_en FILTER(LANG(?parent_en) = "en") }
        OPTIONAL { ?parent rdfs:label ?parent_mn FILTER(LANG(?parent_mn) = "mn") } }
      OPTIONAL { ?item wdt:P625 ?coord . }
      OPTIONAL { ?item rdfs:label ?en FILTER(LANG(?en) = "en") }
      OPTIONAL { ?item rdfs:label ?mn FILTER(LANG(?mn) = "mn") }
    }')
  utils::write.csv(soums, raw_path("wikidata", "soums.csv"), row.names = FALSE, fileEncoding = "UTF-8")
}

# Natural Earth physical layers (public domain) for map context.
ne_dir <- raw_path("naturalearth")
dir.create(ne_dir, showWarnings = FALSE)
for (type in c("rivers_lake_centerlines", "lakes")) {
  if (!length(list.files(ne_dir, paste0(type, ".*\\.(shp|gpkg)$")))) {
    rnaturalearth::ne_download(scale = 10, type = type, category = "physical", destdir = ne_dir, load = FALSE)
  }
}

message("Downloads complete in ", raw_dir)
