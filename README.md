
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bossR <img src="sticker.png" width = "150" align = "right" />

<!-- badges: start -->
<!-- badges: end -->

The `bossR` package segments and tracks the cells from the BOSS method.
Access to the full papers can be found
[here](https://www.biorxiv.org/content/10.1101/2022.06.17.495689v1).
Additionally, it allows for visualization of the segmented/tracked cells
overlayed in original image.

## Installation

You can install the development version of bossR like so:

``` r
devtools::install_github('calebae/bossR')
```

## Vignette

For a full implementation of the methods with output please see our
[vignette]().

``` r
library(bossR)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.
