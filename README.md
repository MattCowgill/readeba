
<!-- README.md is generated from README.Rmd. Please edit that file -->

# readeba

<!-- badges: start -->

[![R-CMD-check](https://github.com/MattCowgill/readeba/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/MattCowgill/readeba/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of `{readeba}` is to download and import [data on enterprise
agreement settlements in Australia from the Fair Work
Commission](https://www.fwc.gov.au/agreements-awards/enterprise-agreements/about-enterprise-agreements/statistical-reports-enterprise?idU=1).

## Installation

You can install the development version of readeba from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("MattCowgill/readeba")
```

## Examples!

The package has one function: `read_fwc()`, which downloads and imports
a tidy tibble containing the FWC EBA data

``` r
library(readeba)
options(tidyverse.quiet = TRUE)
library(tidyverse)

fwc <- read_fwc()

fwc 
#> # A tibble: 786 × 4
#>    date       indicator               union  value
#>    <date>     <chr>                   <chr>  <dbl>
#>  1 2022-07-15 Employees covered (No.) Total  19132
#>  2 2022-07-29 Employees covered (No.) Total  20038
#>  3 2022-08-12 Employees covered (No.) Total  15331
#>  4 2022-08-26 Employees covered (No.) Total  10065
#>  5 2022-09-09 Employees covered (No.) Total  26461
#>  6 2022-09-23 Employees covered (No.) Total  16551
#>  7 2022-10-07 Employees covered (No.) Total  21586
#>  8 2022-10-21 Employees covered (No.) Total  16503
#>  9 2022-11-04 Employees covered (No.) Total 100074
#> 10 2022-11-18 Employees covered (No.) Total  24113
#> # ℹ 776 more rows
```

It’s straightforward to visualise:

``` r
fwc |> 
  filter(union == "Total",
         indicator == "AAWI (%)") |> 
  ggplot(aes(x = date, y = value)) +
  geom_line() +
  theme_minimal()
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

Add a couple of different trendlines:

``` r
fwc |> 
  filter(union == "Total") |> 
  pivot_wider(names_from = indicator) |> 
  ggplot(aes(x = date, 
             y = `AAWI (%)`,
             weight = `Employees covered (No.)` )) +
  geom_point(aes(size = `Employees covered (No.)`)) +
  geom_smooth(method = "loess",
              formula = y ~ x,
              se = FALSE) +
  geom_line(aes(y = slider::slide2_dbl(.x = `AAWI (%)`,
                                       .y = `Employees covered (No.)`,
                                       .f = \(x, y) weighted.mean(x, y),
                                       # 6 fortnight weighted moving average
                                       .before = 6L,
                                       .complete = TRUE)),
            na.rm = TRUE,
            colour = "red") +
  scale_x_date(breaks = seq(max(fwc$date), 
                            min(fwc$date), 
                            by = "-6 months"),
               date_labels = "%d %b\n%Y",
               expand = expansion(c(0.025, 0.075))) +
  scale_y_continuous(labels = \(x) scales::percent(x / 100, 0.1),
                     breaks = seq(0, 100, 0.5),
                     limits = \(x) c(min(0, x[1]), x[2]),
                     expand = expansion(c(0, 0.05))) +
  theme_minimal() +
  theme(axis.title.x = element_blank(),
        legend.position = "bottom",
        legend.direction = "horizontal")
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />
