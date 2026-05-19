#' All Public GET Methods
#'
#' Retrieve a list of all the available public `GET` methods
#'
#' @return a `tbl_df` of API `GET` methods
#' @export


all_get_methods <- function()
{
  api_info <-
    jsonlite::fromJSON('https://www.ebi.ac.uk/metabolights/ws/api/spec')

  api_ref <- tibble::as_tibble(api_info$apis)

  method <- purrr::map(api_ref$operations, ~ {
    .$method
  })

  get_methods <-
    purrr::map_dbl(sapply(method, function(x)
      (grep('get', x))), length)


  mtbls_api_ref <-
    api_ref %>% dplyr::mutate(get = get_methods) %>% dplyr::filter(get == 1) %>%
    dplyr::select(-notes, -get, -description) %>%
    dplyr::filter(!stringr::str_detect(path, 'ebi-internal'))



  mtbls_api_op <- mtbls_api_ref$operations %>% dplyr::bind_rows() %>%
    dplyr::filter(method == 'get') %>%
    dplyr::select(summary)


  mtbls_get_methods <- tibble::tibble(method = mtbls_api_ref$path,
                                      description = mtbls_api_op$summary)


  return(mtbls_get_methods)
}
