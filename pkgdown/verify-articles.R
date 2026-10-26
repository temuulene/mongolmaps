# Validate the rendered guides before publishing either language.
# Run after both site builds: Rscript pkgdown/verify-articles.R [site-directory]
args <- commandArgs(trailingOnly = TRUE)
root <- if (length(args)) args[[1]] else "docs"
expected <- c(
  mongolmaps = 4L, ulaanbaatar = 5L, `joining-data` = 4L,
  `names-and-codes` = 0L, `audited-workflows` = 4L,
  `thematic-layers` = 4L, `terrain-population` = 6L,
  `bags-from-nso` = 0L
)
problems <- character()
for (language in c("", "mn")) {
  article_dir <- file.path(root, language, "articles")
  for (name in names(expected)) {
    path <- file.path(article_dir, paste0(name, ".html"))
    if (!file.exists(path)) {
      problems <- c(problems, paste("Missing article:", path))
      next
    }
    page <- xml2::read_html(path)
    figures <- xml2::xml_find_all(page, "//main//img[contains(@src, 'figure-html/')]")
    if (length(figures) < expected[[name]]) {
      problems <- c(problems, sprintf("%s: expected at least %d figures, found %d",
                                     path, expected[[name]], length(figures)))
    }
    images <- xml2::xml_find_all(page, "//img")
    sources <- xml2::xml_attr(images, "src")
    local <- !is.na(sources) & !grepl("^(https?:|data:|//)", sources)
    missing <- sources[local][!file.exists(file.path(dirname(path), sub("[?#].*$", "", sources[local])))]
    if (length(missing)) problems <- c(problems, paste(path, "missing image:", missing))
    alt <- xml2::xml_attr(figures, "alt")
    if (any(is.na(alt) | !nzchar(trimws(alt)))) {
      problems <- c(problems, paste(path, "has figures without alternative text"))
    }
    if (name == "ulaanbaatar") {
      widget <- xml2::xml_find_all(page, "//div[contains(@class, 'leaflet') and contains(@class, 'html-widget')]")
      if (!length(widget)) problems <- c(problems, paste(path, "is missing its interactive map"))
    }
    code <- xml2::xml_text(xml2::xml_find_all(page, "//main//pre"))
    # The name-matching guide deliberately demonstrates ambiguous/fuzzy warnings.
    if (name != "names-and-codes" &&
        any(grepl("#>.*(Warning|Error in|no non-missing arguments)", code))) {
      problems <- c(problems, paste(path, "contains an unexpected rendered warning or error"))
    }
    links <- xml2::xml_attr(xml2::xml_find_all(page, "//main//a[@href]"), "href")
    links <- links[!is.na(links) & grepl("^[^:/#]+[.]html([#].*)?$", links)]
    absent <- links[!file.exists(file.path(dirname(path), sub("#.*$", "", links)))]
    if (length(absent)) problems <- c(problems, paste(path, "broken article link:", absent))
    message("Checked ", path, ": ", length(figures), " figures")
  }
}
if (length(problems)) stop(paste(problems, collapse = "\n"), call. = FALSE)
message("All 16 guides have the expected figures, image files and article links.")
