#' Get Study Audit
#'
#' Retrieve a list of available audit folders for a study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a `list` of available audit folders
#' @export
#' @examples
#' \dontrun{
#' get_study_audit('MTBLS375')
#' }

get_study_audit <- function(study_id) {
  audit <- mtbls_get(
    paste0('/studies/', study_id, '/audit'),
    authenticate = TRUE
  )

  return(audit)
}
