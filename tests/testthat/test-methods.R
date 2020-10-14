context('test-methods')

test_that('tokenless-get-methods', {
  expect_true(is.list(get_webservice()))
  expect_true(tibble::is_tibble(get_studies()))
  expect_true(tibble::is_tibble(get_study_tech()))
  expect_true(tibble::is_tibble(get_study_contacts('MTBLS968')))
  expect_true(is.character(get_study_desc('MTBLS968')))
  expect_true(tibble::is_tibble(get_study_descriptors('MTBLS968')))
  expect_true(tibble::is_tibble(get_study_factors('MTBLS968')))
  expect_true(tibble::is_tibble(get_study_files('MTBLS968')))
  expect_true(tibble::is_tibble(get_study_meta('MTBLS968')))
  expect_true(tibble::is_tibble(get_study_protocols('MTBLS968')))
  expect_true(tibble::is_tibble(get_study_pubs('MTBLS968')))
  expect_true(tibble::is_tibble(get_study_samples('MTBLS968')))
  expect_true(is.character(get_study_title('MTBLS968')))

})
