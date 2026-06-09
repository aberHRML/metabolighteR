#' Get Study Description
#'
#' Retrieve the abstract based description of a public study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a character string of the study description
#' @export
#' @examples
#' \dontrun{
#' get_study_desc('MTBLS375')
#' }

get_study_desc <- function(study_id)
{
  study_desc_parse <- mtbls_get(paste0('/studies/', study_id, '/description'))

  study_desc_clean <- rvest::html_text(rvest::read_html(charToRaw(paste0(' ', study_desc_parse$description)), trim=T))


  return(study_desc_clean)

}
