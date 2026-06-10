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

test_that("mtbls_get errors when BASE_URL is not configured", {
  original_base_url <- getOption("BASE_URL")

  on.exit(options(BASE_URL = original_base_url), add = TRUE)

  options(BASE_URL = NULL)

  expect_error(
    metabolighteR:::mtbls_get("/studies"),
    "BASE_URL option is not configured"
  )
})

test_that("mtbls_get errors when timeout is invalid", {
  original_base_url <- getOption("BASE_URL")
  original_timeout <- getOption("metabolighteR.timeout")

  on.exit({
    options(BASE_URL = original_base_url)
    options(metabolighteR.timeout = original_timeout)
  }, add = TRUE)

  options(
    BASE_URL = "https://example.test/metabolights/ws",
    metabolighteR.timeout = 0
  )

  expect_error(
    metabolighteR:::mtbls_get("/studies"),
    "metabolighteR.timeout option must be a positive number"
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

test_that("mtbls_get applies timeout and package user agent", {
  captured <- NULL
  original_base_url <- getOption("BASE_URL")
  original_timeout <- getOption("metabolighteR.timeout")

  on.exit({
    options(BASE_URL = original_base_url)
    options(metabolighteR.timeout = original_timeout)
  }, add = TRUE)

  options(
    BASE_URL = "https://example.test/metabolights/ws",
    metabolighteR.timeout = 12
  )

  testthat::local_mocked_bindings(
    GET = function(url, ...) {
      captured <<- list(url = url, dots = list(...))
      structure(list(), class = "fake_response")
    },
    content = function(...) list(ok = TRUE),
    timeout = function(seconds) list(timeout = seconds),
    user_agent = function(agent) list(agent = agent),
    .package = "httr"
  )

  out <- metabolighteR:::mtbls_get("/studies")

  expect_equal(captured$url, "https://example.test/metabolights/ws/studies")
  expect_equal(captured$dots[[1]]$timeout, 12)
  expect_match(captured$dots[[2]]$agent, "^metabolighteR/")
  expect_true(out$ok)
})

test_that("mtbls_get retries transient request failures", {
  attempt <- 0
  original_base_url <- getOption("BASE_URL")

  on.exit(options(BASE_URL = original_base_url), add = TRUE)

  options(BASE_URL = "https://example.test/metabolights/ws")

  testthat::local_mocked_bindings(
    GET = function(...) {
      attempt <<- attempt + 1
      if (attempt < 3) {
        stop("temporary network issue")
      }
      structure(list(), class = "fake_response")
    },
    content = function(...) list(ok = TRUE),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- metabolighteR:::mtbls_get("/studies")

  expect_equal(attempt, 3)
  expect_true(out$ok)
})

test_that("mtbls_get errors after repeated request failures", {
  original_base_url <- getOption("BASE_URL")

  on.exit(options(BASE_URL = original_base_url), add = TRUE)

  options(BASE_URL = "https://example.test/metabolights/ws")

  testthat::local_mocked_bindings(
    GET = function(...) {
      stop("persistent network issue")
    },
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  expect_error(
    metabolighteR:::mtbls_get("/studies"),
    "MetaboLights request failed for `/studies`: persistent network issue"
  )
})

test_that("mtbls_get retries transient server responses before succeeding", {
  attempt <- 0
  original_base_url <- getOption("BASE_URL")

  on.exit(options(BASE_URL = original_base_url), add = TRUE)

  options(BASE_URL = "https://example.test/metabolights/ws")

  testthat::local_mocked_bindings(
    GET = function(...) {
      attempt <<- attempt + 1
      if (attempt < 3) {
        return(structure(list(status_code = 503), class = "response"))
      }
      structure(list(status_code = 200), class = "response")
    },
    stop_for_status = function(response) {
      if (response$status_code >= 400) {
        stop(sprintf("HTTP %s", response$status_code))
      }
      invisible(response)
    },
    content = function(...) list(ok = TRUE),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- metabolighteR:::mtbls_get("/studies")

  expect_equal(attempt, 3)
  expect_true(out$ok)
})

test_that("mtbls_get wraps non-retriable HTTP errors", {
  original_base_url <- getOption("BASE_URL")

  on.exit(options(BASE_URL = original_base_url), add = TRUE)

  options(BASE_URL = "https://example.test/metabolights/ws")

  testthat::local_mocked_bindings(
    GET = function(...) {
      structure(list(status_code = 404), class = "response")
    },
    stop_for_status = function(...) {
      stop("Not Found")
    },
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  expect_error(
    metabolighteR:::mtbls_get("/studies"),
    "MetaboLights request failed for `/studies`: Not Found"
  )
})

test_that("mtbls_get wraps content parsing failures", {
  original_base_url <- getOption("BASE_URL")

  on.exit(options(BASE_URL = original_base_url), add = TRUE)

  options(BASE_URL = "https://example.test/metabolights/ws")

  testthat::local_mocked_bindings(
    GET = function(...) {
      structure(list(status_code = 200), class = "response")
    },
    stop_for_status = function(...) NULL,
    content = function(...) {
      stop("bad payload")
    },
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  expect_error(
    metabolighteR:::mtbls_get("/studies"),
    "Failed to parse MetaboLights response for `/studies`: bad payload"
  )
})
