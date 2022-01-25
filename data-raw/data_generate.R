#'
#'@export
#'
#'
# Load raw data from .csv file

X_source <- read.csv(here::here("data-raw", "../tests/ressources/W2_1_values.csv"))
Lab_source <- read.csv(here::here("data-raw", "../tests/ressources/W2_1_clust.csv"))[,'x']

X_target <- read.csv(here::here("data-raw", "../tests/ressources/W2_7_values.csv"))
Lab_target <- read.csv(here::here("data-raw", "../tests/ressources/W2_7_clust.csv"))[,'x']

# Save the cleaned data in the required R package location
usethis::use_data(X_source,overwrite = TRUE)
usethis::use_data(Lab_source,overwrite = TRUE)
usethis::use_data(X_target,overwrite = TRUE)
usethis::use_data(Lab_target,overwrite = TRUE)