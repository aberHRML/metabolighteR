#' Get Study Meta
#'
#' Retrieve the meta data for a  publically available study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return a `tibble` of study meta data
#' @export
#' @examples
#' \dontrun{
#' get_study_meta('MTBLS375')
#' }

get_study_meta <- function(study_id)
{
  study_meta <-
    httr::GET(
      paste0(getOption('BASE_URL'),
             '/studies/',
             study_id,
             '/meta-info'),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
    )


  study_meta_parse <- study_meta %>% httr::content('parsed')

  study_meta_tibble <-
    dplyr::tibble(status = study_meta_parse$data[[1]],
                  release_date = study_meta_parse$data[[2]])

  study_meta_tibble$status <-
    gsub('status:', '', study_meta_tibble$status)
  study_meta_tibble$release_date <-
    gsub('release-date:', '', study_meta_tibble$release_date)

  return(study_meta_tibble)

}
