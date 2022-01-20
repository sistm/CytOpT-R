#' Function to display a bland plot in order to visually assess the agreement between CytOpt estimation
#' of the class proportions and the estimate of the class proportions provided through manual gating.
#'
#'@param proportions \code{data.frame} of true and proportion estimates from \code{CytOpt()}
#'
#'@param additional_info_shape vector of additional information to be used for shape in the plot. Not implemented yet.
#'
#'
#'@importFrom stats sd relevel
#'@importFrom reshape2 melt
#'@import ggplot2
#'@export


Bland_Atlman <- function (proportions, additional_info_shape = NULL){
  
  proportions$Population <- rownames(proportions)
  data2plot <- reshape2::melt(proportions, id.vars=c("Gold_standard", "Population"), 
                              value.name = "Estimate", variable.name = "Method")
  data2plot$diff <- data2plot$Estimate -data2plot$Gold_standard
  data2plot$avg <- (data2plot$Estimate + data2plot$Gold_standard)/2
  
  data2plot$Method <- gsub("MinMax", "MinMax swapping", 
                           gsub("Descent_ascent", "Descent-Ascent", data2plot$Method))
  data2plot$Population <- factor(data2plot$Population, 
                                 levels = sort(as.numeric(unique(data2plot$Population))))
  
  stats2plot <- data.frame()
  for (m in unique(data2plot$Method)){
    temp_diff <- data2plot$diff[data2plot$Method == m]
    stats2plot <- rbind.data.frame(stats2plot, 
                                   cbind.data.frame("Method" = m,
                                                    "Mean" = mean(temp_diff),
                                                    "Up" = mean(temp_diff) + 1.96*sd(temp_diff),
                                                    "Down" = mean(temp_diff) - 1.96*sd(temp_diff)
                                   )
    )
  }
  
  p <- ggplot(data2plot, aes_string(x="avg", y="diff")) +
      #geom_smooth(formula='y~1', method = lm, aes(linetype="Mean")) +
      geom_hline(data = stats2plot, aes(yintercept = !!sym("Mean"), linetype="Mean bias")) +
      geom_hline(data = stats2plot, aes(yintercept = !!sym("Up"), linetype="+/- 1.96*sd")) +
      geom_hline(data = stats2plot, aes(yintercept = !!sym("Down"), linetype="+/- 1.96*sd")) +
      geom_point(aes_string(color = "Population")) +
      scale_linetype_manual("", values = c(1, 2), breaks = c("Mean bias", "+/- 1.96*sd")) +
      facet_wrap("Method") +
      ylab(expression((hat(p[i])-p[i]))) +
      xlab(expression((hat(p[i])+p[i])/2)) +
      ggtitle("Bland-Altman concordance plot") +
      theme_bw()
  
  if(!is.null(additional_info_shape)){
    # Not implemented yet
    #p <- p +
  }
  
  return(p)
  
  }
  