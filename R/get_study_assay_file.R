#' Get Study Assay File
#'
#' Retrieve the filename details for available assays of a public study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a character string of the study assay filename
#' @export
#' @examples
#' get_study_assay_file('MTBLS375')

get_study_assay_file <- function(study_id)
{
  study_assay_file <-
    httr::GET(
      paste0(getOption('BASE_URL'),
             '/studies/',
             study_id,
             '/assays')
    )


  study_assay_file_parse <- study_assay_file %>% httr::content('parsed')

  return(unlist(study_assay_file_parse$data$assays))

}
