.onLoad <- function(libname, pkgname) {
  reticulate::py_require("numpy")
  reticulate::py_require("sklearn")
  reticulate::py_require("scipy")
}
