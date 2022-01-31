#'CytOpt print
#'
#'print S3 method for CytOpt object
#'
#'@param x an object of class \code{CytOpt} to print.
#'@param ... further arguments passed to or from other methods. Not implemented.
#'
#'@method print CytOpt
#'@export


print.CytOpt <- function(x, ...){
  cat("A CytOpt object\n\n")
  cat("Cell proportions:\n")
  print(x$proportions)
}
