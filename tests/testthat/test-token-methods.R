context('test-methods')

test_that('token-get-methods', {
  skip_on_cran()
  skip_if_offline()
  if (!identical(Sys.getenv('METABOLIGHTER_RUN_LIVE_TESTS'), 'true')) {
    skip('Live API tests disabled')
  }
  if (is.null(getOption('MTBLS_API_KEY'))) {
    skip('No API key configured')
  }

  expect_true(tibble::is_tibble(get_study_org('MTBLS375')))
  #expect_true(is.character(get_isa_investigation('MTBLS375')))
  expect_true(is.list(get_study_audit('MTBLS375')))
  expect_true(is.list(get_user_studies()))
})
