Dear CRAN maintainers, 
This update is a fix to CytOpt which was archived from CRAN due to excessive 
run-time and processes on fedora. and I apologize from its last update, 
failed to fix the issues reported on CRAN under fedora architectures in the 
check results. 
Through extensive checking via rhub, (although I could not exactly reproduce 
this CRAN error whose only error message is "Error(s) in re-building vignettes: 
-- re-building 'CytOpt_HIPC.Rmd' using rmarkdown"), I believe to have 
fixed all issues now.
 
## R CMD check results

 * local R installation, R 4.4.3
 * Linux (Ubuntu 24.04), macOS (14.7) and Windows (Server 2022 10.0), R devel and release (through GitHub Actions)
 * win-builder
 * rhub v2 on (including fedora40 with gcc14 and clang)

0 errors | 0 warnings | 1 note

