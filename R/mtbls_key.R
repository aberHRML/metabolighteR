#' Set API Token
#'
#' Set your Metabolights API Token as global option. If `MTBLS_API_KEY` is set in `.Renviron` then this variable will be passed directly
#' to the `MTBLS_API_KEY` option. If no `MTBLS_API_KEY` is set in `.Renviron`, then the API Token must be passed as an input in the `set_api_token`
#' function
#'
#' @param API_KEY a character string of your Metabolights API Token (Default is `NULL`)
#' @export
#' @examples
#' \dontrun{
#'
#' # If API Token is set in `.Renviron`
#'
#' mtbls_key()
#'
#' # If API Token is not set in `.Renviron`
#'
#' mtbls_key('XXXX-0000-XXXX-0000')
#' }

mtbls_key <- function(API_KEY = NULL)
{
  if (Sys.getenv('MTBLS_API_KEY') == "") {
    options('MTBLS_API_KEY' = API_KEY)
  } else{
    options('MTBLS_API_KEY' = Sys.getenv('MTBLS_API_KEY'))
  }

  return(invisible(NULL))
}
