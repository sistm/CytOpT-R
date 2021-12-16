#'
#'@import tidyverse
#'@import readr
#'@import tibble
#'@export
#'
#'
# Load raw data from .csv file

X_source <- readr::read_csv(here::here("data-raw", "../tests/ressources/W2_1_values.csv")) %>% select(CD4, CD8)
X_target <- readr::read_csv(here::here("data-raw", "../tests/ressources/W2_1_clust.csv")) %>% select(x)

# Apply preprocessing...
# Save the cleaned data in the required R package location

usethis::use_data(X_source,overwrite = TRUE)
usethis::use_data(X_target,overwrite = TRUE)
