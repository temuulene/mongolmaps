# Upload the release assets built by 04-11 to the GitHub release that the
# manifest points to. Needs the GitHub CLI (gh) with access to
# temuulene/mongolmaps. Run only when the data change: the tag is the data
# version, and published assets must never change under the same tag.

source("data-raw/00_config.R")

manifest <- utils::read.csv("inst/extdata/manifest.csv", colClasses = "character")
files <- file.path(build_path("release"), manifest$file[manifest$delivery == "release"])
stopifnot(all(file.exists(files)))

repo <- "temuulene/mongolmaps"
exists <- system2("gh", c("release", "view", data_version, "--repo", repo), stdout = FALSE, stderr = FALSE) == 0
if (exists) stop("Release ", data_version, " already exists; bump data_version in 00_config.R for new data.")

notes <- paste(
  "Data assets for mongolmaps. Sources and licences: see inst/COPYRIGHTS and mn_sources().",
  "OpenStreetMap files are (c) OpenStreetMap contributors under the ODbL."
)
system2("gh", c("release", "create", data_version, shQuote(files), "--repo", repo, "--title", data_version, "--notes", shQuote(notes)))
