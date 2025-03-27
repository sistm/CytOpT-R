Dear CRAN maintainers, 
I am aware this update comes only 1 day after the last update of CytOpT on CRAN (generating a Note)
and I apologize. However, this last update failed to fix the some of the issues 
reported on CRAN under fedora architectures in the check results. Through extensive 
checking via rhub, although I could not exactly reproduce this CRAN error, 
I believe to have fixed all issues now.
 
## R CMD check results

 * local R installation, R 4.4.3
 * Linux (Ubuntu 24.04), macOS (14.7) and Windows (Server 2022 10.0), R devel and release (through GitHub Actions)
 * win-builder
 * rhub v2 (including fedora40 with gcc14 and clang)

0 errors | 0 warnings | 1 note

