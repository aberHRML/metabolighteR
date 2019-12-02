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
  study_title <-
    httr::GET(
      paste0(getOption('BASE_URL'),
             '/studies/',
             study_id,
             '/title'),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
    )


  study_title_parse <- study_title %>% httr::content('parsed')

  return(study_title_parse$title)

}
