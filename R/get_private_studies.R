#' Get Private Studies
#'
#' @return a `tibble` of your private Study IDs
#' @export

get_private_studies <- function()
{
  study_priv <-
    httr::GET(
      paste0(BASE_URL,
             '/studies/user/lite'),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
    ) %>% httr::content('parsed')


  study_tibble <- dplyr::tibble(unlist(study_priv))
  names(study_tibble) <- 'study'

  return(study_tibble)

}