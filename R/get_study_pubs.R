#' Get Study Publications
#'
#' Retrieve details on any publications that have been associated with the study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a `tibble` of study publications
#' @export
#' @examples
#' \dontrun{
#' get_study_pubs('MTBLS375')
#' }

get_study_pubs <- function(study_id)
{
  study_pubs_parse <- mtbls_get(paste0('/studies/', study_id, '/publications'))


  study_pubs_tibble <- purrr::map(study_pubs_parse$publications, ~ {
    unlist(.) %>% t() %>% dplyr::as_tibble()
  }) %>% dplyr::bind_rows() %>% dplyr::select(-status.termAccession)

  names(study_pubs_tibble)[5] <- 'status'

  return(study_pubs_tibble)

}
