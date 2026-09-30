# Mongolian reference pages.
#
# pkgdown/mn/man/*.Rd hold Mongolian translations of the prose of man/*.Rd:
# title, description, arguments, value, details, sections, format and source.
# The build merges each translation into its English file, so function
# signatures, examples and cross-references always come from the English
# documentation and cannot go out of date.
#
# The first line of each translation records the md5 of the English file it
# was translated from. When the English documentation changes, `check`
# reports the translation as out of date; after updating it, `stamp` records
# the new fingerprint.
#
#   Rscript pkgdown/mn-reference.R check          # report missing or stale
#   Rscript pkgdown/mn-reference.R stamp mn_map   # after updating mn_map.Rd
#   Rscript pkgdown/mn-reference.R stamp          # stamp all translations

mn_man_dir <- file.path("pkgdown", "mn", "man")

`%||%` <- function(x, y) if (is.null(x)) y else x

# md5 of an Rd file, independent of line endings.
rd_md5 <- function(path) {
  lines <- sub("\r$", "", readLines(path, warn = FALSE, encoding = "UTF-8"))
  tmp <- tempfile()
  on.exit(unlink(tmp))
  writeBin(charToRaw(enc2utf8(paste0(paste(lines, collapse = "\n"), "\n"))), tmp)
  unname(tools::md5sum(tmp))
}

recorded_md5 <- function(path) {
  first <- readLines(path, n = 1, warn = FALSE, encoding = "UTF-8")
  sub("^% source: man/\\S+ md5 (\\S+).*$", "\\1", first)
}

rd_tags <- function(rd) {
  vapply(rd, function(x) attr(x, "Rd_tag") %||% "", character(1))
}

# Family headings in "See also" and labels in the package overview.
mn_labels <- c(
  "Other admin boundaries:" = "Хил хязгаарын бусад функц:",
  "Other names and codes:" = "Нэр, кодын бусад функц:",
  "Other joining data:" = "Өгөгдөл холбох бусад:",
  "Other mapping helpers:" = "Газрын зураг зурах бусад функц:",
  "Other thematic layers:" = "Сэдэвчилсэн бусад давхарга:",
  "Other raster layers:" = "Растерийн бусад давхарга:",
  "Other data sources and cache:" = "Эх сурвалж, кэшийн бусад функц:",
  "Useful links:" = "Холбоос:",
  "Report bugs at" = "Алдаа мэдээлэх:",
  "\\strong{Maintainer}" = "\\strong{Хариуцагч}",
  "Authors:" = "Зохиогчид:",
  "[copyright holder]" = "[зохиогчийн эрх эзэмшигч]"
)

# The English Rd with its prose replaced by the Mongolian translation.
merge_rd <- function(en_path, mn_path) {
  en <- tools::parse_Rd(en_path, encoding = "UTF-8", permissive = TRUE)
  mn <- tools::parse_Rd(mn_path, encoding = "UTF-8", permissive = TRUE)
  en_tags <- rd_tags(en)
  mn_tags <- rd_tags(mn)
  for (tag in c("\\title", "\\description", "\\arguments", "\\value", "\\details", "\\format", "\\source")) {
    if (tag %in% en_tags && tag %in% mn_tags) {
      en[[which(en_tags == tag)[1]]] <- mn[[which(mn_tags == tag)[1]]]
    }
  }
  en_sections <- which(en_tags == "\\section")
  mn_sections <- which(mn_tags == "\\section")
  for (i in seq_along(en_sections)[seq_along(en_sections) <= length(mn_sections)]) {
    en[[en_sections[i]]] <- mn[[mn_sections[i]]]
  }
  text <- paste(as.character(en, deparse = TRUE), collapse = "")
  for (en_label in names(mn_labels)) {
    text <- gsub(en_label, mn_labels[[en_label]], text, fixed = TRUE)
  }
  text
}

# Writes merged Mongolian Rd files over the English ones in `man_dir`.
translate_man <- function(man_dir) {
  for (mn_path in list.files(mn_man_dir, "\\.Rd$", full.names = TRUE)) {
    en_path <- file.path(man_dir, basename(mn_path))
    if (!file.exists(en_path)) next
    merged <- merge_rd(en_path, mn_path)
    writeLines(enc2utf8(merged), en_path, useBytes = TRUE)
  }
}

check_translations <- function() {
  en <- basename(list.files("man", "\\.Rd$"))
  mn <- basename(list.files(mn_man_dir, "\\.Rd$"))
  problems <- c(
    stats::setNames(rep("has no Mongolian translation", length(setdiff(en, mn))), setdiff(en, mn)),
    stats::setNames(rep("translates a help page that no longer exists", length(setdiff(mn, en))), setdiff(mn, en))
  )
  for (f in intersect(en, mn)) {
    if (!identical(recorded_md5(file.path(mn_man_dir, f)), rd_md5(file.path("man", f)))) {
      problems[[f]] <- "is out of date: the English help page changed since it was translated"
    }
  }
  in_actions <- identical(Sys.getenv("GITHUB_ACTIONS"), "true")
  for (f in names(problems)) {
    msg <- paste0("Mongolian reference page ", f, " ", problems[[f]], ".")
    if (in_actions) cat("::warning file=", file.path(mn_man_dir, f), "::", msg, "\n", sep = "") else message(msg)
  }
  if (!length(problems)) message("All Mongolian reference pages are up to date.")
  invisible(problems)
}

stamp_translations <- function(topics = NULL) {
  files <- if (length(topics)) file.path(mn_man_dir, paste0(sub("\\.Rd$", "", topics), ".Rd")) else
    list.files(mn_man_dir, "\\.Rd$", full.names = TRUE)
  for (path in files) {
    lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
    lines[1] <- paste0("% source: man/", basename(path), " md5 ", rd_md5(file.path("man", basename(path))))
    writeLines(enc2utf8(lines), path, useBytes = TRUE)
  }
  message("Stamped ", length(files), " translation(s).")
}

if (!interactive() && sys.nframe() == 0L) {
  args <- commandArgs(trailingOnly = TRUE)
  switch(args[1] %||% "check",
    check = check_translations(),
    stamp = stamp_translations(args[-1]),
    stop("Unknown command: ", args[1])
  )
}
