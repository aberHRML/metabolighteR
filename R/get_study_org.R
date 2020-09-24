#' Get Study Organisms
#'
#' Retrieve the organisms used within a study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a `tibble` of study organism data
#' @export
#' @examples
#' \dontrun{
#' get_study_org('MTBLS375')
#' }

get_study_org <- function(study_id)
{
  study_org <-
    httr::GET(
      paste0(getOption('BASE_URL'),
             '/studies/',
             study_id,
             '/organisms'),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
    )


  study_org_parse <- study_org %>% httr::content('parsed')


}
