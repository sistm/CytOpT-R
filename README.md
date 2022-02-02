
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CytOpT

<!-- badges: start -->

[![R-CMD-check](https://github.com/sistm/CytOpt-R/workflows/R-CMD-check/badge.svg)](https://github.com/sistm/CytOpt-R/actions)
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

You can install the development version of CytOpT like so:

``` r
remotes::install_github("sistm/CytOpT-R")
library(CytOpT)
```

## Example

This is a basic example of `CytOpt` usage:

### Data import

``` r
library(CytOpT)
#> Warning in register(): Can't find generic `scale_type` in package ggplot2 to
#> register S3 method.
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
              method='both')
#> Running Desent-ascent optimization...
#> Done (1.408s)
#> Running MinMax optimization...
#> Done (18.869s)
```

``` r
summary(res)
#> Estimation of cell proportions with Descent-Ascent and MinMax swapping  from CytOpt:
#>                     Gold_standard Descent_ascent      MinMax
#> CD8 Effector          0.017004001    0.053840853 0.045459289
#> CD8 Naive             0.128736173    0.086107758 0.105080403
#> CD8 Central Memory    0.048481996    0.037818291 0.038277845
#> CD8 Effector Memory   0.057484114    0.064050408 0.070288205
#> CD8 Activated         0.009090374    0.018054875 0.008915075
#> CD4 Effector          0.002324076    0.007303098 0.005434024
#> CD4 Naive             0.331460344    0.355519302 0.344481072
#> CD4 Central Memory    0.281713344    0.191385560 0.211017717
#> CD4 Effector Memory   0.102082843    0.170991204 0.166204283
#> CD4 Activated         0.021622735    0.014928650 0.004842086
#> 
#> Final Kullback-Leibler divergences:
#>  Descent-Ascent MinMax swapping 
#>               0               0
```

``` r
plot(res)
```

<img src="man/figures/README-plot(res)-1.png" width="100%" />

``` r
Bland_Altman(res$proportions)
```

<img src="man/figures/README-plot(res)-2.png" width="100%" />
