# A stand-in for the OSM release assets: a few features around Khovd city
# and central Ulaanbaatar, in the same layers and columns.
local_osm_fixture <- function(env = parent.frame()) {
  path <- withr::local_tempfile(fileext = ".gpkg", .local_envir = env)
  line <- function(x1, y1, x2, y2) sf::st_linestring(rbind(c(x1, y1), c(x2, y2)))
  sq <- function(x, y, d = 0.01) sf::st_polygon(list(rbind(c(x, y), c(x + d, y), c(x + d, y + d), c(x, y + d), c(x, y))))
  wgs <- function(g) sf::st_sfc(g, crs = 4326)
  roads <- sf::st_sf(
    osm_id = c("way/1", "way/2", "way/3"), name_en = c("Main St", "Side St", NA), name_mn = NA_character_,
    highway = c("primary", "residential", "track"), class = c("main", "minor", "track"), surface = NA_character_,
    geom = wgs(list(line(91.60, 48.00, 91.70, 48.02), line(106.90, 47.91, 106.95, 47.92), line(106.90, 47.90, 110, 47.90)))
  )
  railways <- sf::st_sf(
    osm_id = "way/9", name_en = "Trans-Mongolian", name_mn = NA_character_, railway = "rail",
    geom = wgs(list(line(106.8, 47.9, 107.0, 47.9)))
  )
  stations <- sf::st_sf(osm_id = "node/1", name_en = "Ulaanbaatar", name_mn = NA_character_, geom = wgs(list(sf::st_point(c(106.88, 47.92)))))
  airports <- sf::st_sf(
    osm_id = c("way/5", "way/6"), name_en = c("Khovd Airport", "Buyant-Ukhaa"), name_mn = NA_character_,
    geom = wgs(list(sf::st_point(c(91.63, 47.95)), sf::st_point(c(106.77, 47.84))))
  )
  waterways <- sf::st_sf(
    osm_id = "way/7", name_en = "Tuul", name_mn = "Туул", class = "river",
    geom = wgs(list(line(106.7, 47.88, 107.1, 47.89)))
  )
  water <- sf::st_sf(
    osm_id = "way/8", name_en = NA_character_, name_mn = NA_character_, class = "pond",
    geom = wgs(list(sf::st_multipolygon(list(sq(106.9, 47.9)))))
  )
  places <- sf::st_sf(
    osm_id = c("node/2", "node/3"), name_en = c("Khovd", "Tsetseg"), name_mn = c("Ховд", NA),
    place = c("city", "village"), population = c(28601L, NA),
    geom = wgs(list(sf::st_point(c(91.645, 48.0)), sf::st_point(c(93.3, 46.6))))
  )
  layers <- list(
    roads = roads, railways = railways, stations = stations, airports = airports,
    waterways = waterways, water = water, places = places
  )
  for (nm in names(layers)) sf::st_write(layers[[nm]], path, layer = nm, quiet = TRUE)
  testthat::local_mocked_bindings(.mm_asset = function(id, ...) path, .env = env)
  path
}

test_that("mn_roads() filters by class and place", {
  local_osm_fixture()
  main <- mn_roads()
  expect_s3_class(main, "sf")
  expect_equal(main$class, "main")
  expect_named(main, c("osm_id", "name", "name_en", "name_mn", "highway", "class", "surface", "geometry"))
  expect_equal(nrow(mn_roads(class = "all")), 3)
  ub <- mn_roads(class = c("minor", "track"), within = "Ulaanbaatar")
  expect_setequal(ub$class, c("minor", "track"))
  expect_true(all(sf::st_geometry_type(ub) == "MULTILINESTRING"))
  expect_lt(sf::st_bbox(ub)[["xmax"]], 110)
  expect_snapshot(mn_roads(class = "highway"), error = TRUE)
})

test_that("mn_railways(), mn_airports() and mn_places() read their layers", {
  local_osm_fixture()
  expect_equal(mn_railways()$railway, "rail")
  expect_true(all(sf::st_geometry_type(mn_railways(stations = TRUE)) == "POINT"))
  expect_equal(mn_airports(within = "Khovd")$name, "Khovd Airport")
  expect_equal(mn_places()$place, c("city", "village"))
  expect_equal(mn_places(type = "city", lang = "mn")$name, "Ховд")
  expect_equal(mn_places(type = "city", lang = "mns")$name, "Khovd")
  expect_equal(nrow(mn_places(within = "Uvs")), 0)
  expect_equal(sf::st_crs(mn_airports(crs = "utm")), sf::st_crs(32648))
})

test_that("mn_rivers() and mn_lakes() switch between Natural Earth and OSM", {
  local_osm_fixture()
  expect_equal(mn_rivers(detail = "all")$class, "river")
  expect_equal(mn_lakes(detail = "all", within = "Ulaanbaatar")$class, "pond")
  expect_true(all(sf::st_geometry_type(mn_lakes(detail = "all", within = "Ulaanbaatar")) == "MULTIPOLYGON"))
  khuvsgul <- mn_lakes(within = "Khuvsgul")
  expect_true("Khovsgol Nuur" %in% khuvsgul$name_en)
  expect_equal(attr(khuvsgul, "sf_column"), "geometry")
  expect_gt(nrow(mn_rivers(within = "Selenge")), 0)
})

test_that("places without a boundary cannot be used to clip layers", {
  local_osm_fixture()
  expect_snapshot(mn_roads(within = "MN6770"), error = TRUE)
})

test_that("mn_download() accepts layer groups", {
  local_mocked_bindings(.mm_asset = function(id, ...) paste0("/cache/", id))
  expect_setequal(names(mn_download("osm")), c("osm_roads", "osm_transport", "osm_water", "osm_places"))
})

test_that("clipping drops lines that only touch the area", {
  area <- sf::st_sfc(sf::st_polygon(list(rbind(c(0, 0), c(1, 0), c(1, 1), c(0, 1), c(0, 0)))), crs = 3857)
  touch <- sf::st_sf(id = 1, geometry = sf::st_sfc(sf::st_linestring(rbind(c(1, 0.5), c(2, 0.5))), crs = 3857))
  out <- suppressWarnings(.mm_clip(touch, area))
  expect_equal(nrow(out), 0)
  inside <- sf::st_sf(id = 1, geometry = sf::st_sfc(sf::st_linestring(rbind(c(0.2, 0.5), c(0.8, 0.5))), crs = 3857))
  expect_no_warning(out <- .mm_clip(inside, area))
  expect_equal(as.character(sf::st_geometry_type(out)), "MULTILINESTRING")
})

test_that("OSM layers follow the language option", {
  local_osm_fixture()
  withr::local_options(mongolmaps.lang = "mn")
  expect_equal(mn_places(type = "city")$name, "Ховд")
  roads <- mn_roads(lang = "en")
  expect_equal(roads$name, "Main St")
})
