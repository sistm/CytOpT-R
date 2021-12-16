#' Function to estimate the type cell proportions in an unclassified cytometry data set denoted X_s
#' by using the classification Lab_source from an other cytometry data set X_s. With this function
#' the computation of the estimate of the class proportions is done with a descent ascent algorithm.
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
#'@param theta_true If available, the true proportions in the target data set X_s. It allows to assess
#'the gap between the estimate of our method and the estimate of the cell type proportions derived from
#'manual gating.
#'
#'@param eps an float value of regularization parameter of the Wasserstein distance
#'
#'@param n_out an integer number of iterations in the outer loop. This loop corresponds to the gradient
#'descent algorithm to minimize the regularized Wasserstein distance between the source and
#'target data sets.
#'
#'@param n_stoc an integer number of iterations in the inner loop. This loop corresponds to the stochastic
#'algorithm that approximates a maximizer of the semi dual problem
#'
#'@param step_grad an integer number step size of the gradient descent algorithm of the outer loop.
#'
#'@importFrom reticulate use_python
#'@import tidyverse
#'@import data.table
#'@export
#'
#'
#'@return A list with the following elements:\code{h_hat}
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
#' cytopt_desasc_r(X_s=X_source, X_t=X_target,
#'                Lab_source=convertArray(Lab_source),
#'                theta_true=theta_true)


cytopt_desasc_r <- function(X_s, X_t, Lab_source,theta_true=theta_true,
                            eps=1e-04, n_out=1000, n_stoc=10,
                            step_grad=50){
  stopifnot(!is.null(X_s))
  stopifnot(!is.null(X_t))
  stopifnot(!is.null(Lab_source))
  stopifnot(!is.null(theta_true))

  source_python(file = "CytOpT_pkg/Tools_CytOpt_Descent_Ascent.py")
  source_python(file = "CytOpT_pkg/Tools_CytOpt_MinMax_Swapping.py")
  source_python(file = "CytOpT_pkg/minMaxScale.py")
  source_python(file = "CytOpT_pkg/CytOpt_plot.py")

  X_s <- as.matrix(X_s)
  X_t <- as.matrix(X_t)

  Lab_source <- convertArray(Lab_source)

  # Preprocessing of the data
  X_s <- X_s * (X_s > 0)
  X_t <- X_t * (X_t > 0)

  X_s <- Scale(X_s)
  X_t <- Scale(X_t)

  t0 <- Sys.time()
  h_hat <- cytopt_desasc(X_s, X_t, Lab_source=Lab_source, eps=eps, n_out=n_out,
                     n_stoc=n_stoc, step_grad=step_grad, theta_true=theta_true)

  elapsed_time <- Sys.time()-t0
  cat('Elapsed time:', elapsed_time/60, 'mins\n')
  return(h_hat)
}
