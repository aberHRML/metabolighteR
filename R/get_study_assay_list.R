#' Get Study Description
#'
#' Retrieve the abstract based description of a public study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a list off the study assays and associated details
#' @export
#' @examples
#' get_study_assay_list('MTBLS375')

get_study_assay_list <- function(study_id)
{
  study_assays <-
    httr::GET(
      paste0(getOption('BASE_URL'),
             '/studies/',
             study_id,

             '/assays?list_only=false')
    )


  study_assays_parse <- study_assays %>% httr::content('parsed')

  return(study_assays_parse$data$assays[[1]])

}
