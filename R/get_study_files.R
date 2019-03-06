
get_study_files <- function(API_KEY, study_id, raw_data = FALSE)
{

  if(!isTRUE(raw_data)){
    study_files <-
      httr::GET(
        paste0(BASE_URL, '/studies/', study_id, '/files?include_raw_data=false'),
        httr::add_headers(user_token = API_KEY)
      )
  }

  if(isTRUE(raw_data)){
    study_files <-
      httr::GET(
        paste0(BASE_URL, '/studies/', study_id, '/files?include_raw_data=true'),
        httr::add_headers(user_token = API_KEY)
      )
  }


  study_files_content <-  study_files %>% httr::content('parsed')
  study_files_tibble <-
    purrr:::map(study_files_content$studyFiles, as_tibble) %>% bind_rows()

  return(study_files_tibble)


}












