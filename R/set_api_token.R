#' Load API Token
#'
#' @param API_KEY
#' @export

set_api_token <- function(API_KEY = NULL)
{
  if (Sys.getenv('MTBLS_API_KEY') == "") {
    options('MTBLS_API_KEY' = API_KEY)
  } else{
    options('MTBLS_API_KEY' = Sys.getenv('MTBLS_API_KEY'))
  }

  return(invisible(NULL))
}
