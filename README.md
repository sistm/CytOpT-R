
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `CytOpT` <a><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/sistm/CytOpT-R/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/sistm/CytOpT-R/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/sistm/CytOpT-R/branch/main/graph/badge.svg)](https://app.codecov.io/gh/sistm/CytOpT-R?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/CytOpT)](https://CRAN.R-project.org/package=CytOpT)
<!-- badges: end -->

`CytOpT` uses regularized optimal transport to directly estimate the
different cell population proportions from a biological sample
characterized with flow cytometry measurements.

## Overview

`CytOpT` is an `R` package that provides a new algorithm relying
regularized optimal transport to directly estimate the different cell
population proportions from a biological sample characterized with flow
cytometry measurements. Algorithm is based on the regularized
Wasserstein metric to compare cytometry measurements from different
samples, thus accounting for possible mis-alignment of a given cell
population across sample (due to technical variability from the
technology of measurements).

The main function of the package is `CytOpT()`.

The methods implemented in this package are detailed in the following
article:

> Paul Freulon, Jérémie Bigot, Boris P. Hejblum. CytOpT: Optimal
> Transport with Domain Adaptation for Interpreting Flow Cytometry data
> <https://arxiv.org/abs/2006.09003>

## Installation

You can install and load `CytOpT` into `R` from
[`CRAN`](https://CRAN.R-project.org/package=CytOpT) with the following
commands:

``` r
install.packages("CytOpT")
library(CytOpT)
```

Alternatively, you can install the development version of CytOpT like
so:

``` r
remotes::install_github("sistm/CytOpT-R")
library(CytOpT)
```

## Example

This is a basic example of `CytOpt` usage:

### Data import

``` r
library(CytOpT)
# Load source Data
data("HIPC_Stanford")
```

``` r
# Define the true proportions in the target data set
gold_standard_manual_prop <- c(table(HIPC_Stanford_1369_1A_labels)/length(HIPC_Stanford_1369_1A_labels))
```

### Proportion estimations using *optimal transport* and *minmax swapping* procedures

``` r
# Run CytOpt and compare the two optimization methods
res <- CytOpT(X_s = HIPC_Stanford_1228_1A, X_t = HIPC_Stanford_1369_1A, 
              Lab_source = HIPC_Stanford_1228_1A_labels,
              theta_true = gold_standard_manual_prop,
              eps = 0.0001, lbd = 0.0001, n_iter = 10000, n_stoc=10,
              step_grad = 10, step = 5, power = 0.99, 
              method='both', monitoring=TRUE)
#> Converting `X_s` from data.frame to matrix type
#> Converting `X_t` from data.frame to matrix type
#> Running Descent-ascent optimization...
#> Done in 34.8 secs
#> Running MinMax optimization...
#> Done in 9 secs
```

``` r
summary(res)
#> Estimation of cell proportions with Descent-Ascent and MinMax swapping from CytOpt:
#>                     Gold_standard Descent_ascent      MinMax
#> CD8 Effector          0.017004001    0.054036845 0.041607931
#> CD8 Naive             0.128736173    0.090298071 0.101728390
#> CD8 Central Memory    0.048481996    0.037308518 0.033985173
#> CD8 Effector Memory   0.057484114    0.065037680 0.065902469
#> CD8 Activated         0.009090374    0.018299906 0.014798738
#> CD4 Effector          0.002324076    0.007991691 0.007774069
#> CD4 Naive             0.331460344    0.350327762 0.334132167
#> CD4 Central Memory    0.281713344    0.206010781 0.199079907
#> CD4 Effector Memory   0.102082843    0.156372210 0.187550009
#> CD4 Activated         0.021622735    0.014316537 0.013441148
#> 
#> Final Kullback-Leibler divergences:
#>  Descent-Ascent MinMax swapping 
#>      0.06708789      0.06806565 
#> Number of iterations:
#>  Descent-Ascent MinMax swapping 
#>            5000           10000
```

``` r
plot(res)
#> Plotting KL divergence for iterations 10 to 1000 while there were at least 5000 iterations performed for each method.
```

<img src="man/figures/README-summary-plots-1.png" width="100%" />

``` r
Bland_Altman(res$proportions)
```

<img src="man/figures/README-BAplot-1.png" width="100%" />
