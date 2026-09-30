## Submission

This is a new release.

* The package bundles simplified administrative boundaries (about 0.4 MB)
  and downloads larger layers on request into `tools::R_user_dir("mongolmaps",
  "cache")`. The cache is managed by `mn_cache_clear()` and old data
  versions are removed automatically.
* Examples and tests do not use the network on CRAN: examples that download
  are wrapped in `@examplesIf` with `NOT_CRAN` and `curl::has_internet()`,
  and tests mock all downloads.
* Data sources and their licences are listed in `inst/COPYRIGHTS`.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.
