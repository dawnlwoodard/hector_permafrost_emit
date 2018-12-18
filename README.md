---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->


# Hector permafrost emissions analysis

This repository contains the source code and raw manuscript files for the Hector permafrost emissions paper.

## Installation

You can install the development version of `hector_permafrost_emit` from GitHub with:

```r
# install.packages("devtools")
devtools::install_github("ashiklom/hector_permafrost_emit")
```

## Data description

- `analysis/data/raw_data/schaefer_teb_rpc_(min/max/mean).csv` -- Raw, digitized versions of Figure 5c (Ensemble mean and uncertainty of permafrost C respiration) in [@schaefer_2011_amount]. Original figure is `analysis/data/raw_data/schaefer_teb_timeseries.gif`. These results were digitized using WebPlotDigitizer (https://apps.automeris.io/wpd/), and interpolated to annual resolution (using R `stats::spline` function).
    - [@schaefer_2011_amount] assume only CO2 emissions. So we add this as an extra anthropogenic CO2 flux.
- `analysis/data/raw_data/hope_2016_Mt{CO2/CH4}_{lo/mean/hi}.csv` -- Raw, digitized versions of Figures 1 (permafrost CO2 emissions from SiBCASA) and 2 (same for CH4) from [@hope_2015_economic]. Same digitization and interpolation procedure. Original figures are `analysis/data/raw_data/hope_2016_nclimate_{co2,ch4}.jpg`.
