#' Get Study Title
#'
#' @param study_id
#' @return
#' @export

get_study_title <- function(study_id)
{
  study_title <-
    httr::GET(
      paste0(BASE_URL,
             '/studies/',
             study_id,
             '/title'),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
    )


  study_title_parse <- study_title %>% httr::content('parsed')

  return(study_title_parse$title)

}