#' Get Study Description
#'
#' Retrieve the abstract based description of a public study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a character string of the study description
#' @export
#' @examples
#' get_study_desc('MTBLS375')

get_study_desc <- function(study_id)
{
  study_desc <-
    httr::GET(
      paste0(getOption('BASE_URL'),
             '/studies/',
             study_id,
             '/description')
    )


  study_desc_parse <- study_desc %>% httr::content('parsed')

  return(study_desc_parse$description)

}
