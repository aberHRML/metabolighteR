#' Parse Protocol Annotation Values
#'
#' @param x
#' @return
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
