#' Get Studies
#'
#' Retrieve a list of all publically available Metabolights studies
#'
#' @return a `tibble` of Study IDs
#' @export
#' @examples
#' \dontrun{
#' get_studies()
#' }

get_studies <- function() {
  studies <- mtbls_get('/studies')

  study_tibble <- dplyr::tibble(unlist(studies))
  names(study_tibble) <- 'study'

  return(study_tibble)
}
