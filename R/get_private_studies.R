#' Get Private Studies
#'
#' Retrieve all private studies which belong to your user account
#'
#' @return a `tibble` of your private Study IDs
#' @export
#' @examples
#' \dontrun{
#' get_private_studies()
#' }

get_private_studies <- function()
{
  study_priv <- mtbls_get('/studies/user/lite', authenticate = TRUE)


  if (length(study_priv$data) > 0) {
    study_tibble <- dplyr::tibble(unlist(study_priv$data))
    names(study_tibble) <- 'study'
    return(study_tibble)
  } else{
    message(crayon::yellow('No private studies found'))
    return(invisible(NULL))
  }
}
