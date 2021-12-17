library(reticulate)
library(tidyverse)
library(base)
library(data.table)

source_python(file = "../../inst/python/CytOpt_plot.py")
source_python(file = "../../inst/python/minMaxScale.py")
source_python(file = "../../inst/python/Tools_CytOpt_Descent_Ascent.py")
source_python(file = "../../inst/python/Tools_CytOpt_MinMax_Swapping.py")

#Source Data

Stanford1A_values <- read.csv('tests/ressources/W2_1_values.csv')
Stanford1A_clust <- read.csv('tests/ressources/W2_1_clust.csv')[, 2]

#Target Data

Stanford3A_values <- read.csv('tests/ressources/W2_7_values.csv')
Stanford3A_clust <- read.csv('tests/ressources/W2_7_clust.csv')[, 2]

X_source <- convertArray(Stanford1A_values)
X_target <- convertArray(Stanford3A_values)

#Thresholding of the negative values
X_source <- X_source * (X_source > 0)
X_target <- X_target * (X_target > 0)


X_source <- Scale(X_source)
X_target <- Scale(X_target)

Lab_source <- convertArray(Stanford1A_clust)
Lab_target <- convertArray(Stanford3A_clust)


theta_true <- rep(0,10)
for (k in 1:10) theta_true[k] <- sum(Lab_target == k)/length(Lab_target)

cat(theta_true)

eps <- 0.0001
lbd <- 0.0001
n_iter <- 4000
step_grad <- 5
power <- 0.99


t0 <- Sys.time()
Results_Minmax <- cytopt_minmax(X_source, X_target, convertArray(Lab_source), eps=0.0001, lbd=0.0001, n_iter=n_iter,
                  theta_true=theta_true, step=step_grad, power=power, monitoring=T)
elapsed_time <- Sys.time()-t0
cat('Elapsed time : ',elapsed_time/60, 'Mins')


h_hat <- Results_Minmax[1][[1]]
Minmax_monitoring <- Results_Minmax[2][[1]]


n_it_grad <- 1000
n_it_sto <- 10
pas_grad <- 50
eps <- 0.0001


t0 <- Sys.time()
res_two <- cytopt_desasc(X_s=X_source, X_t=X_target, Lab_source=convertArray(Lab_source), eps=eps, n_out=n_it_grad,
                     n_stoc=n_it_sto, step_grad=pas_grad, theta_true=theta_true)

elapsed_time <- Sys.time()-t0
h_hat_two <- res_two[1][[1]]
Desasc_monitoring <- res_two[2][[1]]
n_0 <- 10
n_stop <- 1000

plot_py_Comp(n_0, n_stop, Minmax_monitoring, Desasc_monitoring)

