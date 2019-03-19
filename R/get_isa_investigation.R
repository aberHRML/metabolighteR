#' Get ISA Investigation File
#'
#' @param study_id
#' @param outpath
#' @return
#' @export

get_isa_investigation <- function(study_id, outpath)
{
  isa_investigation <-
    httr::GET(
      paste0(BASE_URL,
             '/studies/',
             study_id,
             '/investigation'),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
    )


  isa_investigation_parse <- isa_investigation %>% httr::content('text')

  isa_clean <- rvest::html_text(xml2::read_html(isa_investigation_parse))

  writeLines(isa_clean, con = paste0(outpath, '/', study_id, '_ISA.txt'))

  return(invisible(NULL))
}


