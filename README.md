
<!-- README.md is generated from README.Rmd. Please edit that file -->

# readeba

<!-- badges: start -->

[![R-CMD-check](https://github.com/MattCowgill/readeba/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/MattCowgill/readeba/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of `{readeba}` is to download and import data on enterprise
agreement settlements in Australia.

## Installation

You can install the development version of readeba from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("MattCowgill/readeba")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(readeba)

read_fwc()
#> # A tibble: 749 × 4
#>    date       indicator                                        union       value
#>    <date>     <chr>                                            <chr>       <dbl>
#>  1 2022-07-15 Number of agreement approval applications lodged Applicatio…    20
#>  2 2022-07-29 Number of agreement approval applications lodged Applicatio…    26
#>  3 2022-08-12 Number of agreement approval applications lodged Applicatio…    38
#>  4 2022-08-26 Number of agreement approval applications lodged Applicatio…    31
#>  5 2022-09-09 Number of agreement approval applications lodged Applicatio…    41
#>  6 2022-09-23 Number of agreement approval applications lodged Applicatio…    15
#>  7 2022-10-07 Number of agreement approval applications lodged Applicatio…    41
#>  8 2022-10-21 Number of agreement approval applications lodged Applicatio…    36
#>  9 2022-11-04 Number of agreement approval applications lodged Applicatio…    30
#> 10 2022-11-18 Number of agreement approval applications lodged Applicatio…    29
#> # … with 739 more rows
```
