context('no-token-needed')

test_that('tokenless-calls', {


  expect_true(tibble::is.tibble(get_studies()))
  expect_true(is.list(get_webservice()))

})
