## Submission

This is a new release.

* The package bundles simplified administrative boundaries (about 0.4 MB)
  and downloads larger layers on request into `tools::R_user_dir("mongolmaps",
  "cache")`. The cache is managed by `mn_cache_clear()` and old data
  versions are removed automatically.
* Examples and tests do not use the network on CRAN: examples that download
  are wrapped in `@examplesIf` with `NOT_CRAN` and `curl::has_internet()`,
  and tests mock all downloads.
* The one `\dontrun{}` example (`mn_bags()`) needs a bag boundary file that
  the National Statistics Office of Mongolia provides on request; it is not
  public, so the example cannot run. The same help page runs `mn_bags()`
  without the file to show its guidance.
* Data sources and their licences are listed in `inst/COPYRIGHTS`.
* Words that may be flagged as misspelled in DESCRIPTION are Mongolian
  administrative units and place names (aimags, soums, khoroos, Ulaanbaatar)
  or standard terms (crosswalk, subdistricts).

## Test environments

* Local: Windows 11, R 4.6.1
* GitHub Actions: ubuntu-latest (R devel, release, oldrel-1),
  windows-latest (release), macos-latest (release)
* win-builder: R-devel

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.
