
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
X_source <- read.csv('tests/ressources/W2_1_values.csv')
Lab_source <- read.csv('tests/ressources/W2_1_clust.csv')[, 2]

# Target Data
X_target <- read.csv('tests/ressources/W2_7_values.csv')
Lab_target <- read.csv('tests/ressources/W2_7_clust.csv')[, 2]

```
### Thresholding of the negative values
```
# true proportions in the target data set X_source
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
