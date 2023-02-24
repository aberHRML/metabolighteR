context('test-methods')

test_that('token-get-methods', {
  if (!is.null(getOption('MTBLS_API_KEY'))) {
    expect_true(tibble::is_tibble(get_study_org('MTBLS375')))
    expect_true(is.character(get_isa_investigation('MTBLS375')))
  }

})
