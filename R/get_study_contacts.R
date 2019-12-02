#' Get Study Contacts
#'
#' Retrieve the contact details for a specified public study
#' '
#' @param study_id a character string of a valid MTBLS study id
#' @return a `tibble` of study contacts
#' @export
#' @examples
#' \dontrun{
#' get_study_contacts('MTBLS375')
#' }

get_study_contacts <- function(study_id)
{
  study_contacts <-
    httr::GET(
      paste0(getOption('BASE_URL'),
             '/studies/',
             study_id,
             '/contacts'),
      httr::add_headers(user_token = getOption('MTBLS_API_KEY'))
    )


  study_contacts_parse <- study_contacts %>% httr::content('parsed')

  study_contact_list <- list()
  for (i in seq_along(study_contacts_parse$contacts)) {
    study_contact_list[[i]] <-
      dplyr::tibble(
        firstName = study_contacts_parse$contacts[[i]]$firstName,
        lastName = study_contacts_parse$contacts[[i]]$lastName,
        email = study_contacts_parse$contacts[[i]]$email,
        affiliation = study_contacts_parse$contacts[[i]]$affiliation,
        address = study_contacts_parse$contacts[[i]]$address,
        fax = study_contacts_parse$contacts[[i]]$fax,
        midInitials = study_contacts_parse$contacts[[i]]$midInitials,
        phone = study_contacts_parse$contacts[[i]]$phone,
        roles = study_contacts_parse$contacts[[i]]$roles
      )

  }

  study_contact_tibble <- study_contact_list %>% dplyr::bind_rows()

  return(study_contact_tibble)

}
