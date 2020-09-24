#' Get Private Studies
#'
#' Retrieve all private studies which belong to your user account
#'
#' @return a `tibble` of your private Study IDs
#' @export
#' @examples
#' \dontrun{
#' get_private_studies()
#' }

get_private_studies <- function()
{
  study_priv <-
    httr::GET(
      paste0(getOption('BASE_URL'),
             '/studies/user/lite'),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
    ) %>% httr::content('parsed')


  if (length(study_priv$data) > 0) {
    study_tibble <- dplyr::tibble(unlist(study_priv))
    names(study_tibble) <- 'study'
    return(study_tibble)
  } else{
    message(crayon::yellow('No private studies found'))
    return(invisible(NULL))
  }
}
