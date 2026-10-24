test_that("fractional population extraction conserves split cells", {
  skip_if_not_installed("terra")
  r <- terra::rast(nrows = 1, ncols = 1, xmin = 0, xmax = 100, ymin = 0, ymax = 100, crs = "EPSG:32648", vals = 100)
  rect <- function(a, b) sf::st_polygon(list(matrix(c(a, 0, b, 0, b, 100, a, 100, a, 0), ncol = 2, byrow = TRUE)))
  x <- sf::st_sf(id = 1:2, geometry = sf::st_sfc(rect(0, 25), rect(25, 100), crs = 32648))
  out <- mn_zonal(r, x)
  expect_equal(out$value, c(25, 75), tolerance = 1e-5)
  expect_equal(sum(out$value), 100, tolerance = 1e-5)
  terra::values(r) <- NA_real_
  expect_true(all(is.na(mn_zonal(r, x)$value)))
  expect_error(mn_zonal(c(r, r), x), "exactly one layer")
  expect_error(mn_zonal(r, x, fun = "median"), "exact = FALSE")
})

test_that("population remapping preserves its native-grid total and records allocation", {
  skip_if_not_installed("terra")
  r <- terra::rast(nrows = 10, ncols = 10, xmin = 100, xmax = 102, ymin = 46, ymax = 48, crs = "EPSG:4326", vals = 100)
  path <- withr::local_tempfile(fileext = ".tif")
  terra::writeRaster(r, path, overwrite = TRUE)
  local_mocked_bindings(.mm_asset_row = function(...) path)
  native <- mn_population(2025, mask = FALSE)
  mapped <- mn_population(2025, mask = FALSE, crs = "albers")
  expect_equal(terra::global(mapped, "sum", na.rm = TRUE)[[1]], terra::global(native, "sum", na.rm = TRUE)[[1]], tolerance = 1e-7)
  expect_equal(attr(mapped, "mongolmaps_remapping")$source_total, 10000)
  expect_match(mn_provenance(mapped)$resampling[1], "normalized")
})

test_that("UB reconciliation respects all dimensions and exposes its decisions", {
  d <- data.frame(
    Region = rep(c("5", "511"), 4),
    Year = rep(c(2024, 2024, 2025, 2025), each = 2),
    Sex = rep(c("F", "M"), each = 2, times = 2),
    value = c(10, NA, NA, 20, 30, NA, NA, 40)
  )
  x <- suppressMessages(mn_join(d, "Region", level = "aimag", strata = c("Year", "Sex")))
  ub <- sf::st_drop_geometry(x[x$pcode == "MN11", ])
  expect_equal(ub$value[order(ub$Year, ub$Sex)], c(10, 20, 30, 40))
  audit <- mn_join_audit(x)
  expect_equal(nrow(audit), nrow(d))
  expect_equal(audit$row, seq_len(nrow(d)))
  expect_equal(sum(audit$action == "superseded"), 4)
  expect_equal(sum(audit$action == "joined"), 4)
  d <- data.frame(Region = c("5", "511"), value = c(5, 7), other = c(8, NA))
  expect_warning(x <- mn_join(d, "Region", level = "aimag"), class = "mongolmaps_ub_conflict")
  expect_equal(x$value[x$pcode == "MN11"], 7)
  expect_equal(x$other[x$pcode == "MN11"], 8)
  expect_equal(mn_join_audit(x)$action, c("coalesced", "joined"))
  expect_error(mn_join(d, "Region", level = "aimag", ub_policy = "error"), class = "mongolmaps_ub_conflict_error")
  expect_warning(x <- mn_join(d, "Region", level = "aimag", ub_policy = "prefer_region"), class = "mongolmaps_ub_conflict")
  expect_equal(x$value[x$pcode == "MN11"], 5)
})

test_that("global geographic scope constrains matching and diagnostics", {
  x <- mn_join(data.frame(place = "Bayangol", value = 10), "place", level = "soum", within = "Ulaanbaatar")
  expect_equal(x$value[x$pcode == "MN1107"], 10)
  d <- data.frame(place = c("Bayangol", "Uvs"), value = 1:2)
  x <- suppressMessages(mn_join(d, "place", level = "soum", within = "Ulaanbaatar"))
  expect_equal(mn_join_audit(x)$action, c("joined", "other_level"))
  d <- data.frame(place = c("Khovd", "Uvs"), value = 1:2)
  x <- mn_join(d, "place", level = "aimag", within = "Khovd", strict = TRUE)
  expect_equal(mn_join_audit(x)$action, c("joined", "outside_scope"))
  d <- data.frame(aimag = c("Dornod", "Govi-Altai"), place = "Bayan-Uul", value = 1:2)
  x <- mn_join(d, "place", by_parent = "aimag")
  expect_equal(unique(x$level), "soum")
  expect_equal(sum(!is.na(x$value)), 2)
})

test_that("strict joins and diagnostic matching are inspectable", {
  z <- suppressMessages(mn_match(c("Uvs", "Ulanbaatr", NA), details = TRUE))
  expect_equal(z$status, c("exact", "fuzzy", "missing"))
  expect_equal(z$distance, c(0L, 1L, NA_integer_))
  expect_equal(nrow(mn_match(character(), details = TRUE)), 0)
  expect_error(mn_join(data.frame(p = NA_character_), "p", strict = TRUE), class = "mongolmaps_join_error")
  expect_error(suppressWarnings(mn_join(data.frame(p = "Narnia"), "p", level = "aimag", strict = TRUE)),
               class = "mongolmaps_join_error")
  d <- data.frame(p = c("Uvs", "Uvs"), Year = c(2024, 2025), value = 1:2)
  expect_s3_class(mn_join(d, "p", strict = TRUE), "sf")
  d$Year <- 2024
  expect_error(mn_join(d, "p", strict = TRUE), class = "mongolmaps_join_duplicate_error")
  expect_warning(mn_join(d, "p", duplicates = "warn"), class = "mongolmaps_join_duplicate")
  expect_error(mn_join_audit(mn_aimags()), "No join audit")
})

test_that("multipart bag imports retain geometry and report their areas", {
  s <- mn_soums("Khovd")[1, ]
  code <- mn_codes("bag", within = s$pcode)[1, ]
  pt <- sf::st_coordinates(sf::st_transform(mn_label_points(s), 32648))[1, ]
  points <- sf::st_sfc(sf::st_point(pt), sf::st_point(pt + c(300, 0)), crs = 32648)
  geom <- sf::st_transform(sf::st_buffer(points, 100), 4326)
  path <- withr::local_tempfile(fileext = ".gpkg")
  sf::st_write(sf::st_sf(code = rep(code$nso_code, 2), geometry = geom), path, quiet = TRUE)
  x <- mn_read_bags(path)
  expect_equal(nrow(x), 1)
  expected <- sum(as.numeric(sf::st_area(sf::st_transform(geom, .mm_albers)))) / 1e6
  expect_equal(mn_bags(path = path)$area_km2, expected, tolerance = 1e-5)
  expect_equal(length(sf::st_geometry(x)[[1]]), 2)
  withr::local_options(mongolmaps.bags_path = path)
  expect_true(mn_codes("bag", within = s$pcode)$has_geometry[1])
  expect_length(.mm_target_geometry(code$pcode), 1)
  expect_true("user_bags" %in% mn_provenance(mn_admin("bag"))$id)
  # A valid interior point must not conceal major spill outside the parent.
  big <- sf::st_transform(sf::st_buffer(sf::st_sfc(sf::st_point(pt), crs = 32648), 200000), 4326)
  expect_error(.mm_check_bag_nesting(sf::st_sf(pcode = code$pcode, geometry = big)), "outside")
})

test_that("registered bag files are re-read after modification", {
  path <- local_bag_file()
  first <- .mm_bags_cached(path)
  x <- sf::st_read(path, quiet = TRUE)
  sf::st_write(x[1, ], path, quiet = TRUE, delete_dsn = TRUE)
  second <- .mm_bags_cached(path)
  expect_gt(nrow(first), nrow(second))
  expect_equal(nrow(second), 1)
})

test_that("stale cached protected areas survive offline refreshes", {
  withr::local_options(mongolmaps.cache_dir = withr::local_tempdir(), mongolmaps.offline = TRUE)
  row <- .mm_manifest_row("wdpa")
  path <- file.path(mn_cache_dir(), row$data_version, row$file)
  dir.create(dirname(path), recursive = TRUE)
  x <- sf::st_sf(name_eng = "Park", desig_eng = "Reserve", geometry = sf::st_geometry(mn_aimags()[1, ]))
  sf::st_write(x, path, quiet = TRUE)
  writeLines(.mm_sha256(path), paste0(path, ".sha256"))
  Sys.setFileTime(path, Sys.time() - 100 * 86400)
  expect_warning(out <- mn_protected_areas(), class = "mongolmaps_stale_cache")
  expect_equal(out$name_eng, "Park")
  expect_true(file.exists(path))
  expect_error(mn_protected_areas(refresh = TRUE), class = "mongolmaps_offline_error")
  expect_true(file.exists(path))
})

test_that("cache integrity and failed publication preserve old bytes", {
  root <- withr::local_tempdir()
  old <- file.path(root, "old.txt")
  new <- file.path(root, "new.txt")
  writeLines("old", old)
  writeLines(.mm_sha256(old), paste0(old, ".sha256"))
  expect_true(.mm_cached_ok(old, list(sha256 = NA_character_)))
  writeLines("corrupt", old)
  expect_false(.mm_cached_ok(old, list(sha256 = NA_character_)))
  writeLines("replacement", new)
  local_mocked_bindings(.mm_move_file = function(from, to) {
    if (identical(from, new)) return(FALSE)
    file.rename(from, to)
  })
  expect_error(.mm_publish_files(new, old), class = "mongolmaps_cache_error")
  expect_equal(readLines(old), "corrupt")
  expect_true(file.exists(new))
})

test_that("WorldPop assets can be discovered, prefetched, verified and cleared", {
  a <- mn_assets()
  expect_equal(sum(a$group == "worldpop"), 32)
  expect_true("worldpop_2025_100m" %in% a$id)
  withr::local_options(mongolmaps.cache_dir = withr::local_tempdir())
  row <- .mm_worldpop_row(2025L, "1km")
  path <- file.path(mn_cache_dir(), row$data_version, row$file)
  dir.create(dirname(path), recursive = TRUE)
  writeLines("fixture", path)
  writeLines(.mm_sha256(path), paste0(path, ".sha256"))
  expect_true(mn_cache_verify("worldpop_2025_1km")$checksum_ok)
  writeLines("changed", path)
  expect_false(mn_cache_verify("worldpop_2025_1km")$checksum_ok)
  local_mocked_bindings(.mm_asset_row = function(row, ...) row$file)
  expect_equal(unname(mn_download("worldpop_2025_1km")), row$file)
  suppressMessages(mn_cache_clear("worldpop"))
  expect_false(file.exists(path))
})

test_that("provenance distinguishes authority, source revisions and statistics", {
  p <- mn_provenance(mn_khoroos())
  expect_true("khoroos" %in% p$id)
  expect_match(p$authority[p$id == "khoroos"], "unofficial")
  expect_true(all(is.na(p$effective_date)))
  expect_match(mn_citation(mn_settlements()), "Wikidata")
  expect_true("data-v1" %in% mn_vintages()$data_version)
  expect_error(mn_aimags(boundary_version = "2015"), "Unsupported boundary version")
  expect_equal(mn_aimags(boundary_version = "data-v1"), mn_aimags())
  expect_equal(nrow(mn_provenance(data.frame(x = 1))), 0)
})

test_that("known codes at other levels do not become ambiguous bag numbers", {
  pop <- mn_example_population[mn_example_population$Year == 2025, ]
  expect_no_warning(x <- suppressMessages(mn_join(pop, "Region", within = "Ulaanbaatar")))
  expect_equal(nrow(x), 204)
  expect_equal(mn_match("1", level = "bag", within = "MN1107"), "MN110751")
  expect_equal(mn_match("1", within = "MN1107"), "MN110751")
  d <- suppressWarnings(mn_match("1", level = "bag", within = "Ulaanbaatar", details = TRUE, quiet = TRUE))
  expect_equal(d$status, "unmatched")
})

test_that("bag validation rejects invalid tolerances, nonpolygons and unknown parents", {
  expect_error(mn_read_bags("unused", nesting_tolerance = -1), "nesting_tolerance")
  expect_error(mn_read_bags("unused", nesting_tolerance = NA_real_), "nesting_tolerance")
  code <- mn_codes("bag", within = "MN8401")$nso_code[1]
  path <- withr::local_tempfile(fileext = ".gpkg")
  sf::st_write(sf::st_sf(code = code, geometry = sf::st_sfc(sf::st_point(c(91.65, 48)), crs = 4326)), path, quiet = TRUE)
  expect_error(mn_read_bags(path), "nonempty polygons")
  geom <- mn_soums("Khovd")[1, "pcode"]
  geom$pcode <- "unknown"
  expect_error(.mm_check_bag_nesting(geom), "outside")
})

test_that("asset locks prevent concurrent publishers and release cleanly", {
  root <- withr::local_tempdir()
  path <- file.path(root, "asset")
  lock <- .mm_lock_cache(path)
  expect_true(dir.exists(lock))
  expect_error(.mm_lock_cache(path), class = "mongolmaps_cache_busy_error")
  unlink(lock, recursive = TRUE)
  expect_false(dir.exists(lock))
})

test_that("protected-area payload validation rejects incomplete or unusable data", {
  path <- withr::local_tempfile(fileext = ".geojson")
  writeLines('{"exceededTransferLimit":true}', path)
  expect_error(.mm_validate_download(list(id = "wdpa"), path), "incomplete page")
  writeLines("not a spatial dataset", path)
  expect_error(suppressWarnings(.mm_validate_download(list(id = "wdpa"), path)), "unexpected schema")
})
