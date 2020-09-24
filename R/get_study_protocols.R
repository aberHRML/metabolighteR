#' Get Study Protocols
#'
#' Retrieve the protocol information that has been deposited for a public study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a `tibble` of study protocols
#' @export
#' @examples
#' get_study_protocols('MTBLS375')

get_study_protocols <- function(study_id)
{
  study_protocols <-
    httr::GET(
      paste0(getOption('BASE_URL'),
             '/studies/',
             study_id,
             '/protocols')
    )


  study_prot_parse <- study_protocols %>% httr::content('parsed')

  study_prot_list <- list()
  for (i in seq_along(study_prot_parse$protocols)) {
    study_prot_list[[i]] <-
      dplyr::tibble(
        name = study_prot_parse$protocols[[i]]$name,
        protocolType = study_prot_parse$protocols[[i]]$protocolType$annotationValue,
        description = study_prot_parse$protocols[[i]]$description,
        parameters = protocols_annotation(study_prot_parse$protocols[[i]]$parameters)
      )

  }

  study_prot_tibble <- study_prot_list %>% dplyr::bind_rows()

  return(study_prot_tibble)

}
