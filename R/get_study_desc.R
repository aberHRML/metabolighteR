#' Get Study Description
#'
#' @param study_id
#' @return
#' @export

get_study_desc <- function(study_id)
{
  study_desc <-
    httr::GET(
      paste0(BASE_URL,
             '/studies/',
             study_id,
             '/description'),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
    )


  study_desc_parse <- study_desc %>% httr::content('parsed')

  return(rvest::html_text(xml2::read_html(study_desc_parse$description)))

}
