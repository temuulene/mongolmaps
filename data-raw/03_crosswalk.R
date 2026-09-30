# Build the unit table (codes, names, hierarchy) and the alias table used by
# mn_match(). NSO's Region dimension is the backbone: it lists every unit
# from the country down to bags and khoroos.

source("data-raw/00_config.R")

cod <- readRDS(build_path("cod.rds"))
nso <- readRDS(raw_path("nso", "region_units.rds")) |>
  mutate(across(everything(), \(x) stringi::stri_trim_both(stringi::stri_trans_nfc(x))))
iso_tbl <- utils::read.csv("data-raw/manual/iso_3166_2.csv", encoding = "UTF-8")

check(!anyDuplicated(nso$code), "NSO codes must be unique")
nso <- nso |> filter(nchar(code) %in% c(1L, 3L, 5L, 7L))

region_names <- tibble(
  nso_code = as.character(1:5),
  name_en = c("Western region", "Khangai region", "Central region", "Eastern region", "Ulaanbaatar")
)

pcode_of <- function(code) {
  case_when(
    code == "0" ~ "MN",
    nchar(code) == 1 ~ paste0("MNR", code),
    TRUE ~ paste0("MN", substring(code, 2))
  )
}

units <- nso |>
  transmute(
    nso_code = code,
    pcode = pcode_of(code),
    level = case_when(
      code == "0" ~ "country",
      nchar(code) == 1 ~ "region",
      nchar(code) == 3 ~ "aimag",
      nchar(code) == 5 ~ "soum",
      nchar(code) == 7 ~ "bag"
    ),
    nso_en = label_en,
    nso_mn = label_mn
  ) |>
  mutate(
    region_pcode = if_else(level %in% c("aimag", "soum", "bag"), paste0("MNR", substring(nso_code, 1, 1)), NA_character_),
    aimag_pcode = case_when(level == "aimag" ~ pcode, level %in% c("soum", "bag") ~ substring(pcode, 1, 4)),
    soum_pcode = case_when(level == "soum" ~ pcode, level == "bag" ~ substring(pcode, 1, 6)),
    parent_pcode = case_when(
      level %in% c("region", "aimag") ~ "MN",
      level == "soum" ~ aimag_pcode,
      level == "bag" ~ soum_pcode
    )
  )

# Region pcode for a region row is itself.
units$region_pcode[units$level == "region"] <- units$pcode[units$level == "region"]

# Soum-level NSO units without a COD polygon are villages (tosgon): they have
# their own statistics but no bags and no boundary.
soum_codes <- units$pcode[units$level == "soum"]
villages <- setdiff(soum_codes, cod$adm2$pcode)
has_bags <- unique(units$soum_pcode[units$level == "bag"])
check(!any(villages %in% has_bags), "Villages must not have bags: ", toString(intersect(villages, has_bags)))
check(length(villages) == 4, "Expected 4 villages, found: ", toString(villages))
check(all(cod$adm2$pcode %in% soum_codes), "Every COD soum must be an NSO unit")
check(all(cod$adm1$pcode %in% units$pcode[units$level == "aimag"]), "Every COD aimag must be an NSO unit")

units <- units |>
  mutate(
    type = case_when(
      level == "country" ~ "country",
      level == "region" ~ "region",
      level == "aimag" & pcode == "MN11" ~ "capital",
      level == "aimag" ~ "aimag",
      level == "soum" & aimag_pcode == "MN11" ~ "district",
      level == "soum" & pcode %in% villages ~ "village",
      level == "soum" ~ "soum",
      level == "bag" & aimag_pcode == "MN11" ~ "khoroo",
      level == "bag" ~ "bag"
    ),
    number = if_else(level == "bag", suppressWarnings(as.integer(sub("^(\\d+).*$", "\\1", nso_mn))), NA_integer_),
    # A few NSO English labels contain stray Cyrillic letters.
    name_en = if_else(.mm_has_cyrillic(nso_en), mn_translit(nso_en, to = "nso"), nso_en),
    name_mn = nso_mn
  )

# Canonical names: NSO labels, except for the country and region rows whose
# NSO labels describe aggregates ("Total", "Center region").
units$name_en[units$level == "country"] <- "Mongolia"
units$name_mn[units$level == "country"] <- "\u041c\u043e\u043d\u0433\u043e\u043b \u0423\u043b\u0441"
reg <- match(units$nso_code, region_names$nso_code)
units$name_en[units$level == "region"] <- region_names$name_en[reg[units$level == "region"]]

check(all(stringi::stri_enc_isascii(units$name_en)), "name_en must be ASCII")
units <- units |>
  mutate(
    name_mns = mn_translit(name_mn, to = "mns"),
    iso_code = iso_tbl$iso_code[match(pcode, iso_tbl$pcode)]
  )

# Cross-check Cyrillic names against COD at aimag and soum level.
cod_names <- bind_rows(
  st_drop_geometry(cod$adm1) |> select(pcode, cod_en, cod_mn),
  st_drop_geometry(cod$adm2) |> select(pcode, cod_en, cod_mn)
)
cmp <- inner_join(units, cod_names, by = "pcode")
bad <- cmp |> filter(.mm_key(name_mn) != .mm_key(cod_mn))
if (nrow(bad)) {
  print(bad |> select(pcode, name_en, name_mn, cod_en, cod_mn))
}
check(nrow(bad) == 0, "Cyrillic names disagree between NSO and COD")

# Cross-check ISO codes against Wikidata.
wd_aimag <- utils::read.csv(raw_path("wikidata", "aimags.csv"), encoding = "UTF-8", colClasses = "character") |>
  distinct(iso, en, mn)
wd_check <- wd_aimag |>
  mutate(pcode = iso_tbl$pcode[match(iso, iso_tbl$iso_code)]) |>
  left_join(units |> select(pcode, name_mn), by = "pcode")
check(all(!is.na(wd_check$pcode)), "Wikidata has ISO codes missing from the manual table")
check(all(.mm_key(wd_check$mn) == .mm_key(wd_check$name_mn)), "Wikidata ISO codes disagree with the manual table")

units <- units |>
  select(
    pcode, level, type, number, name_en, name_mn, name_mns, iso_code, nso_code,
    parent_pcode, region_pcode, aimag_pcode, soum_pcode
  ) |>
  arrange(match(level, c("country", "region", "aimag", "soum", "bag")), pcode)

# ---- Aliases ---------------------------------------------------------------

alias_rows <- function(pcode, alias, source) {
  tibble(pcode = pcode, alias = alias, source = source) |>
    filter(!is.na(alias), alias != "")
}

bag_parts <- units |>
  filter(level == "bag") |>
  mutate(
    name_part_en = stringi::stri_trim_both(sub("^[^,]*,", "", ifelse(grepl(",", name_en), name_en, NA))),
    name_part_mn = stringi::stri_trim_both(sub("^[^,]*,", "", ifelse(grepl(",", name_mn), name_mn, NA))),
    district_en = units$name_en[match(parent_pcode, units$pcode)],
    district_mn = units$name_mn[match(parent_pcode, units$pcode)]
  )

gb <- st_read(raw_path("geoboundaries", "geoBoundaries-MNG-ADM1_simplified.geojson"), quiet = TRUE) |>
  st_drop_geometry()

wd_soums <- utils::read.csv(raw_path("wikidata", "soums.csv"), encoding = "UTF-8", colClasses = "character") |>
  distinct(item, en, mn, parent_en, parent_mn)

manual <- utils::read.csv("data-raw/manual/aliases_manual.csv", encoding = "UTF-8", colClasses = "character")

aliases <- bind_rows(
  alias_rows(units$pcode, units$name_en, "name_en"),
  alias_rows(units$pcode, units$name_mn, "name_mn"),
  alias_rows(units$pcode, units$name_mns, "name_mns"),
  alias_rows(units$pcode, mn_translit(units$name_mn, "nso"), "translit"),
  alias_rows(nso$code |> pcode_of(), nso$label_en, "nso_en"),
  alias_rows(nso$code |> pcode_of(), nso$label_mn, "nso_mn"),
  alias_rows(cod_names$pcode, cod_names$cod_en, "cod"),
  alias_rows(cod_names$pcode, cod_names$cod_mn, "cod"),
  alias_rows(iso_tbl$pcode[match(gb$shapeISO, iso_tbl$iso_code)], gb$shapeName, "geoboundaries"),
  alias_rows(iso_tbl$pcode[match(wd_aimag$iso, iso_tbl$iso_code)], wd_aimag$en, "wikidata"),
  alias_rows(iso_tbl$pcode[match(wd_aimag$iso, iso_tbl$iso_code)], wd_aimag$mn, "wikidata"),
  alias_rows(bag_parts$pcode, bag_parts$name_part_en, "bag_name"),
  alias_rows(bag_parts$pcode, bag_parts$name_part_mn, "bag_name"),
  alias_rows(bag_parts$pcode, as.character(bag_parts$number), "number"),
  alias_rows(
    bag_parts$pcode[bag_parts$aimag_pcode == "MN11"],
    paste(bag_parts$district_en, bag_parts$number)[bag_parts$aimag_pcode == "MN11"],
    "district_number"
  ),
  alias_rows(
    bag_parts$pcode[bag_parts$aimag_pcode == "MN11"],
    paste(bag_parts$district_mn, bag_parts$number)[bag_parts$aimag_pcode == "MN11"],
    "district_number"
  ),
  alias_rows(manual$pcode, manual$alias, "manual")
)

# Wikidata soum labels: resolve the parent aimag by key, then the soum by key
# within that aimag.
aimag_keys <- aliases |>
  filter(pcode %in% units$pcode[units$level == "aimag"]) |>
  transmute(aimag_pcode = pcode, key = .mm_key(alias)) |>
  distinct()
soum_keys <- aliases |>
  inner_join(units |> filter(level == "soum") |> select(pcode, aimag_pcode), by = "pcode") |>
  transmute(pcode, aimag_pcode, key = .mm_key(alias)) |>
  distinct()
wd_matched <- wd_soums |>
  mutate(parent_key = .mm_key(parent_en), key = .mm_key(mn)) |>
  inner_join(aimag_keys, by = c(parent_key = "key"), relationship = "many-to-many") |>
  inner_join(soum_keys, by = c("aimag_pcode", "key"), relationship = "many-to-many") |>
  distinct(item, pcode, en, mn)
wd_unique <- wd_matched |> filter(n() == 1, .by = item) |> filter(n() == 1, .by = pcode)
message("Wikidata soums matched: ", nrow(wd_unique), " of ", n_distinct(wd_soums$item))
saveRDS(wd_unique |> select(item, pcode), build_path("wikidata_soum_pcodes.rds"))

aliases <- bind_rows(
  aliases,
  alias_rows(wd_unique$pcode, wd_unique$en, "wikidata"),
  alias_rows(wd_unique$pcode, wd_unique$mn, "wikidata")
)

aliases <- aliases |>
  mutate(key = .mm_key(alias)) |>
  filter(key != "") |>
  inner_join(units |> select(pcode, level, parent_pcode), by = "pcode") |>
  distinct(pcode, key, .keep_all = TRUE)

# A key may repeat across parents (many soums share a name), but not within
# one parent. Drop ambiguous bag-name aliases; anything else stops.
dup <- aliases |>
  filter(n_distinct(pcode) > 1, .by = c(level, parent_pcode, key))
if (nrow(dup)) {
  drop <- dup |> filter(source %in% c("bag_name", "wikidata"))
  message("Dropping ", nrow(drop), " ambiguous bag-name/wikidata aliases")
  aliases <- anti_join(aliases, drop, by = c("pcode", "key"))
}
dup <- aliases |> filter(n_distinct(pcode) > 1, .by = c(level, parent_pcode, key))
if (nrow(dup)) print(dup |> arrange(key), n = 50)
check(nrow(dup) == 0, "Alias keys collide within a parent")

aliases <- aliases |> select(key, pcode, level, alias, source) |> arrange(level, key)

message(
  "Units: ", paste(names(table(units$level)), table(units$level), sep = "=", collapse = ", "),
  "; aliases: ", nrow(aliases)
)
saveRDS(units, build_path("units.rds"))
saveRDS(aliases, build_path("aliases.rds"))
