#' Get Study Title
#'
#' Retrieve the full title of the study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a character string of the study title
#' @export
#' @examples
#' \dontrun{
#' get_study_title('MTBLS375')
#' }

get_study_title <- function(study_id)
{
  study_title_parse <- mtbls_get(paste0('/studies/', study_id, '/title'))

  return(study_title_parse$title)

}
