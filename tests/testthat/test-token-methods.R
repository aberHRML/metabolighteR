context('test-methods')

test_that('token-get-methods', {
    skip_on_cran()
  if(!is.null(getOption('MTBLS_API_KEY'))) {
    expect_true(tibble::is_tibble(get_study_org('MTBLS375')))
    #expect_true(is.character(get_isa_investigation('MTBLS375')))
    expect_true(is.list(get_study_audit('MTBLS375')))
    expect_true(is.list(get_user_studies()))
  }

})

