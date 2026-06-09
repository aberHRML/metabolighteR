#' Download Study File Contents
#'
#' Download the contents of a specified file from a public study
#'
#' @param study_id a character string of a valid MTBLS study id
#' @param filename a character of the full filename and extension to download
#' @return a `tibble` of file contents
#' @export

download_study_file <- function(study_id, filename)
{
  encoded_filename <- utils::URLencode(filename, reserved = TRUE)

  file_content <-
    mtbls_get(
      paste0('/studies/', study_id, '/download?file=', encoded_filename),
      parse = 'text'
    ) %>% textConnection() %>% readLines() %>%
    utils::read.delim(text = ., sep = '\t') %>% tibble::as_tibble()

  return(file_content)


}
