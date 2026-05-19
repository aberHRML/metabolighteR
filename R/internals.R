#' Parse Protocol Annotation Values
#'
#' @param x the `httr` parsed output from `get_study_protocols`
#' @return a character string of protocol annotations
#' @keywords internal

protocols_annotation <- function(x)
{
  protocol_values <-
    purrr::map_chr(x, ~ {
      .$parameterName$annotationValue
    }) %>%
    paste(., collapse = '; ')

  return(protocol_values)

}

mtbls_get <- function(path = "", authenticate = FALSE, parse = "parsed")
{
  base_url <- getOption("BASE_URL")

  if (is.null(base_url) || !nzchar(base_url)) {
    stop("BASE_URL option is not configured.", call. = FALSE)
  }

  request_args <- list(paste0(base_url, path))

  if (isTRUE(authenticate)) {
    api_key <- getOption("MTBLS_API_KEY")

    if (is.null(api_key) || !nzchar(api_key)) {
      stop("MTBLS_API_KEY option is not configured.", call. = FALSE)
    }

    request_args <- c(
      request_args,
      list(httr::add_headers(user_token = api_key))
    )
  }

  response <- tryCatch(
    do.call(httr::GET, request_args),
    error = function(err) {
      stop(
        sprintf(
          "MetaboLights request failed for `%s`: %s",
          path,
          conditionMessage(err)
        ),
        call. = FALSE
      )
    }
  )

  if (inherits(response, "response")) {
    tryCatch(
      httr::stop_for_status(response),
      error = function(err) {
        stop(
          sprintf(
            "MetaboLights request failed for `%s`: %s",
            path,
            conditionMessage(err)
          ),
          call. = FALSE
        )
      }
    )
  }

  tryCatch(
    httr::content(response, parse),
    error = function(err) {
      stop(
        sprintf(
          "Failed to parse MetaboLights response for `%s`: %s",
          path,
          conditionMessage(err)
        ),
        call. = FALSE
      )
    }
  )
}

mtbls_api_spec_url <- function()
{
  paste0(getOption("BASE_URL"), "/api/spec")
}
