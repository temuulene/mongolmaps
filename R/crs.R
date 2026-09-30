.mm_albers <- paste(
  "+proj=aea +lat_0=47 +lon_0=104 +lat_1=43.5 +lat_2=50.5",
  "+x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
)

.mm_lcc <- paste(
  "+proj=lcc +lat_0=47 +lon_0=104 +lat_1=43.5 +lat_2=50.5",
  "+x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
)

#' Coordinate reference systems suited to Mongolia
#'
#' Returns a projection that keeps Mongolia's shape and area true. Maps of
#' the whole country look best in an equal-area Albers or Lambert conic
#' projection centred on Mongolia; maps of Ulaanbaatar look best in UTM
#' zone 48N.
#'
#' @param type One of:
#'   * `"albers"`: Albers equal-area conic centred on 104E, 47N, with
#'     standard parallels 43.5N and 50.5N. Best for national choropleths
#'     because areas are true.
#'   * `"lcc"`: Lambert conformal conic with the same parameters. Keeps
#'     local shapes true.
#'   * `"utm"`: UTM zone 48N (EPSG:32648), the usual choice for
#'     Ulaanbaatar and central Mongolia.
#'   * `"wgs84"`: plain longitude and latitude (EPSG:4326).
#'
#' @return An [sf::st_crs()] object.
#' @family mapping helpers
#' @export
#' @examples
#' mn_crs()
#' sf::st_transform(mn_aimags(), mn_crs("albers"))
mn_crs <- function(type = c("albers", "lcc", "utm", "wgs84")) {
  type <- rlang::arg_match(type)
  switch(type,
    albers = sf::st_crs(.mm_albers),
    lcc = sf::st_crs(.mm_lcc),
    utm = sf::st_crs(32648),
    wgs84 = sf::st_crs(4326)
  )
}

# Resolves a user `crs` argument: NULL keeps longitude/latitude, a keyword
# picks a Mongolia projection, anything else goes to sf::st_crs().
.mm_resolve_crs <- function(crs, call = rlang::caller_env()) {
  if (is.null(crs)) {
    return(NULL)
  }
  if (is.character(crs) && length(crs) == 1 && crs %in% c("albers", "lcc", "utm", "wgs84")) {
    return(mn_crs(crs))
  }
  out <- tryCatch(sf::st_crs(crs), error = function(e) e)
  if (inherits(out, "error") || is.na(out)) {
    cli_abort(
      c(
        "{.arg crs} must be {.val albers}, {.val lcc}, {.val utm}, {.val wgs84}, an EPSG code or an {.cls crs}.",
        "x" = "Could not interpret {.code {format(crs)}}."
      ),
      class = c("mongolmaps_input_error", "mongolmaps_error"),
      call = call
    )
  }
  out
}

.mm_transform <- function(x, crs, call = rlang::caller_env()) {
  crs <- .mm_resolve_crs(crs, call = call)
  if (is.null(crs)) x else sf::st_transform(x, crs)
}
