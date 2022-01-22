
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CytOpT

<!-- badges: start -->

[![R-CMD-check](https://github.com/sistm/CytOpt-R/workflows/R-CMD-check/badge.svg)](https://github.com/sistm/CytOpt-R/actions)
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
# Load source Data
X_source <- read.csv('tests/ressources/W2_1_values.csv')
Lab_source <- read.csv('tests/ressources/W2_1_clust.csv')[, 2]

# Load target Data
X_target <- read.csv('tests/ressources/W2_7_values.csv')
Lab_target <- read.csv('tests/ressources/W2_7_clust.csv')[, 2]
```

``` r
# Define the true proportions in the target data set X_source
theta_true <- rep(0,10)
for (k in 1:10){
  theta_true[k] <- sum(Lab_target == k) / length(Lab_target)
}
```

### Proportion estimations using *optimal transport* and *minmax swapping* procedures

``` r
# Run CytOpt and compare the two optimization methods
res <- CytOpT(X_source, X_target, Lab_source, 
              theta_true=theta_true, method='both')
#> cell_type is NULL and labels are imputed as an integer sequence
#> Running Desent-ascent optimization...
#> Done (27.94s)
#> Running MinMax optimization...
#> Done (11.764s)
```

``` r
summary(res)
#> Estimation of cytometry proportion with Descent-Ascent and MinMax swapping algorithms from CytOpt:
#>    Gold_standard Descent_ascent       MinMax
#> 1    0.017004001    0.146001308 0.1418916363
#> 2    0.128736173    0.057437039 0.0630508365
#> 3    0.048481996    0.034579209 0.0348050407
#> 4    0.057484114    0.038897336 0.0325485857
#> 5    0.009090374    0.012490954 0.0004721661
#> 6    0.002324076    0.009295304 0.0112336132
#> 7    0.331460344    0.330020666 0.3275934412
#> 8    0.281713344    0.232886944 0.2515730151
#> 9    0.102082843    0.117268733 0.1124620403
#> 10   0.021622735    0.021122507 0.0243696250
#> 
#> Final Kullback-Leibler divergences:
#>  Descent-Ascent MinMax swapping 
#>       0.2275526       0.2237798
```

``` r
plot(res)
```

<img src="man/figures/README-plot(res)-1.png" width="100%" />

``` r
Bland_Atlman(res$proportions)
```

<img src="man/figures/README-plot(res)-2.png" width="100%" />
