context('test-methods')

test_that('tokenless-get-methods', {
  expect_true(is.list(get_webservice()))
  expect_true(tibble::is_tibble(get_studies()))
  expect_true(tibble::is_tibble(get_study_tech()))

  all_studies <- get_studies()
  all_studies_vec <- as.vector(all_studies$study)

  random_study <- function() {
    random_number <- sample(1:length(all_studies_vec), 1)
    return(all_studies_vec[random_number])
  }


  expect_true(tibble::is_tibble(get_study_contacts(random_study())))
  expect_true(is.character(get_study_desc(random_study())))
  expect_true(tibble::is_tibble(get_study_descriptors(random_study())))
  expect_true(tibble::is_tibble(get_study_factors(random_study())))
  expect_true(tibble::is_tibble(get_study_files(random_study())))
  expect_true(tibble::is_tibble(get_study_meta(random_study())))
  expect_true(tibble::is_tibble(get_study_protocols(random_study())))
  expect_true(tibble::is_tibble(get_study_pubs(random_study())))
  expect_true(tibble::is_tibble(get_study_samples(random_study())))
  expect_true(is.character(get_study_title(random_study())))

})
