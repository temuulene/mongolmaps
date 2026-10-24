#' Inspect source provenance and available boundary revisions
#'
#' Provenance records distinguish the source snapshot from its effective
#' date, which is unknown for several layers. A high resolution or recent
#' download does not make an unofficial source authoritative.
#'
#' @param x An object returned by mongolmaps.
#' @param layer Optional source layer ids, as in [mn_sources()].
#' @return `mn_provenance()`: a tibble of source metadata attached to the
#'   object, or an empty tibble for an untagged object. `mn_vintages()`:
#'   a catalog of currently available administrative source snapshots.
#'   `effective_date` is missing unless independently established.
#'   Metadata are attributes, so reconstructing objects may remove them.
#' @family data sources and cache
#' @export
#' @examples
#' mn_provenance(mn_aimags())
#' mn_vintages()
mn_provenance <- function(x) {
  attr(x, "mongolmaps_provenance", exact = TRUE) %||% tibble::tibble()
}

#' @rdname mn_provenance
#' @export
mn_vintages <- function(layer = NULL) {
  s <- mn_sources(layer)
  s[s$group == "admin", c("id", "data_version", "geometry_vintage", "code_vintage",
                          "source_revision", "effective_date", "authority", "notes")]
}

.mm_source_metadata <- function(m) {
  m$source_revision <- m$valid_on
  m$geometry_vintage <- NA_character_
  m$code_vintage <- NA_character_
  m$effective_date <- NA_character_
  m$authority <- "source snapshot"
  admin <- m$id %in% c("admin", "admin_high")
  m$geometry_vintage[admin] <- "COD 2020; Ulaanbaatar khoroo-derived 2026"
  m$authority[admin] <- "official COD source; Ulaanbaatar internal lines derived/unofficial"
  kh <- m$id == "khoroos"
  m$source_revision[kh] <- "bb1bf18f27e57d7a5aa7fe6d4a17234b40e162c1"
  m$geometry_vintage[kh] <- "2026 source snapshot; effective date unknown"
  m$authority[kh] <- "unofficial; reconciled to COD outline"
  m$code_vintage[m$group == "admin"] <- "NSO 2025 snapshot"
  m
}

.mm_set_provenance <- function(x, provenance) {
  if (nrow(provenance)) {
    if (inherits(x, "sf")) provenance$crs <- sf::st_crs(x)$input
    if (inherits(x, "SpatRaster")) provenance$crs <- terra::crs(x)
  }
  attr(x, "mongolmaps_provenance") <- provenance
  x
}

.mm_tag <- function(x, ids, resolution = NA_character_) {
  p <- mn_sources(unique(ids))
  p$resolution <- rep_len(as.character(resolution), nrow(p))
  p$retrieved_on <- vapply(seq_len(nrow(p)), function(i) {
    row <- .mm_manifest_row(p$id[i])
    if (is.na(row$file)) return(NA_character_)
    path <- file.path(mn_cache_dir(), row$data_version, row$file)
    if (file.exists(path)) as.character(as.Date(file.info(path)$mtime)) else NA_character_
  }, character(1))
  p$crs <- tryCatch(sf::st_crs(x)$input, error = function(e) NA_character_)
  .mm_set_provenance(x, p)
}

.mm_combine_provenance <- function(...) {
  p <- dplyr::bind_rows(lapply(list(...), mn_provenance))
  if (!nrow(p)) return(p)
  p[!duplicated(p), , drop = FALSE]
}

.mm_tag_bags <- function(x, path) {
  p <- mn_sources("codes")
  p$id <- "user_bags"
  p$title <- "User-provided bag boundaries"
  p$provider <- "User-provided file; authority not verified"
  p$delivery <- "local"
  p$license <- "Check the supplied file's terms"
  p$source_url <- normalizePath(path, winslash = "/", mustWork = TRUE)
  p$attribution <- "Bag boundaries: user-provided file (verify provider and terms)"
  p$source_revision <- .mm_sha256(path)
  p$geometry_vintage <- NA_character_
  p$valid_on <- NA_character_
  p$authority <- "user-provided; not independently verified"
  p$effective_date <- NA_character_
  p$resolution <- "supplied"
  p$retrieved_on <- as.character(as.Date(file.info(path)$mtime))
  p$notes <- "Repeated codes dissolved; area measured from supplied geometry."
  p$crs <- sf::st_crs(x)$input
  .mm_set_provenance(x, p)
}

.mm_check_boundary_version <- function(boundary_version) {
  if (!is.null(boundary_version) && !identical(boundary_version, .mm_data_version)) {
    .mm_abort(
      c("Unsupported boundary version {.val {boundary_version}}.",
        "i" = "Only {.val {(.mm_data_version)}} is available; see {.fn mn_vintages}. Statistical years do not select historical geometry."),
      "input"
    )
  }
  invisible(.mm_data_version)
}
