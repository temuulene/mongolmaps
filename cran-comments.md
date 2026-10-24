## Update from 0.1.0 to 0.2.0

This update adds auditable spatial joins and matching diagnostics, source
provenance, Ulaanbaatar inset maps, bag-boundary validation and cache-integrity
helpers. It corrects fractional raster summaries, population-total
preservation during reprojection and Ulaanbaatar region/capital joins.
There are no changes to the maintainer, package licence or bundled data licences.

## Offline checks and downloaded data

Examples requiring remote data run only when NOT_CRAN is explicitly true.
CRAN-mode tests use temporary fixtures and mocked downloads. Remote data are
downloaded only on request into tools::R_user_dir("mongolmaps", "cache");
mn_cache_list(), mn_cache_verify() and mn_cache_clear() manage the cache.
Old revisions can be removed explicitly with mn_cache_clear(old_versions = TRUE).
Sources and their licences are documented in inst/COPYRIGHTS.

The mn_bags() file-import example requires boundary data supplied by the
National Statistics Office of Mongolia on request; it cannot run without
that file. The help page also runs mn_bags() without a file to show guidance.

## Check environments

The source package was built with R CMD build on Windows with R 4.6.1,
including all vignettes. GitHub Actions checks cover Linux R-devel, R-release
and R-oldrel-1, Windows R-release and macOS R-release, with --as-cran and
NOT_CRAN=false. Incoming feasibility checks are performed by CRAN.

The current CRAN page lists no reverse dependencies. Mongolian terms in
DESCRIPTION (aimags, soums, khoroos, Ulaanbaatar) and the terms crosswalk and
subdistricts are intentional.

## R CMD check results

0 errors | 0 warnings | 0 notes on all five GitHub Actions check jobs.

Check run: https://github.com/temuulene/mongolmaps/actions/runs/40072467903
