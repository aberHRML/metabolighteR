#' Get Study Files
#'
#' Retrieve the names and type of all files that have been deposited with the public study. If `raw_data` is TRUE then details of raw data files(ie, `.mzML`) are also returned.
#'
#' @param study_id A character string of a valid MTBLS study id
#' @param raw_data logical; if `TRUE` then raw data file info is also returned. (Default is `FALSE`)
#' @return a `tibble` of file info
#' @importFrom magrittr %>%
#' @export
#' @examples
#' get_study_files('MTBLS375', raw_data = FALSE)

get_study_files <- function(study_id, raw_data = FALSE)
{
  if (!isTRUE(raw_data)) {
    study_files <-
      httr::GET(
        paste0(
          getOption('BASE_URL'),
          '/studies/',
          study_id,
          '/files?include_raw_data=false'
        )
      )
  }

  if (isTRUE(raw_data)) {
    study_files <-
      httr::GET(
        paste0(
          getOption('BASE_URL'),
          '/studies/',
          study_id,
          '/files?include_raw_data=true'
        ),
        httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
      )
  }


  study_files_content <-  study_files %>% httr::content('parsed')
  study_files_tibble <-
    purrr::map(study_files_content$study, dplyr::as_tibble) %>% dplyr::bind_rows()

  return(study_files_tibble)

}
