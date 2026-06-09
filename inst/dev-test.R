# Set API Key
library(metabolighteR)

mtbls_key()


# Use a random StudyID for testing

random_study <- function()
{
  # List all available studies
  all_studies <- get_studies()
  
  random_gen <-
    round(runif(1, min = 1, max = nrow(all_studies)), digits = 0)
  
  
  study_id <- all_studies$study[[random_gen]]
  
  return(study_id)
  
}



get_study_contacts(random_study())
get_study_desc(random_study())
get_study_descriptors(random_study())
get_study_factors(random_study())
get_study_files(random_study(), raw_data = FALSE)


get_study_meta(random_study())

get_study_protocols(random_study())

get_study_pubs(random_study())

get_study_samples(random_study())

get_study_tech()

get_study_title(random_study())



