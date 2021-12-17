library(reticulate)
library(tidyverse)
library(data.table)

source_python(file = "../../inst/python/CytOpt_plot.py")
source_python(file = "../../inst/python/minMaxScale.py")
source_python(file = "../../inst/python/Tools_CytOpt_Descent_Ascent.py")
source_python(file = "../../inst/python/Tools_CytOpt_MinMax_Swapping.py")
# Data import
Stanford1A_values <- read.csv("tests/ressources/W2_1_values.csv") %>% select(CD4, CD8)
Stanford1A_clust <- read.csv('tests/ressources/W2_1_clust.csv') %>% select(x)
Stanford3A_values <- read.csv('tests/ressources/W2_7_values.csv') %>% select(CD4, CD8)
Stanford3A_clust <- read.csv('tests/ressources/W2_7_clust.csv')%>% select(x)

X_source <- as.matrix(Stanford1A_values)
X_target <- as.matrix(Stanford3A_values)
X_sou_display <- as.matrix(Stanford1A_values)
X_tar_display <- as.matrix(Stanford3A_values)

Lab_source <- ifelse(Stanford1A_clust[,1]>=6, 1, 0)
Lab_target <- ifelse(Stanford3A_clust[,1]>=6, 1 , 0)
names_pop <- c('CD8', 'CD4')

# Computation of the benchmark class proportions
h_source <- rep(0,2)
h_true <- rep(0,2)

for (k in 0:1){
    h_source[k+1] <- sum(Lab_source == k)/length(Lab_source)
    h_true[k+1] <- sum(Lab_target == k)/length(Lab_target)
}
plot_py_1(X_source, X_target, convertArray(Lab_source), 100*h_source, names_pop)


# Classification using optimal transport without reweighting
I <- nrow(X_source)
J <- nrow(X_target)

alpha <- 1/I * rep(1,I)
beta <- 1/J * rep(1,J)

# Preprocessing of the data
X_source <- X_source * (X_source > 0)
X_target <- X_target * (X_target > 0)

X_source <- Scale(X_source)
X_target <- Scale(X_target)



# Approximation of the optimal dual vector u.
# In order to compute an approximation of the optimal transportation plan, we need to approximate  𝑃𝜀 .


eps <- 0.0001
n_iter <- 15000
t0 <- Sys.time()
u_last <- Robbins_Wass(X_source, X_target, convertArray(alpha),
                      convertArray(beta), eps=eps, n_iter=n_iter)
elapsed_time <- Sys.time() - t0
cat('Elapsed time :', elapsed_time/60, 'mins')

#Label propagation
L_source <- matrix(0, 2, nrow(X_source))
for (k in 1:0) L_source[k+1,] <- convertArray(Lab_source == k)


t0 <- Sys.time()

Result_LP <- Label_Prop_sto(L_source, u_last, X_source, X_target, alpha, beta, eps)

elapsed_time <- Sys.time() - t0
Lab_target_hat_one <- Result_LP[2]
Lab_target_hat_one <- as.numeric(unlist(Lab_target_hat_one))
cat('Elapsed_time ', elapsed_time/60, 'mins')
X_tar_display <- convertArray(Stanford3A_values[c('CD4', 'CD8')])
plot_py_2(X_tar_display, convertArray(Lab_target_hat_one), convertArray(Lab_target),names_pop)



# Class proportions estimation with  𝙲𝚢𝚝𝙾𝚙𝚝
# Descent-Ascent procedure
# Setting of the parameters


n_it_grad <- 1000
n_it_sto <- 10
pas_grad <- 50
eps <- 0.0001


t0 <- Sys.time()
h_hat <- cytopt_desasc(X_s=X_source, X_t=X_target, Lab_source=convertArray(Lab_source), eps=eps, n_out=n_it_grad,
                     n_stoc=n_it_sto, step_grad=pas_grad)[1][[1]]

elapsed_time <- Sys.time()-t0

cat('Elapsed time:', elapsed_time/60, 'mins')

# 𝙲𝚢𝚝𝙾𝚙𝚝  estimation and benchmark estimation

cat('Estimated proportions', h_hat)
cat('Benchmark proportions', h_true)

# Display of the estimation Results
percentage <- c(h_true,h_hat)
cell_type <- rep(c('CD8', 'CD4'),2)

method <- rep(c('Manual Benchmark', 'Transport Estimation'), each = 2)

Res_df <- data.frame('Percentage'= percentage, 'Cell_Type' = cell_type, 'Method' = method)
plot_py_prop1(Res_df)



# Minmax swapping procedure
# Setting of the parameters

eps <- 0.0001
lbd <- 0.0001
n_iter <- 4000
step_grad <- 5
power <- 0.99

t0 <- Sys.time()
Results_Minmax <- cytopt_minmax(X_source, X_target, convertArray(Lab_source), eps=eps, lbd=lbd, n_iter=n_iter,
                step=step_grad, power=power, monitoring=FALSE)


elapsed_time <- Sys.time()-t0

cat('Elapsed time : ', elapsed_time/60, 'Mins')

h_hat2 <- Results_Minmax[1][[1]]
cat(h_hat2)

# Comparison of the two minimization procedures

Proportion <- c(h_hat, h_hat2, h_true)
Classes <- rep(1:2,3)
Methode <- rep(c('CytOpt_DesAsc', 'CytOpt_Minmax', 'Manual'), each = 2)
df_res1 <- data.frame('Proportions'= Proportion, 'Classes'=Classes, 'Methode'=Methode)
plot_py_prop2(df_res1)




# Classification using optimal transport with reweighted proportions
# The target measure  𝛽  is reweighted in order to match the weight vector  ℎ̂   estimated with  𝙲𝚢𝚝𝙾𝚙𝚝 .

D <- matrix(0, I,2)
D[,1] <- 1/sum(Lab_source == 0) * as.double(convertArray(Lab_source == 0))
D[,2] <- 1/sum(Lab_source == 1) * as.double(convertArray(Lab_source == 1))
alpha_mod <- dot_comput(convertArray(D),convertArray(h_hat))

# Approximation of the optimal dual vector u.

eps <- 0.0001
n_iter <- 150000

t0 <- Sys.time()
u_last_two <- Robbins_Wass(X_source, X_target, alpha_mod, convertArray(beta), eps=eps, n_iter=n_iter)


elapsed_time <- Sys.time() - t0

cat('Elapsed time :', elapsed_time/60, 'mins')

# Label propogation
t0 <- Sys.time()
Result_LP <- Label_Prop_sto(L_source, u_last_two, X_source, X_target, alpha_mod, convertArray(beta), eps)

elapsed_time <- Sys.time()-t0
Lab_target_hat_two <- as.double(unlist(Result_LP[2]))

cat('Elapsed time', elapsed_time/60, 'mins')

# Display of the label transfer results without or with reweighting.
plot_py_3(X_tar_display,convertArray(Lab_target_hat_one),names_pop,convertArray(Lab_target_hat_two),convertArray(Lab_target))



# Transportation plan with or without reweighting
# Without reweighting


n_sub <- 500
source_indices <- sample(0:(I-1), n_sub, replace=FALSE)
u_ce_storage <- rep(0,J)
for (j in 0:(J-1)) u_ce_storage[j+1] <- c_transform(u_last, X_source, X_target, j, beta)

indices <- matrix(0,n_sub,2)
k <- 1
for (it in source_indices){
    indices[k,1] <- it
    cost_x <- cost(X_target, X_source[it])
    arg <- exp((u_last[it]+ u_ce_storage - cost_x)/eps)
    indices[k,2] <- which.max(arg)
    k <- k+1
}

indices <- convertArray(indices)

# with reweighting
u_ce_storage_two <- rep(0,J)
for (j in 0:(J-1)) u_ce_storage_two[j+1] <- c_transform(u_last_two, X_source, X_target, j, beta)

indices_two <- matrix(0,n_sub,2)
k <- 1
for (it in source_indices){
    indices_two[k,1] <- it
    cost_x <- cost(X_target, X_source[it])
    arg <- exp((u_last_two[it]+ u_ce_storage_two - cost_x)/eps)
    indices_two[k,2] <- which.max(arg)
    k <- k+1
}

indices_two <- convertArray(indices_two)

X_target_lag <- copy(X_tar_display)
X_target_lag[,1] <- X_target_lag[,1] + 3500
plot_py_4(X_sou_display, convertArray(Lab_source), names_pop, X_target_lag, n_sub, indices, indices_two)