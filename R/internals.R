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
