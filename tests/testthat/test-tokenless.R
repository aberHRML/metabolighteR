context('no-token-needed')

test_that('tokenless-calls', {

  expect_true(tibble::is_tibble(get_studies()))
  expect_true(is.list(get_webservice()))

})
