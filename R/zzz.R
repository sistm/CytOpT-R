.onLoad <- function(libname, pkgname) {
  reticulate::py_require("numpy")
  reticulate::py_require("scikit-learn")
  reticulate::py_require("scipy")
}
