#' Get Studies for User
#'
#' Retrieve a list of studies for a user
#'
#' @return a `list` of user owned studies
#' @export
#' @examples
#' \dontrun{
#' get_user_studies()
#' }

get_user_studies <- function() {
    studies <- mtbls_get('/studies/user', authenticate = TRUE)

  return(studies)
}
