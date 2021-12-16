library(reticulate)
library(tidyverse)
library(base)
library(data.table)

source_python(file = "CytOpT_pkg/CytOpt_plot.py")
source_python(file = "CytOpT_pkg/minMaxScale.py")
source_python(file = "CytOpT_pkg/Tools_CytOpt_Descent_Ascent.py")
source_python(file = "CytOpT_pkg/Tools_CytOpt_MinMax_Swapping.py")


# Data import
Stanford1A_values <- read.csv("tests/ressources/W2_1_values.csv") %>% select(CD4, CD8)
Stanford1A_clust <- read.csv('tests/ressources/W2_1_clust.csv') %>% select(x)

#Target Data
Stanford3C_values <- read.csv('tests/ressources/W2_9_values.csv') %>% select(CD4, CD8)
Stanford3C_clust <- read.csv('tests/ressources/W2_9_clust.csv') %>% select(x)

Miami3A_values <- read.csv('tests/ressources/pM_7_values.csv') %>% select(CD4, CD8)
Miami3A_clust <- read.csv('tests/ressources/pM_7_clust.csv') %>% select(x)


Ucla2B_values <- read.csv('tests/ressources/IU_5_values.csv') %>% select(CD4, CD8)
Ucla2B_clust <- read.csv('tests/ressources/IU_5_clust.csv') %>% select(x)


X_source <- convertArray(Stanford1A_values)
X_source <- X_source * (X_source > 0)

X_source <- Scale(X_source)

Lab_source <- convertArray(as.array(Stanford1A_clust[,'x']))


X_target <- convertArray(Stanford3C_values)
X_target <- X_target * (X_target > 0)
X_target <- Scale(X_target)
Lab_target <- convertArray(Stanford3C_clust[,'x'])



theta_true <- rep(0,10)
for (k in 1:10) theta_true[k] <- sum(Lab_target == k)/length(Lab_target)

eps <- 0.0001
n_out <- 4000
n_stoc <- 10
step_grad <- 50

t0 <- Sys.time()
Results_Desasc <- cytopt_desasc(X_source, X_target, convertArray(Lab_source), eps=eps, n_out=n_out, n_stoc=n_stoc,
                           step_grad=step_grad, theta_true=theta_true)
elapsed_time <- Sys.time() - t0

cat('Elapsed time:', elapsed_time/60, 'mins')
h_hat1 <- Results_Desasc[1][[1]]


eps <- 0.0001
lbd <- 0.0001
n_iter <- 4000
step_grad <- 5
power <- 0.99


t0 <- Sys.time()

Results_Minmax <- cytopt_minmax(X_source, X_target, convertArray(Lab_source), eps=0.0001, lbd=0.0001, n_iter=n_iter,
                  theta_true=theta_true, step=step_grad, power=power, monitoring=FALSE)


elapsed_time <- Sys.time()-t0
cat('Elapsed time:', elapsed_time/60, 'mins')

h_hat2 <- Results_Minmax[1][[1]]

Proportion <- c(h_hat1, h_hat2, theta_true)
Classes <- rep(1:10,3)
Methode <- rep(c('CytOpt_DesAsc', 'CytOpt_Minmax', 'Manual'), each = 10)
df_res1 <- data.frame('Proportions' = Proportion, 'Classes' = Classes, 'Methode' = Methode)

plot_py_prop2(df_res1)


X_target <- convertArray(Miami3A_values)
X_target <- X_target * (X_target > 0)
X_target <- Scale(X_target)
Lab_target <- convertArray(Miami3A_clust[,'x'])


h_true <- rep(0,10)
for (k in 1:10) h_true[k] <- sum(Lab_target == k)/length(Lab_target)


t0 <- Sys.time()
h_hat1 <- cytopt_desasc(X_source, X_target, convertArray(Lab_source), eps=eps, n_out=n_out, n_stoc=n_stoc,
                           step_grad=step_grad, theta_true=theta_true)[1][[1]]
elapsed_time <- Sys.time() - t0

cat('Elapsed_time :', elapsed_time/60, 'mins')

t0 <- Sys.time()
Results_Minmax <- cytopt_minmax(X_source, X_target, convertArray(Lab_source), eps=0.0001, lbd=0.0001, n_iter=n_iter,
                  theta_true=theta_true, step=step_grad, power=power, monitoring=FALSE)

elapsed_time <- Sys.time()-t0


cat('Elapsed time : ',elapsed_time/60, 'Mins')

h_hat2 <- Results_Minmax[1][[1]]

Proportion <- c(h_hat1, h_hat2, h_true)
Diff_prop <- getRavel(convertArray(h_true)) - getRavel(h_hat1)
Mean_prop <- (getRavel(convertArray(h_true)) + getRavel(h_hat1))/2

Classes <- rep(1:10,3)
Methode <- rep(c('CytOpt_DesAsc', 'CytOpt_Minmax', 'Manual'), each = 10)
df_res1 <- data.frame('Proportions' = Proportion, 'Classes' = Classes, 'Methode' = Methode)
plot_py_prop2(df_res1)




X_target <- convertArray(Ucla2B_values)
X_target <- X_target * (X_target > 0)
X_target <- Scale(X_target)
Lab_target <- convertArray(Ucla2B_clust[,'x'])


h_true <- rep(0,10)
for (k in 1:10) h_true[k] <- sum(Lab_target == k)/length(Lab_target)


t0 <- Sys.time()
h_hat1 <- cytopt_desasc(X_source, X_target, convertArray(Lab_source), eps=eps, n_out=n_out, n_stoc=n_stoc,
                           step_grad=step_grad, theta_true=h_true)[1][[1]]
elapsed_time <- Sys.time() - t0


cat('Elapsed_time :', elapsed_time/60, 'mins')

t0 <- Sys.time()
results <- cytopt_minmax(X_source, X_target, convertArray(Lab_source), eps=0.0001, lbd=0.0001, n_iter=n_iter,
                  theta_true=h_true, step=step_grad, power=power, monitoring=FALSE)
elapsed_time <- Sys.time() - t0


cat('Elapsed time : ',elapsed_time/60, 'Mins')

h_hat2 <- results[1][[1]]

Proportion <- c(h_hat1, h_hat2, h_true)
Methode <- rep(c('CytOpt_DesAsc', 'CytOpt_Minmax', 'Manual'), each = 10)
df_res1 <- data.frame('Proportions' = Proportion, 'Classes' = Classes, 'Methode' = Methode)

plot_py_prop2(df_res1)