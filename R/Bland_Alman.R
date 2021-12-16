#' Function to display a bland plot in order to visually assess the agreement between cytopt estimation
#' of the class proportions and the estimate of the class proportions provided through manual gating.
#'
#'@param Estimate_Prop a data frame containing the estimate for two methods of the cell type
#' proportions returned by the CytOpT methode.
#'
#'@param True_Prop The benchmark estimate for the cell type proportions. It is provieded by the manual.
#'gating
#'
#'@param Lab_source a vector of length \code{n} Classification of the X_s cytometry data set
#'
#'@param title The name of the data set analysed.
#'
#' @importFrom reticulate use_python
#' @import tidyverse
#' @import data.table
#'@export
#'




Bland_Atlman_r <- function (Desac_hat,Minmax_hat,True_Prop, Lab_source){
  source_python(file = "CytOpT_pkg/CytOpt_plot.py")
  True_Prop <- matrix(True_Prop,ncol=length(unique(Lab_source)))

  # Desac_hat
  Desac_hat <- matrix(Desac_hat,ncol=length(unique(Lab_source)))
  Diff_propDesac <- getRavel(Desac_hat) - getRavel(True_Prop)
  Mean_propDesac <- (getRavel(Desac_hat) + getRavel(True_Prop))/2
  ClassesDesac <- rep(seq_along(unique(Lab_source)), nrow(Desac_hat))

  # Minmax_hat
  Minmax_hat <- matrix(Minmax_hat,ncol=length(unique(Lab_source)))
  Diff_propMinmax <- getRavel(Minmax_hat) - getRavel(True_Prop)
  Mean_propMinmax <- (getRavel(Minmax_hat) + getRavel(True_Prop))/2
  ClassesMinmax <- rep(seq_along(unique(Lab_source)), nrow(Minmax_hat))


  cat('Percentage of classes where the estimation error is below 10%\n')
  cat(sum(abs(Diff_propDesac) < 0.1)/length(Diff_propDesac) * 100,'\n')
  cat('Percentage of classes where the estimation error is below 5%\n')
  cat(sum(abs(Diff_propDesac) < 0.05)/length(Diff_propDesac) * 100,'\n')
  Dico_resDesac <- list('Desac_hat' = getRavel(Desac_hat) , 'True_Prop' = getRavel(True_Prop),
            'Diff' = Diff_propDesac, 'Mean' = Mean_propDesac,'Classe' = ClassesDesac)
  Dico_resDesac <- data.frame(Dico_resDesac)
  Dico_resDesac['Classe'] <- as.factor(Dico_resDesac[,'Classe'])
  sd_diffDesac <- sd(Diff_propDesac)
  cat('Standard deviation Desac:',sd_diffDesac,"\n")

  cat('Percentage of classes where the estimation error is below 10%\n')
  cat(sum(abs(Diff_propMinmax) < 0.1)/length(Diff_propMinmax) * 100,'\n')
  cat('Percentage of classes where the estimation error is below 5%\n')
  cat(sum(abs(Diff_propMinmax) < 0.05)/length(Diff_propMinmax) * 100,'\n')
  Dico_resMinmax <- list('Desac_hat' = getRavel(Minmax_hat) , 'True_Prop' = getRavel(True_Prop),
            'Diff' = Diff_propMinmax, 'Mean' = Mean_propMinmax,'Classe' = ClassesMinmax)
  Dico_resMinmax <- data.frame(Dico_resMinmax)
  Dico_resMinmax['Classe'] <- as.factor(Dico_resMinmax[,'Classe'])
  sd_diffMinmax <- sd(Diff_propMinmax)
  cat('Standard deviation Minmax:',sd_diffMinmax,'\n')

  sd_diff <- c(sd_diffDesac,sd_diffMinmax)
  n_pal <- length(unique(Dico_resDesac$Classe))
  cat('Standard deviation : ',sd_diff, '\n')
  Bland_AltmanComp(Dico_resDesac,Dico_resMinmax,sd_diff,n_pal)
}
