#' Get Web-service details
#'
#' Retrieve details about the Metabolights RESTful WebService
#'
#' @return a list of the MTBLS webservice information
#' @export
#' @examples
#' get_webservice()

get_webservice <- function()
{
  webservice_info <- httr::GET(getOption('BASE_URL')) %>% httr::content('parsed')
  return(webservice_info)
}
