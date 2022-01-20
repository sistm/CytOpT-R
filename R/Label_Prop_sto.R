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
#'@param Lab_source a vector of length \code{n} Classification of the X_s cytometry data set
#'
#'@param eps an float value of regularization parameter of the Wasserstein distance. Default is \code{1e-04}
#'
#'@param const an float constant. Default is \code{1e-01}
#'
#'@param n_iter an integer Constant that iterate method select. Default is \code{4000}
#'
#'@param monitoring a logical flag indicating to possibly monitor the gap between the estimated proprotions and the manual
#'gold-standard. Default is \code{FALSE}
#'
#'@param minMaxScaler a logical flag indicating to possibly Scaler
#'
#'@param thresholding a logical flag.
#'
#' @importFrom reticulate import_from_path
#' @import data.table
#'@export
#'
#'@return A list with the following elements:\itemize{
#'   \item \code{Lab_target_hat_one}
#'   \item \code{Lab_target_hat_two}
#' }
#'


Label_Prop_sto_r <- function (X_s,X_t,
                              Lab_source=NULL,eps=1e-04, const=1e-01, n_iter=4000,
                              minMaxScaler=T, monitoring=T, thresholding=T){


     # check
    stopifnot(is.data.frame(X_s) | is.array(X_s))
    stopifnot(is.data.frame(X_t) | is.array(X_t))
    stopifnot(!is.null(Lab_source))
    stopifnot(is.logical(monitoring))


    # READ PYTHON FILES WITH RETICULATE
    python_path <- system.file("python", package = "CytOpT")
    pyCode <- reticulate::import_from_path("CytOpTpy", path = python_path)

    Lab_source <- pyCode$minMaxScale$convertArray(Lab_source)

    if(thresholding){
        X_s <- X_s * (X_s> 0)
        X_t <- X_t * (X_t > 0)
    }
    if(minMaxScaler){
        X_s <- pyCode$minMaxScale$Scale(X_s)
        X_t <- pyCode$minMaxScale$Scale(X_t)
    }

  I <- nrow(X_s)
  J <- nrow(X_t)

  alpha <- 1/I * rep(1,I)
  beta <- 1/J * rep(1,J)

  alpha <- pyCode$minMaxScale$convertArray(alpha)
  beta <- pyCode$minMaxScale$convertArray(beta)

  u_last <- pyCode$Tools_CytOpt_Descent_Ascent$Robbins_Wass(X_s, X_t,
                                                            alpha=alpha,beta=beta,
                                                            eps=eps, const=const, n_iter=n_iter)

  # Label propagation
  # L_source <- matrix(0, 2, nrow(X_s))
  # count <- 1
  # for (k in levels) {
  #   L_source[count,] <- pyCode$minMaxScale$convertArray(L_source == k)
  #   count <- count + 1
  # }

  t0 <- Sys.time()
  Result_LP <- pyCode$Tools_CytOpt_Descent_Ascent$Label_Prop_sto(Lab_source, u_last,
                                                                 X_s, X_t,
                                                                 alpha, beta, eps)
  elapsed_time <- Sys.time() - t0
  Lab_target_hat_one <- Result_LP[2]
  Lab_target_hat_one <- as.numeric(unlist(Lab_target_hat_one))
  message('Elapsed_time ', elapsed_time/60, 'mins\n')

  # names_pop <- c('CD8', 'CD4')
  # X_tar_display <- pyCode$minMaxScale$convertArray(X_s[c('CD4', 'CD8')])
  # pyCode$CytOpt_plot$plot_py_2(X_tar_display, pyCode$minMaxScale$convertArray(Lab_target_hat_one), pyCode$minMaxScale$convertArray(Lab_target_hat_one),names_pop)

  # levels_Labs <- length(unique(Lab_source))
  # D <- matrix(0, I,levels_Labs)
  # count <- 1
  # for (k in unique(Lab_source)) {
  #   D[,count] <- 1/sum(Lab_source == k) * as.double(Lab_source == k)
  #   count <- count + 1
  # }
  # alpha_mod <- pyCode$minMaxScale$dot_comput(pyCode$minMaxScale$convertArray(D),pyCode$minMaxScale$convertArray(h_hat))

  # # Approximation of the optimal dual vector u.
  #
  # t0 <- Sys.time()
  # u_last_two <- pyCode$Tools_CytOpt_Descent_Ascent$Robbins_Wass(X_s, X_t, alpha_mod, beta, eps=eps, n_iter=n_iter)
  #
  # elapsed_time <- Sys.time() - t0
  #
  # cat('Elapsed time :', elapsed_time/60, 'mins\n')
  #
  # # Label propogation
  # t0 <- Sys.time()
  # Result_LP <- pyCode$Tools_CytOpt_Descent_Ascent$Label_Prop_sto(Lab_source, u_last_two, X_s, X_t, alpha_mod, pyCode$minMaxScale$convertArray(beta), eps)
  #
  # elapsed_time <- Sys.time()-t0
  # Lab_target_hat_two <- as.double(unlist(Result_LP[2]))
  #
  # cat('Elapsed time', elapsed_time/60, 'mins\n')
  #
  # # Display of the label transfer results without or with reweighting.
  # pyCode$CytOpt_plot$plot_py_3(X_tar_display,pyCode$minMaxScale$convertArray(Lab_target_hat_one),names_pop,pyCode$minMaxScale$convertArray(Lab_target_hat_two),pyCode$minMaxScale$convertArray(Lab_target_hat_one))
  #
  return(list('Lab_target_hat_one'=Lab_target_hat_one))
}