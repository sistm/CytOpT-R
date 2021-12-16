
# CytOpT


The **CytOpT** package includes :

## Overview
The methods implemented in this package are detailed in the following
article:

> Paul Freulon, Jérémie Bigot, Boris P. Hejblum.
> CytOpT: Optimal Transport with Domain Adaptation for Interpreting Flow Cytometry data
> https://arxiv.org/abs/2006.09003

### Getting started

#### Installation

Install the **CytOpT** package from CRAN as follows:


Install from CRAN

```r
install.packages("CytOpT")
```

To install CytOpT, you can download the development version on GitHub.


## Example
### Data import
```
# Source Data
Stanford1A_values <- read.csv('tests/ressources/W2_1_values.csv')
Stanford1A_clust <- read.csv('tests/ressources/W2_1_clust.csv')[, 2]

# Target Data
Stanford3A_values <- read.csv('tests/ressources/W2_7_values.csv')
Stanford3A_clust <- read.csv('tests/ressources/W2_7_clust.csv')[, 2]

X_source <- convertArray(Stanford1A_values)
X_target <- convertArray(Stanford3A_values)
```
### Thresholding of the negative values
```
X_source <- X_source * (X_source > 0)
X_target <- X_target * (X_target > 0)

X_source <- Scale(X_source)
X_target <- Scale(X_target)

Lab_source <- convertArray(Stanford1A_clust)
Lab_target <- convertArray(Stanford3A_clust)

theta_true <- rep(0,10)
for (k in 1:10) theta_true[k] <- sum(Lab_target == k)/length(Lab_target)

```

### Classification using optimal transport and Minmax swapping procedure

```
# comparison two methods 
CytOpt(X_source, X_target, Lab_source, theta_true=theta_true, method='comparison_opt')
```

## Urls
https://arxiv.org/abs/2006.09003