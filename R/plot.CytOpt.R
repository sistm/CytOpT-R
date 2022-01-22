#'@method plot CytOpt
#'@import patchwork
#'@export
#'

plot.CytOpt <- function(x, ...){
  
  if(colnames(x$proportions)[1] == "Gold_standard"){
    KL_plot(x$monitoring) /
      barplot_prop(x$proportions)
  }else{
    barplot_prop(x$proportions)
  }
}