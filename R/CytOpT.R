#' Function to estimate the type cell proportions in an unclassified cytometry data set denoted X_s
#' by using the classification Lab_source from an other cytometry data set X_s. With this function
#' the computation of the estimate of the class proportions is done with a descent ascent or minmax
#' or two algorithms.
#'
#'@param X_s a cytometry dataframe. The columns correspond to the different biological markers tracked.
#'One line corresponds to the cytometry measurements performed on one cell. The classification
#'of this Cytometry data set must be provided with the Lab_source parameters.
#'
#'@param X_t a cytometry dataframe. The columns correspond to the different biological markers tracked.
#'One line corresponds to the cytometry measurements performed on one cell. The CytOpT algorithm
#'targets the cell type proportion in this Cytometry data set
#'
#'@param Lab_source a vector of length \code{n} Classification of the X_s cytometry data set
#'
#'@param method a character string indicating which method to use to
#'compute the cytopt, either \code{'cytopt_minmax'}, \code{'cytopt_desasc'}
#' or  \code{'comparison_opt'} for Comparison two methods Desasc or Minmax.
#'Default is \code{'cytopt_minmax'} since it is the method used in the test.
#'
#'@param theta_true If available, the true proportions in the target data set X_s. It allows to assess
#'the gap between the estimate of our method and the estimate of the cell type proportions derived from
#'manual gating.
#'
#'@param eps an float value of regularization parameter of the Wasserstein distance. Default is \code{1e-04}
#'
#' @param n_iter an integer Constant that iterate method select. Default is \code{4000}
#'
#' @param power an float constant the step size policy of the gradient ascent method is step/n^power. Default is \code{0.99}
#'
#'@param step_grad an integer number step size of the gradient descent algorithm of the outer loop.
#' Default is \code{50}
#'
#'@param step an integer constant that multiply the step-size policy. Default is \code{5}
#'
#'@param lbd an float constant that multiply the step-size policy. Default is \code{1e-04}
#'
#'@param n_out an integer number of iterations in the outer loop. This loop corresponds to the gradient
#'descent algorithm to minimize the regularized Wasserstein distance between the source and
#'target data sets. Default is \code{1000}
#'
#'@param n_stoc an integer number of iterations in the inner loop. This loop corresponds to the stochastic
#'algorithm that approximates a maximizer of the semi dual problem. Default is \code{10}
#'
#' @param n_0 an integer value. Default is \code{10}
#'
#' @param n_stop an integer value. Default is \code{1000}
#'
#'@param monitoring a logical flag indicating to possibly monitor the gap between the estimated proprotions and the manual
#'gold-standard. Default is \code{FALSE}
#'
#'
#'@importFrom reticulate use_python
#'@import tidyverse
#'@import data.table
#'@export
#'
#'
#'
#'@return A list with the following elements:\itemize{
#'   \item \code{h_hat}
#'   \item \code{Res_df}
#'   \item \code{Dico_res}
#'   \item \code{h_monitoring}
#' }
#'
#'
#'
#'@examples
#' Stanford1A_values <- read.csv('tests/ressources/W2_1_values.csv')
#' Stanford1A_clust <- read.csv('tests/ressources/W2_1_clust.csv')[, 2]
#' Stanford3A_values <- read.csv('tests/ressources/W2_7_values.csv')
#' Stanford3A_clust <- read.csv('tests/ressources/W2_7_clust.csv')[, 2]
#' X_source <- convertArray(Stanford1A_values)
#' X_target <- convertArray(Stanford3A_values)
#' X_source <- X_source * (X_source > 0)
#'
#' theta_true <- rep(0,10)
#' for (k in 1:10) theta_true[k] <- sum(Lab_target == k)/length(Lab_target)
#'
#' CytOpt(X_source, X_target, Lab_source, theta_true=theta_true, method='comparison_opt')


CytOpt <- function (X_s=NULL,
                    X_t=NULL,
                    Lab_source=NULL,
                    Lab_target=NULL,
                    theta_true=NULL,
                    cell_type=NULL,
                    names_pop=NULL,
                    method = c("cytopt_minmax","cytopt_desasc","comparison_opt"),
                    eps=1e-04,n_iter=4000,power=0.99,step_grad=50,
                    step=5,lbd=1e-04, n_out=1000, n_stoc=10, n_0 = 10,
                    n_stop=1000,minMaxScaler=T,monitoring=T, thresholding=T){

      # check
    stopifnot(is.data.frame(X_s) | is.array(X_s))
    stopifnot(is.data.frame(X_t) | is.array(X_t))
    stopifnot(!is.null(Lab_source) | !is.null(Lab_target))

    stopifnot(is.logical(monitoring))

    # READ PYTHON FILES WITH RETICULATE
    source_python(file = "CytOpT_pkg/Tools_CytOpt_Descent_Ascent.py")
    source_python(file = "CytOpT_pkg/Tools_CytOpt_MinMax_Swapping.py")
    source_python(file = "CytOpT_pkg/minMaxScale.py")
    source_python(file = "CytOpT_pkg/CytOpt_plot.py")


    Lab_source <- convertArray(Lab_source)
    labSourceUnique <- unique(Lab_source)
    if (length(labSourceUnique) <2){
        warning("warning")
    }
    if (!is.null(names_pop)  & length(names_pop) >= 2){
        h_source <- rep(0,2)
        for (k in labSourceUnique)
            h_source[k] <- sum(Lab_source == k) / length(Lab_source)
        names_pop <- names_pop[0:2]
        plot_py_1(X_s, X_t, Lab_source, 100 * h_source, names_pop)
    }


    if(is.null(cell_type)){
        warning("WARNING: cell_type is null")
        cell_type <- rep(labSourceUnique,length(labSourceUnique))
    }
    else cell_type <- rep(cell_type,length(labSourceUnique))
    if(length(method)>1) method <- method[1]

    if(thresholding){
        X_s <- X_s * (X_s> 0)
        X_t <- X_t * (X_t > 0)
    }
    if(minMaxScaler){
        X_s <- Scale(X_s)
        X_t <- Scale(X_t)
    }

    if(is.null(theta_true)) {
        warning("WARNING: theta_true is null")
        theta_true <- rep(0,length(labSourceUnique))
        for (index in seq(1,length(labSourceUnique)))
            theta_true[index] <- sum(Lab_target == index) / length(Lab_target)
    }

    if(length(method)>2)
      method <- method[1]

    if(method %in% c('cytopt_desasc', 'cytopt_minmax')){
        if(method == "cytopt_desasc")
          res_Meth <- cytopt_desasc_r(X_s, X_t,Lab_source,
                                      theta_true=theta_true,eps=eps, n_out=n_out,
                                      n_stoc=n_stoc, step_grad=step_grad)
        else
          res_Meth <-  cytopt_minmax_r(X_s, X_t, Lab_source,
                                       eps=eps, lbd=lbd, n_iter=n_iter,
                                       theta_true=theta_true, step=step, power=power, monitoring=monitoring)
        h_hat <- res_Meth[1][[1]]
        h_monitoring <- res_Meth[2][[1]]
        percentage <- c(theta_true,h_hat)
        methods <- rep(c('Manual Benchmark', method), each = length(labSourceUnique))
        Res_df <- data.frame('Percentage'= percentage, 'Cell_Type' = cell_type[seq_along(percentage)], 'Method' = methods)
        theta_true.ravel <- getRavel(theta_true)

        h_hat.ravel <- getRavel(h_hat)
        Diff_prop <- theta_true.ravel - h_hat.ravel
        cat(Diff_prop,'\n')
        sd_diff <- sd(Diff_prop)*sqrt((length(Diff_prop)-1)/length(Diff_prop))
        cat('Standard deviation:', sd_diff,'\n')

        Mean_prop <- (theta_true.ravel + h_hat.ravel) / 2
        cat('Mean proportion:', Mean_prop,'\n')

        cat('Percentage of classes where the estimation error is below 10% with CytOpT Desasc \n')
        cat(sum(abs(Diff_prop) < 0.1) / length(Diff_prop) * 100,'\n')
        cat('Percentage of classes where the estimation error is below 5% with CytOpT Desasc \n')
        cat(sum(abs(Diff_prop) < 0.05) / length(Diff_prop) * 100,'\n')

        Classe <- factor(
          rep(labSourceUnique,
                int(length(Mean_prop) / length(labSourceUnique))),
                labels = labSourceUnique)

        Dico_res <- data.frame('h_hat'= h_hat.ravel,
                               'True_Prop'= theta_true.ravel,
                               'Diff'= Diff_prop,
                               'Mean'= Mean_prop,
                               'Classe'= Classe)

        Bland_Altman(Dico_res, sd_diff,
                     length(labSourceUnique), title=method)
        res <- list('h_hat'= h_hat, 'Res_df'= Res_df, 'Dico_res'= Dico_res, 'h_monitoring'=h_monitoring)
    }
    else{
        # desac
        t0 <- Sys.time()
        res_desac <- cytopt_desasc_r(X_s, X_t,Lab_source,theta_true=theta_true,eps=eps, n_out=n_out,
                     n_stoc=n_stoc, step_grad=step_grad)
        elapsed_time_desac <- Sys.time()-t0
        Desac_hat <- res_desac[1][[1]]
        Desasc_monitoring <- res_desac[2][[1]]
        cat("Time running execution Desac ->", elapsed_time_desac,'s\n')

        # Minmax
        t0 <- Sys.time()
        res_Minmax <- cytopt_minmax_r(X_s, X_t, Lab_source, eps=eps, lbd=lbd, n_iter=n_iter,
                  theta_true=theta_true, step=step, power=power, monitoring=monitoring)
        elapsed_time_minMax <- Sys.time()-t0
        Minmax_hat <- res_Minmax[1][[1]]
        Minmax_monitoring <- res_Minmax[2][[1]]
        cat("Time running execution MinMax ->",elapsed_time_minMax,'s\n')
        plot_py_Comp(n_0, n_stop, Minmax_monitoring, Desasc_monitoring)

        Proportion <- c(Desac_hat, Minmax_hat, theta_true)
        Classes <- rep(labSourceUnique,3)
        Methode <- rep(c('CytOpt_DesAsc', 'CytOpt_Minmax', 'Manual'), each = length(labSourceUnique))
        df_res1 <- data.frame('Proportions' = Proportion, 'Classes' = Classes, 'Methode' = Methode)
        plot_py_prop2(df_res1)

        # Conatener les deux graphs
        Bland_Atlman_r(Desac_hat=convertArray(Desac_hat),Minmax_hat=convertArray(Minmax_hat),True_Prop=convertArray(theta_true),Lab_source=Lab_source)
        res <- list("Desac_h_hat" = Desac_hat, "Desasc_monitoring" = Desasc_monitoring,
                    "Minmax_h_hat" = Minmax_hat, "Minmax_monitoring" = Minmax_monitoring)
    }
    return(res)
}
