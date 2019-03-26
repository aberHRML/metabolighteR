#' Get Web-service details
#'
#' @return a list of the MTBLS webservice information
#' @export

get_webservice <- function()
{
  webservice_info <- httr::GET(BASE_URL) %>% httr::content('parsed')
  return(webservice_info)
}
