#'CytOpt summary
#'
#'summary S3 method for CytOpt object
#'
#'@param object	an object of class \code{CytOpt} for which a summary is desired.
#'@param ... further arguments passed to or from other methods. Not implemented.
#'
#'@method summary CytOpt
#'@export


summary.CytOpt <- function(object, ...){
  s <- list()
  s[["proportions"]] <- object$proportions
  
  if(!is.null(s$proportions$Gold_standard)){
    s[["KLdiv"]] <- lapply(object$monitoring, function(x){x[length(x)]})
  }else{
    s[["KLdiv"]] <- NULL
  }
  
  class(s) <- "summary.CytOpt"
  
  return(s)
}

#'CytOpt print summary
#'
#'print S3 method for summary.CytOpt object
#'
#'@param x	an object of class \code{summary.CytOpt} to print.
#'@param ... further arguments passed to or from other methods. Not implemented.
#'
#'@method print summary.CytOpt
#'@export

print.summary.CytOpt <- function(x, ...){
  method <- gsub("MinMax", "MinMax swapping", 
                 gsub("Descent_ascent", "Descent-Ascent", colnames(x$proportions)
                 ))
  if(method[1] == "Gold_standard"){
    method <- method[-1]
  }
  
  cat("Estimation of cytometry proportion with", paste0(method, collapse = " and "), "algorithms from CytOpt:\n")
  
  print(x$proportions)
  
  if(!is.null(x$KLdiv)){
    KLdivs <- unlist(x$KLdiv)
    names(KLdivs) <- gsub("MinMax", "MinMax swapping", 
                          gsub("Descent_ascent", "Descent-Ascent", names(KLdivs)
                          ))
    cat("\nFinal Kullback-Leibler divergences:\n")
    print(KLdivs)
  }
}