#' Get Studies for User
#'
#' Retrieve a list of studies for a user
#'
#' @return a `list` of user owned studies
#' @export
#' @examples
#' get_user_studies

get_user_studies <- function() {

    studies <- httr::GET(
      paste0(getOption('BASE_URL'),
             '/studies/user'),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
    ) %>% httr::content('parsed')

  return(studies)
}
