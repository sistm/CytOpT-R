test_that("CytOpt", {
  
  skip_if_notall_pythondeps()
  
  #load data
  data(X_source)
  data(X_target)
  data(Lab_source)
  data(Lab_target)
  
  # Create theta_true example
  theta_true <- rep(0,10)
  for (k in 1:10) theta_true[k] <- sum(Lab_target == k)/length(Lab_target)
  
  #run CytOpt
  res <- CytOpT(X_source, X_target, Lab_source, theta_true=theta_true, method='both') # Comparison two methods
  expect_length(res, 2)
  res2 <- cytopt_desasc_r(X_source, X_target, Lab_source,theta_true) # Use Desasc method
  expect_length(res2, 2)
  res3 <- cytopt_minmax_r(X_source, X_target, Lab_source,theta_true) # Use Minmax method
  expect_length(res3, 2)
  
})