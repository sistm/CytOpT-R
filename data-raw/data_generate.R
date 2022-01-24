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
# Liste of data Stanford3C
Stanford3C <- list("values"=Stanford3C_values, "clust"=Stanford3C_clust)

# Miami3A
Miami3A_values <- read.csv(here::here("data-raw", "../tests/ressources/pM_7_values.csv"))[,2:8]
Miami3A_clust <- read.csv(here::here("data-raw", "../tests/ressources/pM_7_clust.csv"))[,'x']
# Liste of data Miami3A
Miami3A <- list("values"=Miami3A_values, "clust"=Miami3A_clust)

# Ucla2B
Ucla2B_values <- read.csv(here::here("data-raw", "../tests/ressources/IU_5_values.csv"))[,2:8]
Ucla2B_clust <- read.csv(here::here("data-raw", "../tests/ressources/IU_5_clust.csv"))[,'x']
# Liste of data Ucla2B
Ucla2B <- list("values"=Ucla2B_values, "clust"=Ucla2B_clust)

# Save the cleaned data in the required R package location
usethis::use_data(X_source,overwrite = TRUE)
usethis::use_data(Lab_source,overwrite = TRUE)

usethis::use_data(Stanford3C,overwrite = TRUE)

usethis::use_data(Miami3A,overwrite = TRUE)

usethis::use_data(Ucla2B,overwrite = TRUE)