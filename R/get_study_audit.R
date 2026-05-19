#' Get Study Audit
#'
#' Retrieve a list of available audit folders for a study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a `list` of available audit folders
#' @export
#' @examples
#' get_user_studies

get_study_audit <- function(study_id) {
  audit <- httr::GET(
    paste0(getOption('BASE_URL'),
           '/studies/', study_id, '/audit'),
    httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
  ) %>% httr::content('parsed')

  return(audit)
}
