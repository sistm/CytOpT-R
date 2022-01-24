#' CytOpt on the HIPC Data
#'
#' This function aims apply our method  CytOpT on various datasets of the HIPC panel.
#'
#' @examples
#'
#' \dontrun{
#'    CytOpt_HIPC_Data_test()
#' }
#'
#' \donttest{
#'    CytOpt_HIPC_Data_test()
#' }

CytOpt_HIPC_Data_test <- function() {
   data(X_source)
   data(Lab_source)
   data(Stanford3C_values)
   data(Stanford3C_clust)
   data(Miami3A_values)
   data(Miami3A_clust)


   # Descent-ascent procedure
   # Setting of the parameters for the descent-ascent procedure.
   n_it_grad <- 10000
   n_it_sto <- 10
   pas_grad <- 10
   eps <- 0.0005

   # Minmax swapping procedure
   # parameters setting for the second procedure
   lbd <- 0.0001
   eps_two <- 0.0001
   n_iter <- 10000
   step_size <- 5
   power <- 0.99

   # ---------------------------- Stanford3C DATA INPUT ----------------------------------------------
   # Target data : Stanford3C
   # Preprocessing of the target data
   X_target_Stanford3C <- (Stanford3C_values)
   Lab_target_Stanford3C <- (Stanford3C_clust)

   # Create theta_true example
   h_true <- rep(0,10)
   for (k in 1:10) h_true[k] <- sum(Lab_target_Stanford3C == k)/length(Lab_target_Stanford3C)

   # Descent-ascent procedure
   h_hat1 <- cytopt_desasc_r(X_s = X_source,
                             X_t = X_target_Stanford3C,
                             Lab_source = Lab_source,
                             eps = eps, n_out = n_it_grad, n_stoc = n_it_sto, step_grad = pas_grad)[1][[1]]

   # Minmax swapping procedure
   h_hat2 <- cytopt_minmax_r(X_s = X_source,
                             X_t = X_target_Stanford3C,
                             Lab_source = X_target_Stanford3C ,
                            eps = eps_two, lbd = lbd, n_iter = n_iter, step = step_size, power = power)[1][[1]]
   df_res1 <- data.frame(h_hat1, h_hat2, h_true)

   # Barplot res
   barplot_prop(df_res1)

   # ---------------------------- Miami3A DATA INPUT ----------------------------------------------
   # Target Data : Miami3A
   X_target_Miami3A <- (Miami3A_values)
   Lab_target_Miami3A <- (Miami3A_clust)

   h_true <- rep(0,10)
   for (k in 1:10) h_true[k] <- sum(Lab_target_Miami3A == k)/length(Lab_target_Miami3A)

   # Descent-ascent procedure
   h_hat1 <- cytopt_desasc_r(X_s = X_source,X_t = X_target_Miami3A,
                             Lab_source = Lab_source,
                             eps = eps, n_out = n_it_grad, n_stoc = n_it_sto, step_grad = pas_grad)[1][[1]]

   # Minmax swapping procedure
   h_hat2 <- cytopt_minmax_r(X_s = X_source,
                             X_t = X_target_Miami3A,
                             Lab_source = X_target_Stanford3C ,
                             eps = eps_two, lbd = lbd, n_iter = n_iter, step = step_size, power = power)[1][[1]]

   df_res1 <- data.frame(h_hat1, h_hat2, h_true)

   # Barplot res
   barplot_prop(df_res1)

   return()
}