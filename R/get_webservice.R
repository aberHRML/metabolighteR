#' Get Web-service details
#'
#' Retrieve details about the Metabolights RESTful WebService
#'
#' @return a list of the MTBLS webservice information
#' @export
#' @examples
#' \dontrun{
#' get_webservice()
#' }

get_webservice <- function()
{
  webservice_info <- mtbls_get()
  return(webservice_info)
}
