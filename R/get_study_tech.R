#' Get Study Technology
#'
#' Retrieve a `tibble` of all Study IDs and the analytical technology used in the study
#'
#' @return a `tibble` of study id and technology
#' @export
#' @examples
#' \dontrun{
#' get_study_tech()
#' }

get_study_tech <- function()
{
  study_tech_parse <- mtbls_get('/studies/technology')


  for (i in seq_along(study_tech_parse)) {
    if (is.null(study_tech_parse[[i]][[2]])) {
      study_tech_parse[[i]][[2]] <- 'NA'
    }
  }


  study_tech_tibble <-  tibble::tibble(
    STUDY = purrr::map_chr(study_tech_parse, ~ {
      .[[1]]
    }),
    TECH = purrr::map_chr(study_tech_parse, ~
                            {
                              .[[2]]
                            })
  )

  return(study_tech_tibble)

}
