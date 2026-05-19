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
  study_org_parse <- mtbls_get(
    paste0('/studies/', study_id, '/organisms'),
    authenticate = TRUE
  )

  study_org_tibble <- study_org_parse %>% dplyr::bind_rows()

  return(study_org_tibble)

}
