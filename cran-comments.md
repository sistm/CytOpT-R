Dear CRAN maintainers, I am aware this update comes very shortly after the initial release of CytOpT on CRAN and I apologize.
However, a quick fix to the code is needed as the main function of the package was not working as intended: indeed, it failed to adequatly monitor the optimization progress, and the subsequent plot() method was also not behaving properly, throwing an error in certain configurations.
Again, Apologies for submitting an update so quickly, I am fully aware of the CRAN policy on submission frequency, and future updates to CytOpT will not be submitted until a few months pass.
Thank you.
 
## R CMD check results

 * local R installation, R 4.1.2
 * Linux (Ubuntu 20.04), macOS (11.6) and Windows (Server 2019 10.0), R devel and release (through GitHub Actions)
 * win-builder

0 errors | 0 warnings | 0 notes

