withr::local_options(
  mongolmaps.cache_dir = withr::local_tempdir(.local_envir = teardown_env()),
  mongolmaps.quiet = FALSE,
  mongolmaps.lang = "en",
  .local_envir = teardown_env()
)

# Grob tests open a graphics device; keep it off disk (no stray Rplots.pdf).
grDevices::pdf(NULL)
withr::defer(grDevices::dev.off(), teardown_env())
