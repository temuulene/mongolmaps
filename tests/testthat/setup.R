withr::local_options(
  mongolmaps.cache_dir = withr::local_tempdir(.local_envir = teardown_env()),
  mongolmaps.quiet = FALSE,
  mongolmaps.lang = "en",
  .local_envir = teardown_env()
)
