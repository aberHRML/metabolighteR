#' Get ISA Investigation File
#'
#' Retrieve the ISA Investigation for a specified Metabolights Study
#'
#' @param study_id A character string of a valid MTBLS study id
#' @return the ISA-tab Investigation output
#' @export
#' @examples
#' \dontrun{
#' ISA <- get_isa_investigation('MTBLS375')
#' writeLines(isa_investigation_parse, con = paste0('outpath/ISA.txt'))
#' }

get_isa_investigation <- function(study_id)
{
  isa_investigation_parse <-
    mtbls_get(
      paste0('/studies/', study_id, '/investigation'),
      authenticate = TRUE,
      parse = 'parsed'
    )

  return(isa_investigation_parse)
}
