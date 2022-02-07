
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `CytOpT` <a><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/sistm/CytOpt-R/workflows/R-CMD-check/badge.svg)](https://github.com/sistm/CytOpt-R/actions)
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
#> Running Descent-ascent optimization...
#> Done in 1.2 mins
#> Running MinMax optimization...
#> Done in 12.6 secs
```

``` r
summary(res)
#> Estimation of cell proportions with Descent-Ascent and MinMax swapping from CytOpt:
#>                     Gold_standard Descent_ascent      MinMax
#> CD8 Effector          0.017004001    0.053373073 0.049165803
#> CD8 Naive             0.128736173    0.090347127 0.101853869
#> CD8 Central Memory    0.048481996    0.037840538 0.035433512
#> CD8 Effector Memory   0.057484114    0.066705538 0.073213153
#> CD8 Activated         0.009090374    0.017815159 0.006404042
#> CD4 Effector          0.002324076    0.007442363 0.013276764
#> CD4 Naive             0.331460344    0.345556315 0.334588823
#> CD4 Central Memory    0.281713344    0.204513209 0.206829823
#> CD4 Effector Memory   0.102082843    0.161762256 0.151074689
#> CD4 Activated         0.021622735    0.014644421 0.028159522
#> 
#> Final Kullback-Leibler divergences:
#>  Descent-Ascent MinMax swapping 
#>      0.06790844      0.06172906
```

``` r
plot(res)
```

<img src="man/figures/README-summary-plots-1.png" width="100%" />

``` r
Bland_Altman(res$proportions)
```

<img src="man/figures/README-BAplot-1.png" width="100%" />
