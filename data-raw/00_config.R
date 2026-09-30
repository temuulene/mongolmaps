# Shared settings and helpers for the data-raw pipeline.
# Run the numbered scripts in order from the package root, or use make.R.

suppressPackageStartupMessages({
  library(sf)
  library(dplyr)
  library(purrr)
})
devtools::load_all(quiet = TRUE)

# Raw downloads and intermediate files live outside the package (and outside
# Google Drive, whose sync locks files mid-write).
raw_dir <- Sys.getenv("MONGOLMAPS_RAW_DIR", unset = tools::R_user_dir("mongolmaps-dev", "cache"))
build_dir <- file.path(raw_dir, "build")
dir.create(build_dir, recursive = TRUE, showWarnings = FALSE)
raw_path <- function(...) file.path(raw_dir, ...)
build_path <- function(...) file.path(build_dir, ...)

data_version <- "data-v1"
crs_albers <- mongolmaps:::.mm_albers
crs_utm <- 32648L

khoroo_sha <- "bb1bf18f27e57d7a5aa7fe6d4a17234b40e162c1"
urls <- list(
  cod_geojson = paste0(
    "https://data.humdata.org/dataset/a9b0a8a6-cb14-448e-b35c-aa5eb51b0557/resource/",
    "de6b11d3-767d-449f-99fc-80c5b4e9abe3/download/mng_admin_boundaries.geojson.zip"
  ),
  cod_xlsx = paste0(
    "https://data.humdata.org/dataset/a9b0a8a6-cb14-448e-b35c-aa5eb51b0557/resource/",
    "8a9c3d58-1393-4bce-a7c1-af2e51142ab4/download/mng_admin_boundaries.xlsx"
  ),
  khoroos = paste0("https://raw.githubusercontent.com/Tuvshin-Level/khoroo-map/", khoroo_sha, "/khoroos.json"),
  gb_adm1 = "https://github.com/wmgeolab/geoBoundaries/raw/9469f09/releaseData/gbOpen/MNG/ADM1/geoBoundaries-MNG-ADM1_simplified.geojson"
)

nso_region_table <- "DT_NSO_0300_002V4"

# Downloads `url` to `dest` once and pins its sha256 in sources-lock.csv, so a
# silent upstream change stops the pipeline instead of changing the data.
lock_file <- "data-raw/sources-lock.csv"

download_pinned <- function(id, url, dest) {
  if (!file.exists(dest)) {
    dir.create(dirname(dest), recursive = TRUE, showWarnings = FALSE)
    req <- httr2::request(url) |>
      httr2::req_user_agent("mongolmaps data-raw (https://github.com/temuulene/mongolmaps)") |>
      httr2::req_retry(max_tries = 3)
    httr2::req_perform(req, path = dest)
  }
  sha <- as.character(openssl::sha256(file(dest)))
  lock <- if (file.exists(lock_file)) utils::read.csv(lock_file, colClasses = "character") else
    data.frame(id = character(), url = character(), sha256 = character(), bytes = character(), retrieved_on = character())
  row <- lock[lock$id == id, ]
  if (nrow(row) == 1 && row$url == url) {
    if (row$sha256 != sha) {
      stop("Checksum changed for ", id, ": upstream data changed. Review, then delete its row in ", lock_file)
    }
  } else {
    lock <- lock[lock$id != id, ]
    lock <- rbind(lock, data.frame(
      id = id, url = url, sha256 = sha, bytes = as.character(file.size(dest)),
      retrieved_on = as.character(Sys.Date())
    ))
    utils::write.csv(lock[order(lock$id), ], lock_file, row.names = FALSE)
  }
  invisible(dest)
}

wikidata_sparql <- function(query) {
  resp <- httr2::request("https://query.wikidata.org/sparql") |>
    httr2::req_url_query(query = query) |>
    httr2::req_headers(Accept = "text/csv") |>
    httr2::req_user_agent("mongolmaps data-raw (https://github.com/temuulene/mongolmaps)") |>
    httr2::req_retry(max_tries = 3) |>
    httr2::req_perform()
  utils::read.csv(text = httr2::resp_body_string(resp, encoding = "UTF-8"), encoding = "UTF-8", colClasses = "character")
}

wkt_point_xy <- function(wkt) {
  xy <- regmatches(wkt, regexec("Point\\(([-0-9.eE]+) ([-0-9.eE]+)\\)", wkt))
  data.frame(
    x = as.numeric(map_chr(xy, \(m) if (length(m)) m[2] else NA_character_)),
    y = as.numeric(map_chr(xy, \(m) if (length(m)) m[3] else NA_character_))
  )
}

# Area in km2. sf binary operations drop empty results, so a perfect match
# comes back as a zero-length geometry: count it as 0.
km2 <- function(g) {
  if (length(g) == 0) 0 else sum(as.numeric(st_area(g))) / 1e6
}

check <- function(ok, ...) {
  if (!isTRUE(all(ok))) stop(..., call. = FALSE)
  invisible(TRUE)
}
