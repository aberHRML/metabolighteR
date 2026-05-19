#' Search Metabolite
#'
#' @param search_name A character string of a chemical name to search for
#' @export
#' @examples
#' \dontrun{
#' search_metabolite('proline')
#' }

search_metabolite <- function(search_name)
{
  metabolite_search <-
    httr::GET(glue::glue(getOption('BASE_URL'), '/search/name?search_value=', {
      search_name
    }))

  metabolite_search_res <- metabolite_search %>% httr::content('parsed')


  metabolite_tibble <-
    tibble::tibble(
      name = metabolite_search_res$content[[1]]$name,
      inchi = metabolite_search_res$content[[1]]$inchi,
      databaseId = metabolite_search_res$content[[1]]$databaseId,
      formula = metabolite_search_res$content[[1]]$formula,
      smiles = metabolite_search_res$content[[1]]$smiles,
      search_resource = metabolite_search_res$content[[1]]$search_resource
    )

  return(metabolite_tibble)
}
