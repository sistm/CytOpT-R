#' Function to.
#'
#'@param X_s a cytometry dataframe. The columns correspond to the different biological markers tracked.
#'One line corresponds to the cytometry measurements performed on one cell. The classification
#'of this Cytometry data set must be provided with the Lab_source parameters.
#'
#'@param X_t a cytometry dataframe. The columns correspond to the different biological markers tracked.
#'One line corresponds to the cytometry measurements performed on one cell. The CytOpT algorithm
#'targets the cell type proportion in this Cytometry data set
#'
#'@param levels a vector of the classe
#'
#'@param h_hat a vector of the estimations obtained method select
#'
#'@param eps an float value of regularization parameter of the Wasserstein distance. Default is \code{1e-04}
#'
#'@param n_iter an integer Constant that iterate method select. Default is \code{4000}
#'
#' @importFrom reticulate use_python
#' @import tidyverse
#' @import data.table
#'@export
#'
#'@return A list with the following elements:\itemize{
#'   \item \code{Lab_target_hat_one}
#'   \item \code{Lab_target_hat_two}
#' }
#'


Label_Prop_sto_r <- function (X_s, X_t,levels,h_hat,eps=1e-04, n_iter=4000){
  # Use Python Files
  reticulate::source_python(file = "CytOpT_pkg/Tools_CytOpt_Descent_Ascent.py")
  reticulate::source_python(file = "CytOpT_pkg/Tools_CytOpt_MinMax_Swapping.py")
  reticulate::source_python(file = "CytOpT_pkg/minMaxScale.py")
  reticulate::source_python(file = "CytOpT_pkg/CytOpt_plot.py")

  I <- nrow(X_s)
  J <- nrow(X_t)

  alpha <- 1/I * rep(1,I)
  beta <- 1/J * rep(1,J)

  alpha <- convertArray(alpha)
  beta <- convertArray(beta)

  u_last <- Robbins_Wass(X_s, X_t, alpha,beta, eps=eps, n_iter=n_iter)

  # Label propagation
  L_source <- matrix(0, 2, nrow(X_s))
  count <- 1
  for (k in levels) {
    L_source[count,] <- convertArray(Lab_source == k)
    count <- count + 1
  }

  t0 <- Sys.time()
  Result_LP <- Label_Prop_sto(L_source, u_last, X_s, X_t, alpha, beta, eps)

  elapsed_time <- Sys.time() - t0
  Lab_target_hat_one <- Result_LP[2]
  Lab_target_hat_one <- as.numeric(unlist(Lab_target_hat_one))
  cat('Elapsed_time ', elapsed_time/60, 'mins\n')

  names_pop <- c('CD8', 'CD4')
  X_tar_display <- convertArray(Stanford3A_values[c('CD4', 'CD8')])
  plot_py_2(X_tar_display, convertArray(Lab_target_hat_one), convertArray(Lab_target),names_pop)

  D <- matrix(0, I,length(levels))
  count <- 1
  for (k in levels) {
    D[,count] <- 1/sum(Lab_source == k) * as.double(Lab_source == k)
    count <- count + 1
  }
  alpha_mod <- dot_comput(convertArray(D),convertArray(h_hat))

  # Approximation of the optimal dual vector u.

  t0 <- Sys.time()
  u_last_two <- Robbins_Wass(X_source, X_target, alpha_mod, beta, eps=eps, n_iter=n_iter)

  elapsed_time <- Sys.time() - t0

  cat('Elapsed time :', elapsed_time/60, 'mins\n')

  # Label propogation
  t0 <- Sys.time()
  Result_LP <- Label_Prop_sto(L_source, u_last_two, X_source, X_target, alpha_mod, convertArray(beta), eps)

  elapsed_time <- Sys.time()-t0
  Lab_target_hat_two <- as.double(unlist(Result_LP[2]))

  cat('Elapsed time', elapsed_time/60, 'mins\n')

  # Display of the label transfer results without or with reweighting.
  plot_py_3(X_tar_display,convertArray(Lab_target_hat_one),names_pop,convertArray(Lab_target_hat_two),convertArray(Lab_target))



  return(list('Lab_target_hat_one'=Lab_target_hat_one, 'Lab_target_hat_two'=Lab_target_hat_two))
}