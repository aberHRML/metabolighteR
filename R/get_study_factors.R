#' Get Study Factors
#'
#' Retrieve the study factors and annotation values for a publically available study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a `tibble` of study factors
#' @export
#' @examples
#' \dontrun{
#' get_study_factors('MTBLS375')
#' }

get_study_factors <- function(study_id)
{
  study_fcts <-
    httr::GET(
      paste0(getOption('BASE_URL'),
             '/studies/',
             study_id,
             '/factors'),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
    )


  study_fcts_parse <- study_fcts %>% httr::content('parsed')

  study_fcts_list <- list()
  for (i in seq_along(study_fcts_parse$factors)) {
    study_fcts_list[[i]] <-
      dplyr::tibble(
        name = study_fcts_parse$factors[[i]]$factorName,
        annotationValue = study_fcts_parse$factors[[i]]$factorType$annotationValue,
        sourceName = study_fcts_parse$factors[[i]]$factorType$termSource$name,
        sourceFile = study_fcts_parse$factors[[i]]$factorType$termSource$file,
        sourceDescription = study_fcts_parse$factors[[i]]$factorType$termSource$description,
        accession = study_fcts_parse$factors[[i]]$factorType$termAccession
      )
  }

  study_fcts_tibble <- study_fcts_list %>% dplyr::bind_rows()

  return(study_fcts_tibble)
}

