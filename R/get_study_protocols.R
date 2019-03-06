#' Get Study Protocols
#'
#' @param study_id
#' @return
#' @export

get_study_protocols <- function(study_id)
{
  study_protocols <-
    httr::GET(
      paste0(BASE_URL,
             '/studies/',
             study_id,
             '/protocols'),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
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