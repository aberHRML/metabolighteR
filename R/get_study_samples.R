#' Get Study Samples
#'
#' Get a list of all sample names mapped to files within the study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a `tibble` of filename sample name and reliability score. 1.0 indicates a perfect match
#' @importFrom magrittr %>%
#' @export
#' @examples
#' \dontrun{
#' get_study_samples('MTBLS375')
#' }

get_study_samples <- function(study_id)
{
  study_samples <-
    httr::GET(
      paste0(
        getOption('BASE_URL'),
        '/studies/',
        study_id,
        '/files/samples'
      ),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
    )



  study_samples_content <-
    study_samples %>% httr::content('parsed')


  study_sample_tibble <-
    purrr::map(study_samples_content[[1]], tibble::as_tibble) %>% dplyr::bind_rows()


  return(study_sample_tibble)

}
