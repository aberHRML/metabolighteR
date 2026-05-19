#' Get Study Assay File
#'
#' Retrieve the filename details for available assays of a public study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a character string of the study assay filename
#' @export
#' @examples
#' \dontrun{
#' get_study_assay_file('MTBLS375')
#' }

get_study_assay_file <- function(study_id)
{
  study_assay_file_parse <- mtbls_get(paste0('/studies/', study_id, '/assays'))

  return(unlist(study_assay_file_parse$data$assays))

}
