#' Get Studies
#'
#' Retrieve a list of all publically available Metabolights studies
#'
#' @return a `tibble` of Study IDs
#' @export
#' @examples
#' get_studies()

get_studies <- function() {
  studies <-
    httr::GET(paste0(getOption('BASE_URL'), '/studies')) %>% httr::content('parsed')

  study_tibble <- dplyr::tibble(unlist(studies))
  names(study_tibble) <- 'study'

  return(study_tibble)
}
