#!/usr/bin/env Rscript
library(dplyr)
library(readr)
library(clustermq)
library(fst)
library(here)
library(hector.permafrost.emit)

logdir <- here("logs")
dir.create(logdir, recursive = TRUE, showWarnings = FALSE)
outdir <- here("analysis", "data", "output")
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
datadir <- here("analysis", "data", "derived_data")
dir.create(datadir, recursive = TRUE, showWarnings = FALSE)

set.seed(8675309)
ndraws <- 5000

npp_alpha <- c(f_nppv = 0.35, f_nppd = 0.60, f_npps = 0.05)
npp_draws <- rdirichlet(ndraws, npp_alpha)[, 1:2]

draws <- tibble(
  beta = runif(ndraws, 0, 1),
  q10_rh = runif(ndraws, 0, 10),
  f_litterd = rbeta(ndraws, 0.98 * 4, 0.02 * 4)
) %>%
  bind_cols(as_tibble(npp_draws))

write_csv(draws, file.path(datadir, "parameter-draws.csv"))

hector_fun <- function(...) {
  library(hector.permafrost.emit)
  tryCatch(
    hector_with_params(...),
    error = function(e) {
      message("Run failed, returning NULL. ",
              "Hit the following error:\n",
              conditionMessage(e))
      return(NULL)
    }
  )
}

result <- Q_rows(draws, hector_fun, n_jobs = 50,
                 template = list(
                   account = "epa-ccd",
                   log_file = "/people/shik544/.cmq_logs/global-%a.log" #nolint
                 ))
result_df <- result %>%
  bind_rows() %>%
  as_tibble()

write_fst(result_df, file.path(outdir, "global-sims.fst"))
