#' Function to display a bland plot in order to visually assess the agreement between CytOpt estimation
#' of the class proportions and the estimate of the class proportions provided through manual gating.
#'
#'@param proportions \code{data.frame} of true and proportion estimates from \code{CytOpt()}
#'
#'@param additional_info_shape vector of additional information to be used for shape in the plot. Not implemented yet.
#'
#'
#'@importFrom reshape2 melt
#'@import ggplot2
#'@export


Barplot_prop <- function (proportions, additional_info_shape = NULL){

  proportions$Population <- rownames(proportions)
  data2barplot <- reshape2::melt(proportions, id.vars="Population",
                              value.name = "Estimate", variable.name = "Method")

  data2barplot$Method <- gsub("MinMax", "MinMax swapping",
                           gsub("Descent_ascent", "Descent-Ascent",
                             gsub("Gold_standard","Manual estimation", data2barplot$Method)))

  data2barplot$Method <- factor(data2barplot$Method,
                                levels = c("Descent-Ascent", "MinMax swapping", "Manual estimation"))

  data2barplot$Population <- factor(data2barplot$Population,levels = unique(data2barplot$Population))

  p <- ggplot(data=data2barplot, aes(x=Population,
                                            y=Estimate,
                                                   fill=Method)) +
          geom_bar(stat="identity", position=position_dodge(), colour="black") +
          scale_fill_manual(values=c("#013220","#00FF00","#f08080")) +
          ggtitle("CytOpt estimation and Manual estimation") +
          theme(legend.title=element_blank()) +
          theme_bw()


  if(!is.null(additional_info_shape)){
    # Not implemented yet
    #p <- p +
  }

  return(p)

  }
