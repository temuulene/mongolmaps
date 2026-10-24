#' Data sources, licences and citations
#'
#' `mn_sources()` lists every data layer in the package: who provides it,
#' under which licence, whether it ships with the package or is downloaded,
#' and how current it is. `mn_citation()` returns the attribution text to
#' put under a map; [mn_map()] adds it as a caption automatically.
#'
#' Please credit the data providers when you publish maps. Most layers are
#' under licences that require attribution (CC BY, ODbL).
#'
#' @param layer,layers Layer ids, such as `"admin"`, `"khoroos"` or
#'   `"settlements"`. `NULL` lists all layers. `mn_citation()` also accepts
#'   a tagged map or raster, using its attached source provenance.
#'
#' @return `mn_sources()`: a tibble with columns `id`, `title`, `group`,
#'   `delivery` (`"bundled"`, `"release"` or `"upstream"`), `provider`,
#'   `license`, `license_url`, `valid_on`, `source_url`, `attribution` and
#'   `notes`, plus source revision, code/geometry vintages, authority and
#'   effective date where known. `mn_citation()`: a single string.
#' @family data sources and cache
#' @export
#' @examples
#' mn_sources()
#' mn_citation(c("admin", "khoroos"))
mn_sources <- function(layer = NULL) {
  m <- .mm_manifest()
  if (!is.null(layer)) {
    unknown <- setdiff(layer, m$id)
    if (length(unknown)) .mm_abort("Unknown layer{?s}: {.val {unknown}}.", "input")
    m <- m[m$id %in% layer, ]
  }
  m <- .mm_source_metadata(m)
  m[c("id", "title", "group", "delivery", "provider", "license", "license_url", "valid_on",
      "source_url", "attribution", "notes", "data_version", "source_revision", "geometry_vintage",
      "code_vintage", "effective_date", "authority")]
}

#' @rdname mn_sources
#' @export
mn_citation <- function(layers = "admin") {
  s <- if (is.character(layers)) mn_sources(layers) else mn_provenance(layers)
  if (!nrow(s)) return("")
  paste(unique(s$attribution), collapse = "; ")
}
