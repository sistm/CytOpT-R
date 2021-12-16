library(CytOpT)
library(reticulate)
data(X_source)
data(X_target)
data(Lab_source)
data(Lab_target)

# Create theta_true example
theta_true <- rep(0,10)
for (k in 1:10) theta_true[k] <- sum(Lab_target == k)/length(Lab_target)

context("test CytOpt")
CytOpt(X_source, X_target, Lab_source, theta_true=theta_true, method='comparison_opt') # Comparison two methods
cytopt_desasc_r(X_source, X_target, Lab_source,theta_true) # Use Desasc method
cytopt_minmax_r(X_source, X_target, Lab_source,theta_true) # Use Minmax method