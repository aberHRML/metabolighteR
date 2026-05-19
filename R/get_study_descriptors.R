#' Get Study Descriptors
#'
#' Retrieve the study descriptors and annotation values for a publically available study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a `tibble` of study descriptors
#' @export
#' @examples
#' get_study_descriptors('MTBLS375')


get_study_descriptors <- function(study_id)
{
  study_dcpts <-
    httr::GET(
      paste0(getOption('BASE_URL'),
             '/studies/',
             study_id,
             '/descriptors')
    )


  study_dcpts_parse <- study_dcpts %>% httr::content('parsed')


  length(study_dcpts_parse$studyDesignDescriptors)

  study_dcpts_tibble <-
    purrr::map(study_dcpts_parse$studyDesignDescriptors, ~ {
      unlist(.) %>% t() %>% dplyr::as_tibble()
    }) %>% dplyr::bind_rows()

  return(study_dcpts_tibble)

}
