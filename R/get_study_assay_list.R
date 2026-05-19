#' Get Study Description
#'
#' Retrieve the abstract based description of a public study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a list off the study assays and associated details
#' @export
#' @examples
#' \dontrun{
#' get_study_assay_list('MTBLS375')
#' }

get_study_assay_list <- function(study_id)
{
  study_assays_parse <-
    mtbls_get(paste0('/studies/', study_id, '/assays?list_only=false'))

  return(study_assays_parse$data$assays[[1]])

}
