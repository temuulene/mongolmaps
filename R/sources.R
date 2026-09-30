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
#'   `"settlements"`. `NULL` lists all layers.
#'
#' @return `mn_sources()`: a tibble with columns `id`, `title`, `group`,
#'   `delivery` (`"bundled"`, `"release"` or `"upstream"`), `provider`,
#'   `license`, `license_url`, `valid_on`, `source_url`, `attribution` and
#'   `notes`. `mn_citation()`: a single string.
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
  m[c("id", "title", "group", "delivery", "provider", "license", "license_url", "valid_on", "source_url", "attribution", "notes")]
}

#' @rdname mn_sources
#' @export
mn_citation <- function(layers = "admin") {
  s <- mn_sources(layers)
  paste(unique(s$attribution), collapse = "; ")
}
