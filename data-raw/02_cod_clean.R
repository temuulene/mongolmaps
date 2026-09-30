# Read and clean the COD-AB boundaries (NSO / OCHA, CC BY-IGO).

source("data-raw/00_config.R")

fixes <- utils::read.csv("data-raw/manual/cod_pcode_fixes.csv", encoding = "UTF-8")

read_cod <- function(level) {
  x <- st_read(raw_path("cod", paste0("mng_admin", level, ".geojson")), quiet = TRUE)
  pc <- paste0("adm", level, "_pcode")
  out <- x |>
    transmute(
      pcode = .data[[pc]],
      cod_en = .data[[paste0("adm", level, "_name")]],
      cod_mn = .data[[paste0("adm", level, "_name1")]],
      cod_area_km2 = area_sqkm,
      valid_on = as.character(valid_on)
    )
  if (level > 0) {
    out$pcode <- ifelse(out$pcode %in% fixes$cod_pcode, fixes$pcode[match(out$pcode, fixes$cod_pcode)], out$pcode)
  }
  out <- st_make_valid(out)
  st_cast(out, "MULTIPOLYGON")
}

cod <- list(adm0 = read_cod(0), adm1 = read_cod(1), adm2 = read_cod(2))
cod$region <- st_read(raw_path("cod", "mng_region.geojson"), quiet = TRUE) |>
  select(region_en) |>
  st_make_valid()

check(nrow(cod$adm0) == 1, "COD admin0 must have 1 feature")
check(nrow(cod$adm1) == 22, "COD admin1 must have 22 features")
check(nrow(cod$adm2) == 339, "COD admin2 must have 339 features")
check(nrow(cod$region) == 4, "COD region must have 4 features")
check(!anyDuplicated(cod$adm2$pcode), "COD admin2 pcodes must be unique after fixes")
check(all(map_lgl(cod[c("adm0", "adm1", "adm2")], \(x) all(st_is_valid(x)))), "COD geometries must be valid")

saveRDS(cod, build_path("cod.rds"))
message("COD cleaned: ", paste(map_int(cod, nrow), collapse = "/"))
