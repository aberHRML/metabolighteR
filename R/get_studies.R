#' Get Studies
#'
#' Retrieve a list of all available MTBLS Study ID's
#'
#' @return a `tibble` of Study IDs
#' @export

get_studies <- function() {
  studies <-
    httr::GET(paste0(BASE_URL, '/studies')) %>% httr::content('parsed')

  study_tibble <- dplyr::tibble(unlist(studies))
  names(study_tibble) <- 'study'

  return(study_tibble)
}
