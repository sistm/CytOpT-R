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
#'@param cell_type a vector indicate type of cell
#'
#'@param names_pop //commentary
#'
#'@param Lab_target a vector of length \code{n} classification of the X_t cytometry data set
#'
#'@param method a character string indicating which method to use to
#'compute the cytopt, either \code{'minmax'}, \code{'desasc'}
#' or  \code{'both'} for comparing both Min-max swapping and descent-ascent procedures.
#'Default is \code{'minmax'}.
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
#'@param n_0 an integer value. Default is \code{10}
#'
#'@param n_stop an integer value. Default is \code{1000}
#'
#'@param monitoring a logical flag indicating to possibly monitor the gap between the estimated proprotions and the manual
#'gold-standard. Default is \code{FALSE}
#'
#'@param minMaxScaler a logical flag indicating to possibly Scaler
#'
#'@param thresholding a logical flag.
#'
#'@importFrom reticulate import_from_path
#'@importFrom stats sd

#'@export
#'
#'@return A list with the following elements:\itemize{
#'   \item \code{h_hat}
#'   \item \code{Res_df}
#'   \item \code{Dico_res}
#'   \item \code{h_monitoring}
#' }

CytOpT <- function (X_s=NULL,
                    X_t=NULL,
                    Lab_source=NULL,
                    Lab_target=NULL,
                    theta_true=NULL,
                    cell_type=NULL,
                    names_pop=NULL,
                    method = c("minmax","desasc","both"),
                    eps=1e-04, n_iter=4000, power=0.99, step_grad=50,
                    step=5,lbd=1e-04, n_out=1000, n_stoc=10, n_0 = 10,
                    n_stop=1000, minMaxScaler=TRUE, monitoring=TRUE, thresholding=TRUE){
  
  # Sanity checks ----
  stopifnot(is.data.frame(X_s) | is.array(X_s))
  stopifnot(is.data.frame(X_t) | is.array(X_t))
  stopifnot(!is.null(Lab_source) | !is.null(Lab_target))
  stopifnot(is.logical(monitoring))
  
  
  # READ PYTHON FILES WITH RETICULATE ----
  python_path <- system.file("python", package = "CytOpT")
  pyCode <- reticulate::import_from_path("CytOpTpy", path = python_path, delay_load = TRUE)
  
  
  # Preprocessing ----
  Lab_source <- pyCode$minMaxScale$convertArray(Lab_source)
  labSourceUnique <- unique(Lab_source)
  if (length(labSourceUnique) <2){
    warning("length(labSourceUnique) <2")
  }
  if (!is.null(names_pop)  & length(names_pop) >= 2){
    h_source <- rep(0,2)
    for (k in labSourceUnique)
      h_source[k] <- sum(Lab_source == k) / length(Lab_source)
    names_pop <- names_pop[0:2]
    pyCode$CytOpt_plot$plot_py_1(X_s, X_t, Lab_source, 100 * h_source, names_pop)
  }
  
  if(is.null(cell_type)){
    message("cell_type is NULL and labels are imputed as an integer sequence")
    cell_type <- rep(labSourceUnique,length(labSourceUnique))
  }
  else cell_type <- rep(cell_type,length(labSourceUnique))
  if(length(method)>1) method <- method[1]
  
  if(thresholding){
    X_s <- X_s * (X_s> 0)
    X_t <- X_t * (X_t > 0)
  }
  if(minMaxScaler){
    X_s <- pyCode$minMaxScale$Scale(X_s)
    X_t <- pyCode$minMaxScale$Scale(X_t)
  }
  
  if(is.null(theta_true)) {
    message("theta_true is NULL")
    theta_true <- rep(0,length(labSourceUnique))
    for (index in seq(1,length(labSourceUnique)))
      theta_true[index] <- sum(Lab_target == index) / length(Lab_target)
  }
  
  if(length(method)>1) {
    method <- method[1]
  }
  
  
  # Optimization ----
  h <- data.frame("Gold_standard" = theta_true)
  monitoring <- list()
  if(method %in% c("desasc", "both")) {
    message("Running Desent-ascent optimization...")
    t0 <- Sys.time()
    res_desasc <- cytopt_desasc_r(X_s, X_t,Lab_source,
                                  theta_true=theta_true,eps=eps, n_out=n_out,
                                  n_stoc=n_stoc, step_grad=step_grad)
    elapsed_time_desac <- Sys.time() - t0
    message("Done (", round(elapsed_time_desac, digits = 3),"s)")
    h <- cbind.data.frame(h, "Descent_ascent" = res_desasc[1][[1]])
    monitoring[["Descent_ascent"]] <- res_desasc[2][[1]]
  }
  
  if(method %in% c("minmax", "both")) {
    message("Running MinMax optimization...")
    t0 <- Sys.time()
    res_minmax <-  cytopt_minmax_r(X_s, X_t, Lab_source,
                                   eps=eps, lbd=lbd, n_iter=n_iter,
                                   theta_true=theta_true, step=step, power=power, monitoring=monitoring)
    elapsed_time_desac <- Sys.time() - t0
    message("Done (", round(elapsed_time_desac, digits = 3),"s)")
    h <- cbind.data.frame(h, "MinMax" = res_minmax[1][[1]])
    monitoring[["MinMax"]] <- res_minmax[2][[1]]
  }
  
  # Output ----
  res <- list("proportions" = h,
              "monitoring" = monitoring
  )
  class(res) <- "CytOpt"
  return(res)
}
