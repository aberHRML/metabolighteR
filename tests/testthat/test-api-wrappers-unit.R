test_that("all_get_methods filters to public GET endpoints", {
  testthat::local_mocked_bindings(
    fromJSON = function(...) {
      list(
        apis = list(
          path = c("/studies", "/submit", "/ebi-internal/audit"),
          description = c("Studies", "Submit", "Internal"),
          notes = c("", "", ""),
          operations = list(
            data.frame(method = "get", summary = "List studies", stringsAsFactors = FALSE),
            data.frame(method = "post", summary = "Create study", stringsAsFactors = FALSE),
            data.frame(method = "get", summary = "Internal audit", stringsAsFactors = FALSE)
          )
        )
      )
    },
    .package = "jsonlite"
  )

  out <- all_get_methods()

  expect_s3_class(out, "tbl_df")
  expect_equal(out$method, "/studies")
  expect_equal(out$description, "List studies")
})

test_that("download_study_file parses tab-delimited text content", {
  captured <- NULL

  testthat::local_mocked_bindings(
    GET = function(url, ...) {
      captured <<- url
      structure(list(), class = "fake_response")
    },
    content = function(..., as = NULL) "col1\tcol2\nA\tB\n",
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  original_base_url <- getOption("BASE_URL")
  on.exit(options(BASE_URL = original_base_url), add = TRUE)

  options(BASE_URL = "https://example.test")

  out <- download_study_file("MTBLS1", "table name.tsv")

  expect_s3_class(out, "tbl_df")
  expect_equal(out$col1, "A")
  expect_equal(out$col2, "B")
  expect_equal(
    captured,
    "https://example.test/studies/MTBLS1/download?file=table%20name.tsv"
  )
})

test_that("get_isa_investigation uses authenticated investigation endpoint", {
  captured <- NULL

  testthat::local_mocked_bindings(
    GET = function(url, ...) {
      captured <<- list(url = url, dots = list(...))
      structure(list(), class = "fake_response")
    },
    content = function(...) "INVESTIGATION",
    add_headers = function(...) list(...),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  original_base_url <- getOption("BASE_URL")
  original_api_key <- getOption("MTBLS_API_KEY")
  on.exit(options(BASE_URL = original_base_url, MTBLS_API_KEY = original_api_key), add = TRUE)

  options(BASE_URL = "https://example.test", MTBLS_API_KEY = "secret")

  out <- get_isa_investigation("MTBLS1")

  expect_equal(captured$url, "https://example.test/studies/MTBLS1/investigation")
  expect_true(any(vapply(
    captured$dots,
    function(x) is.list(x) && identical(x$user_token, "secret"),
    logical(1)
  )))
  expect_equal(out, "INVESTIGATION")
})

test_that("get_private_studies returns a tibble when studies exist", {
  original_api_key <- getOption("MTBLS_API_KEY")
  on.exit(options(MTBLS_API_KEY = original_api_key), add = TRUE)

  options(MTBLS_API_KEY = "secret")

  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) list(data = c("MTBLS1", "MTBLS2")),
    add_headers = function(...) list(...),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_private_studies()

  expect_s3_class(out, "tbl_df")
  expect_equal(names(out), "study")
  expect_equal(unname(out$study), c("MTBLS1", "MTBLS2"))
})

test_that("get_private_studies returns invisible NULL with a message when no data exist", {
  original_api_key <- getOption("MTBLS_API_KEY")
  on.exit(options(MTBLS_API_KEY = original_api_key), add = TRUE)

  options(MTBLS_API_KEY = "secret")

  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) list(data = list()),
    add_headers = function(...) list(...),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  expect_message(result <- get_private_studies(), "No private studies found")
  expect_null(result)
})

test_that("get_studies returns a tibble of study ids", {
  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) list("MTBLS1", "MTBLS2"),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_studies()

  expect_s3_class(out, "tbl_df")
  expect_equal(out$study, c("MTBLS1", "MTBLS2"))
})

test_that("get_study_assay_file returns assay filenames", {
  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) list(data = list(assays = list(fileA = "a.txt", fileB = "b.txt"))),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_study_assay_file("MTBLS1")

  expect_equal(unname(out), c("a.txt", "b.txt"))
})

test_that("get_study_assay_list returns the first assay entry", {
  assay <- list(name = "assay1", platform = "LC-MS")

  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) list(data = list(assays = list(assay, list(name = "assay2")))),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_study_assay_list("MTBLS1")

  expect_equal(out, assay)
})

test_that("get_study_audit returns parsed audit content", {
  original_api_key <- getOption("MTBLS_API_KEY")
  on.exit(options(MTBLS_API_KEY = original_api_key), add = TRUE)

  options(MTBLS_API_KEY = "secret")

  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) list(entries = c("audit1", "audit2")),
    add_headers = function(...) list(...),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_study_audit("MTBLS1")

  expect_equal(out$entries, c("audit1", "audit2"))
})

test_that("get_study_contacts flattens contacts into a tibble", {
  payload <- list(
    contacts = list(
      list(
        firstName = "Ada",
        lastName = "Lovelace",
        email = "ada@example.org",
        affiliation = "Example Lab",
        address = "1 Example Street",
        fax = "123",
        midInitials = "A",
        phone = "555",
        roles = "author"
      ),
      list(
        firstName = "Grace",
        lastName = "Hopper",
        email = "grace@example.org",
        affiliation = "Navy",
        address = "2 Example Street",
        fax = "456",
        midInitials = "B",
        phone = "777",
        roles = "submitter"
      )
    )
  )

  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) payload,
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_study_contacts("MTBLS1")

  expect_s3_class(out, "tbl_df")
  expect_equal(nrow(out), 2)
  expect_equal(out$firstName, c("Ada", "Grace"))
  expect_equal(out$roles, c("author", "submitter"))
})

test_that("get_study_desc strips markup from the returned description", {
  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) list(description = "<p>Study <b>description</b></p>"),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )
  testthat::local_mocked_bindings(
    read_html = function(x, ...) rawToChar(x),
    html_text = function(x, ...) gsub("<[^>]+>", "", x),
    .package = "rvest"
  )

  out <- get_study_desc("MTBLS1")

  expect_equal(trimws(out), "Study description")
})

test_that("get_study_descriptors returns a tibble of descriptor records", {
  payload <- list(
    studyDesignDescriptors = list(
      list(annotationValue = "case-control", termAccession = "ACC:1"),
      list(annotationValue = "longitudinal", termAccession = "ACC:2")
    )
  )

  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) payload,
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_study_descriptors("MTBLS1")

  expect_s3_class(out, "tbl_df")
  expect_equal(nrow(out), 2)
  expect_equal(out$annotationValue, c("case-control", "longitudinal"))
})

test_that("get_study_factors flattens factor metadata into a tibble", {
  payload <- list(
    factors = list(
      list(
        factorName = "Dose",
        factorType = list(
          annotationValue = "treatment",
          termSource = list(
            name = "EFO",
            file = "efo.obo",
            description = "Ontology"
          ),
          termAccession = "EFO:1"
        )
      )
    )
  )

  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) payload,
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_study_factors("MTBLS1")

  expect_equal(out$name, "Dose")
  expect_equal(out$annotationValue, "treatment")
  expect_equal(out$sourceName, "EFO")
  expect_equal(out$accession, "EFO:1")
})

test_that("get_study_files uses the public endpoint when raw_data is FALSE", {
  captured <- NULL

  testthat::local_mocked_bindings(
    GET = function(url, ...) {
      captured <<- list(url = url, dots = list(...))
      structure(list(), class = "fake_response")
    },
    content = function(...) list(study = list(list(name = "metadata.tsv", type = "derived"))),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  original_base_url <- getOption("BASE_URL")
  on.exit(options(BASE_URL = original_base_url), add = TRUE)

  options(BASE_URL = "https://example.test")

  out <- get_study_files("MTBLS1", raw_data = FALSE)

  expect_equal(captured$url, "https://example.test/studies/MTBLS1/files?include_raw_data=false")
  expect_equal(length(captured$dots), 2)
  expect_equal(out$name, "metadata.tsv")
})

test_that("get_study_files uses the authenticated endpoint when raw_data is TRUE", {
  captured <- NULL

  testthat::local_mocked_bindings(
    GET = function(url, ...) {
      captured <<- list(url = url, dots = list(...))
      structure(list(), class = "fake_response")
    },
    content = function(...) list(study = list(list(name = "raw.mzML", type = "raw"))),
    add_headers = function(...) list(...),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  original_base_url <- getOption("BASE_URL")
  original_api_key <- getOption("MTBLS_API_KEY")
  on.exit(options(BASE_URL = original_base_url, MTBLS_API_KEY = original_api_key), add = TRUE)

  options(BASE_URL = "https://example.test", MTBLS_API_KEY = "secret")

  out <- get_study_files("MTBLS1", raw_data = TRUE)

  expect_equal(captured$url, "https://example.test/studies/MTBLS1/files?include_raw_data=true")
  expect_true(any(vapply(
    captured$dots,
    function(x) is.list(x) && identical(x$user_token, "secret"),
    logical(1)
  )))
  expect_equal(out$name, "raw.mzML")
})

test_that("get_study_meta strips labels from status and release date", {
  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) list(data = c("status:PUBLIC", "release-date:2024-02-03")),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_study_meta("MTBLS1")

  expect_equal(out$status, "PUBLIC")
  expect_equal(out$release_date, "2024-02-03")
})

test_that("get_study_org binds parsed organism records into a tibble", {
  original_api_key <- getOption("MTBLS_API_KEY")
  on.exit(options(MTBLS_API_KEY = original_api_key), add = TRUE)

  options(MTBLS_API_KEY = "secret")

  payload <- list(
    list(organism = "Homo sapiens", part = "plasma"),
    list(organism = "Mus musculus", part = "liver")
  )

  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) payload,
    add_headers = function(...) list(...),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_study_org("MTBLS1")

  expect_s3_class(out, "tbl_df")
  expect_equal(out$organism, c("Homo sapiens", "Mus musculus"))
})

test_that("get_study_protocols flattens protocol records and parses parameters", {
  payload <- list(
    protocols = list(
      list(
        name = "Extraction",
        protocolType = list(annotationValue = "sample collection"),
        description = "Extraction step",
        parameters = list(
          list(parameterName = list(annotationValue = "Temperature")),
          list(parameterName = list(annotationValue = "Time"))
        )
      )
    )
  )

  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) payload,
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_study_protocols("MTBLS1")

  expect_equal(out$name, "Extraction")
  expect_equal(out$protocolType, "sample collection")
  expect_equal(out$parameters, "Temperature; Time")
})

test_that("get_study_pubs removes term accession and renames status column", {
  payload <- list(
    publications = list(
      list(
        pubmed = "12345",
        doi = "10.1000/example",
        title = "Interesting paper",
        author = "A. Author",
        status = list(termAccession = "ACC:1", annotationValue = "Published")
      )
    )
  )

  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) payload,
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_study_pubs("MTBLS1")

  expect_s3_class(out, "tbl_df")
  expect_false("status.termAccession" %in% names(out))
  expect_true("status" %in% names(out))
  expect_equal(out$status, "Published")
})

test_that("get_study_samples binds sample mapping entries into a tibble", {
  original_api_key <- getOption("MTBLS_API_KEY")
  on.exit(options(MTBLS_API_KEY = original_api_key), add = TRUE)

  options(MTBLS_API_KEY = "secret")

  payload <- list(
    list(
      list(filename = "file1.raw", sample = "Sample1", score = 1),
      list(filename = "file2.raw", sample = "Sample2", score = 0.8)
    )
  )

  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) payload,
    add_headers = function(...) list(...),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_study_samples("MTBLS1")

  expect_s3_class(out, "tbl_df")
  expect_equal(nrow(out), 2)
  expect_equal(out$filename, c("file1.raw", "file2.raw"))
})

test_that("get_study_tech replaces missing technology entries with string NA", {
  payload <- list(
    list("MTBLS1", "LC-MS"),
    list("MTBLS2", NULL)
  )

  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) payload,
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_study_tech()

  expect_equal(out$STUDY, c("MTBLS1", "MTBLS2"))
  expect_equal(out$TECH, c("LC-MS", "NA"))
})

test_that("get_study_title returns the parsed title", {
  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) list(title = "My study title"),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  expect_equal(get_study_title("MTBLS1"), "My study title")
})

test_that("get_user_studies returns parsed user study data", {
  original_api_key <- getOption("MTBLS_API_KEY")
  on.exit(options(MTBLS_API_KEY = original_api_key), add = TRUE)

  options(MTBLS_API_KEY = "secret")

  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) list(studies = c("MTBLS10", "MTBLS11")),
    add_headers = function(...) list(...),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_user_studies()

  expect_equal(out$studies, c("MTBLS10", "MTBLS11"))
})

test_that("get_webservice returns parsed webservice metadata", {
  testthat::local_mocked_bindings(
    GET = function(...) structure(list(), class = "fake_response"),
    content = function(...) list(name = "MetaboLights", version = "1.0"),
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  out <- get_webservice()

  expect_equal(out$name, "MetaboLights")
  expect_equal(out$version, "1.0")
})

test_that("search_metabolite returns the first matched metabolite", {
  captured <- NULL

  testthat::local_mocked_bindings(
    GET = function(url, ...) {
      captured <<- url
      structure(list(), class = "fake_response")
    },
    content = function(...) {
      list(
        content = list(
          list(
            name = "Proline",
            inchi = "InChI=1S/...",
            databaseId = "HMDB0000162",
            formula = "C5H9NO2",
            smiles = "C1CC(N)C(=O)O1",
            search_resource = "hmdb"
          )
        )
      )
    },
    timeout = function(...) NULL,
    user_agent = function(...) NULL,
    .package = "httr"
  )

  original_base_url <- getOption("BASE_URL")
  on.exit(options(BASE_URL = original_base_url), add = TRUE)

  options(BASE_URL = "https://example.test")

  out <- search_metabolite("proline test")

  expect_equal(captured, "https://example.test/search/name?search_value=proline%20test")
  expect_equal(out$name, "Proline")
  expect_equal(out$databaseId, "HMDB0000162")
})
