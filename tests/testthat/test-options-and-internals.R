test_that("protocols_annotation collapses annotation values in order", {
  x <- list(
    list(parameterName = list(annotationValue = "Dose")),
    list(parameterName = list(annotationValue = "Time"))
  )

  expect_equal(metabolighteR:::protocols_annotation(x), "Dose; Time")
})

test_that("mtbls_key errors when API_KEY is not character", {
  expect_error(mtbls_key(100), "API_KEY must be a character")
})

test_that("mtbls_key stores explicit API key when env var is unset", {
  original_option <- getOption("MTBLS_API_KEY")
  original_env <- Sys.getenv("MTBLS_API_KEY", unset = NA_character_)

  on.exit({
    options(MTBLS_API_KEY = original_option)
    if (is.na(original_env)) {
      Sys.unsetenv("MTBLS_API_KEY")
    } else {
      Sys.setenv(MTBLS_API_KEY = original_env)
    }
  }, add = TRUE)

  Sys.unsetenv("MTBLS_API_KEY")
  mtbls_key("from-arg")

  expect_equal(getOption("MTBLS_API_KEY"), "from-arg")
})

test_that("mtbls_key prefers environment variable over explicit input", {
  original_option <- getOption("MTBLS_API_KEY")
  original_env <- Sys.getenv("MTBLS_API_KEY", unset = NA_character_)

  on.exit({
    options(MTBLS_API_KEY = original_option)
    if (is.na(original_env)) {
      Sys.unsetenv("MTBLS_API_KEY")
    } else {
      Sys.setenv(MTBLS_API_KEY = original_env)
    }
  }, add = TRUE)

  Sys.setenv(MTBLS_API_KEY = "from-env")
  mtbls_key("from-arg")

  expect_equal(getOption("MTBLS_API_KEY"), "from-env")
})

test_that(".onLoad configures the default BASE_URL option", {
  original_base_url <- getOption("BASE_URL")

  on.exit(options(BASE_URL = original_base_url), add = TRUE)

  options(BASE_URL = NULL)
  metabolighteR:::.onLoad(libname = tempdir(), pkgname = "metabolighteR")

  expect_equal(getOption("BASE_URL"), "https://www.ebi.ac.uk:443/metabolights/ws")
})

test_that("mtbls_get errors for authenticated requests without an API key", {
  original_api_key <- getOption("MTBLS_API_KEY")

  on.exit(options(MTBLS_API_KEY = original_api_key), add = TRUE)

  options(MTBLS_API_KEY = NULL)

  expect_error(
    metabolighteR:::mtbls_get("/studies/user", authenticate = TRUE),
    "MTBLS_API_KEY option is not configured"
  )
})

test_that("mtbls_api_spec_url derives the spec endpoint from BASE_URL", {
  original_base_url <- getOption("BASE_URL")

  on.exit(options(BASE_URL = original_base_url), add = TRUE)

  options(BASE_URL = "https://example.test/metabolights/ws")

  expect_equal(
    metabolighteR:::mtbls_api_spec_url(),
    "https://example.test/metabolights/ws/api/spec"
  )
})
