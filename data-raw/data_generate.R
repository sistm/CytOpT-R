#'
#'@export
#'
#'
# Load raw data from .csv file

X_source <- read.csv(here::here("data-raw", "../tests/ressources/W2_1_values.csv"))
Lab_source <- read.csv(here::here("data-raw", "../tests/ressources/W2_1_clust.csv"))[,'x']

X_target <- read.csv(here::here("data-raw", "../tests/ressources/W2_7_values.csv"))
Lab_target <- read.csv(here::here("data-raw", "../tests/ressources/W2_7_clust.csv"))[,'x']

# Loading raw data from a .csv file to test the CytOpT package in different example frameworks.
# Stanford3C
Stanford3C_values <- read.csv(here::here("data-raw", "../tests/ressources/W2_9_values.csv"))[,2:8]
Stanford3C_clust <- read.csv(here::here("data-raw", "../tests/ressources/W2_9_clust.csv"))[,'x']

# Miami3A
Miami3A_values <- read.csv(here::here("data-raw", "../tests/ressources/pM_7_values.csv"))[,2:8]
Miami3A_clust <- read.csv(here::here("data-raw", "../tests/ressources/pM_7_clust.csv"))[,'x']

# Save the cleaned data in the required R package location
usethis::use_data(X_source,overwrite = TRUE)
usethis::use_data(Lab_source,overwrite = TRUE)
usethis::use_data(X_target,overwrite = TRUE)
usethis::use_data(Lab_target,overwrite = TRUE)

usethis::use_data(Stanford3C_values,overwrite = TRUE)
usethis::use_data(Stanford3C_clust,overwrite = TRUE)

usethis::use_data(Miami3A_values,overwrite = TRUE)
usethis::use_data(Miami3A_clust,overwrite = TRUE)
