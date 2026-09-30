# Rebuild all bundled data and release assets from the upstream sources.
#
# Run from the package root:
#   Rscript data-raw/make.R
# Raw downloads are cached in MONGOLMAPS_RAW_DIR (default: a folder under
# tools::R_user_dir("mongolmaps-dev", "cache")); keep it outside cloud-synced
# folders. Each step stops with an error if a check fails.

steps <- c(
  "01_download", "02_cod_clean", "03_crosswalk", "04_khoroos_reconcile",
  "05_simplify", "06_settlements", "07_context", "08_osm_assets", "09_rasters",
  "10_validate", "11_write_bundled"
)
for (step in steps) {
  message("\n== ", step)
  source(file.path("data-raw", paste0(step, ".R")), local = new.env())
}
