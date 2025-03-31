Dear CRAN maintainers,

I apologize, it was never my intention to "squander" neither your time nor the 
CRAN computing resources. 

In this update, I tried my very best so that building the vignette would not use 
several processes/threads, as well as for testing. Again, as this issue is only 
happening under fedora architectures on CRAN and is not reproduced on the 
win-builder or with rhubv2, I can only hope that my extensive checking via rhub 
and close monitoring of execution load on my machine (thanks to the top command) 
can ensure all issues have now been fixed, as I believe they have.
I have 1 Note due to this being a submission of an archived package.

Sincerely yours,
Boris Hejblum

 
## R CMD check results

 * local R installation, R 4.4.3
 * Linux (Ubuntu 24.04), macOS (14.7) and Windows (Server 2022 10.0), R devel and release (through GitHub Actions)
 * win-builder
 * rhub v2 on (including fedora40 with gcc14 and clang)

0 errors | 0 warnings | 1 note

