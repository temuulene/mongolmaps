# Build the Mongolian website into docs/mn/, next to the English site.
#
# Run from the package root after the English site is built:
#   Rscript pkgdown/build-mn.R
# The package must be installed. The Mongolian sources live in pkgdown/mn/:
# _pkgdown.yml (site settings), index.Rmd (home page), articles/*.Rmd and
# man/*.Rd (reference pages, see pkgdown/mn-reference.R).

root <- normalizePath(".", winslash = "/")
src <- file.path(root, "pkgdown", "mn")
dest <- file.path(root, "docs", "mn")

# Work on a copy of the package with the Mongolian pages in place of the
# English ones.
tmp <- file.path(tempdir(), "mongolmaps-mn")
unlink(tmp, recursive = TRUE)
dir.create(tmp)
skip <- c("docs", "vignettes", "README.Rmd", "README.md", "_pkgdown.yml", "data-raw", "tests")
entries <- setdiff(list.files(root, all.files = TRUE, no.. = TRUE), skip)
# Hidden folders (version control, CI, local editor settings) are not part of the site
entries <- entries[!(startsWith(entries, ".") & dir.exists(file.path(root, entries)))]
file.copy(file.path(root, entries), tmp, recursive = TRUE)

file.copy(file.path(src, "_pkgdown.yml"), file.path(tmp, "_pkgdown.yml"))
# Mongolian labels for the parts of the pkgdown interface it cannot translate.
dir.create(file.path(tmp, "pkgdown"), showWarnings = FALSE)
file.copy(file.path(src, "extra.js"), file.path(tmp, "pkgdown", "extra.js"), overwrite = TRUE)
dir.create(file.path(tmp, "vignettes", "articles"), recursive = TRUE)
file.copy(list.files(file.path(src, "articles"), full.names = TRUE), file.path(tmp, "vignettes", "articles"))

# Reference pages: Mongolian prose merged into the English help pages.
source(file.path(root, "pkgdown", "mn-reference.R"), chdir = FALSE)
translate_man(file.path(tmp, "man"))

# Home page: knit index.Rmd to index.md, with its figures in man/figures/.
file.copy(file.path(src, "index.Rmd"), file.path(tmp, "index.Rmd"))
rmarkdown::render(
  file.path(tmp, "index.Rmd"),
  output_format = rmarkdown::github_document(html_preview = FALSE),
  quiet = TRUE
)
unlink(file.path(tmp, "index.Rmd"))

# Build in the temporary copy, then copy into place (deleting a folder that a
# sync client holds open can fail half-way).
site <- file.path(tmp, "site")
pkgdown::build_site(
  tmp,
  override = list(destination = site),
  preview = FALSE,
  install = FALSE,
  new_process = FALSE
)
unlink(dest, recursive = TRUE)
dir.create(dest, recursive = TRUE, showWarnings = FALSE)
file.copy(list.files(site, full.names = TRUE, all.files = TRUE, no.. = TRUE), dest, recursive = TRUE, overwrite = TRUE)
message("Mongolian site written to ", dest)
