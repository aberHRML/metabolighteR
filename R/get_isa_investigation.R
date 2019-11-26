#' Get ISA Investigation File
#'
#' @param study_id A character string of a valid MTBLS study id
#' @param outpath A character string of a filepath where the ISA Investigation `.txt` file will be saved to
#' @export
#' @examples
#' \dontrun{
#' get_isa_investigation('MTBLS375', 'local_directory/')
#' }

get_isa_investigation <- function(study_id, outpath)
{
  isa_investigation <-
    httr::GET(
      paste0(
        getOption('BASE_URL'),
        '/studies/',
        study_id,
        '/investigation'
      ),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
    )


  isa_investigation_parse <-
    isa_investigation %>% httr::content('text')

  writeLines(isa_investigation_parse,
             con = paste0(outpath, '/', study_id, '_ISA.txt'))

  return(invisible(NULL))
}
