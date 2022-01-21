#' Function to display a bland plot in order to visually assess the agreement between CytOpt estimation
#' of the class proportions and the estimate of the class proportions provided through manual gating.
#'
#'@param monitoring \code{list} of monitoring estimates from \code{CytOpt()}
#'
#'@param additional_info_shape vector of additional information to be used for shape in the plot. Not implemented yet.
#'
#'
#'@import ggplot2
#'@export


KL <- function (monitoring, n_0 = 10, n_stop=1000, additional_info_shape = NULL){

    # checks ----
  stopifnot(!(is.integer(n_0) & is.integer(n_stop)))

  index <- seq(n_0,n_stop)
  data2Opt <- data.frame("index" = index,
                        "values"=c(res$monitoring$MinMax[index],
                                   res$monitoring$Descent_ascent[index]),
                        "Method"=factor(rep(names(res$monitoring),each=length(index))))

  data2Opt$Method <- gsub("MinMax", "MinMax swapping",
                           gsub("Descent_ascent", "Descent-Ascent", data2Opt$Method))

  p <- ggplot(data2Opt, aes(x = index, y = values)) +
          geom_line(aes(color = Method)) +
          scale_color_manual(values = c("#00AFBB", "#E7B800")) +
          ylab( expression(paste("KL(", hat(p), "|p)"))) +
          xlab("Iteration") +
          ggtitle("Comparison optimization procedures") +
          theme_bw()

  if(!is.null(additional_info_shape)){
    # Not implemented yet
    #p <- p +
  }
  return(p)

  }
