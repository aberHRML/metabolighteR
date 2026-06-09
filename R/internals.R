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
  request_timeout <- getOption("metabolighteR.timeout", 30)

  if (is.null(base_url) || !nzchar(base_url)) {
    stop("BASE_URL option is not configured.", call. = FALSE)
  }

  if (!is.numeric(request_timeout) || length(request_timeout) != 1 || request_timeout <= 0) {
    stop("metabolighteR.timeout option must be a positive number.", call. = FALSE)
  }

  request_args <- list(
    paste0(base_url, path),
    httr::timeout(request_timeout),
    httr::user_agent(mtbls_user_agent())
  )

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

  response <- NULL
  last_error <- NULL

  for (attempt in seq_len(3)) {
    response <- tryCatch(
      do.call(httr::GET, request_args),
      error = function(err) {
        last_error <<- err
        NULL
      }
    )

    if (is.null(response)) {
      next
    }

    if (!inherits(response, "response")) {
      break
    }

    status_error <- tryCatch(
      {
        httr::stop_for_status(response)
        NULL
      },
      error = function(err) err
    )

    if (is.null(status_error)) {
      break
    }

    if (!is.null(response$status_code) &&
        response$status_code >= 500 &&
        response$status_code < 600 &&
        attempt < 3) {
      last_error <- status_error
      next
    }

    tryCatch(
      stop(status_error),
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

  if (is.null(response)) {
    stop(
      sprintf(
        "MetaboLights request failed for `%s`: %s",
        path,
        conditionMessage(last_error)
      ),
      call. = FALSE
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

mtbls_user_agent <- function()
{
  sprintf("metabolighteR/%s", utils::packageVersion("metabolighteR"))
}

mtbls_api_spec_url <- function()
{
  paste0(getOption("BASE_URL"), "/api/spec")
}
