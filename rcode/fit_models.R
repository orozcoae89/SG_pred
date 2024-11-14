####################
# library required #
####################
library(forecast)

#######################
# pre-processing data #
#######################

generate <- FALSE

if (generate) {
  temp <- list.files(pattern = "\\.csv$")
  data_sets <- lapply(temp, read.csv)
  data_sets <- lapply(data_sets, setNames, nm = c("corr", "volt"))
  changetype <- function(x) {
    x[, 1] <- as.numeric(x[, 1])
    x[, 2] <- as.numeric(x[, 2])
    return(x)
  }
  data_sets <- lapply(data_sets, changetype)
  save(list = c("data_sets"), file = "data_sets.Rdata")
} else {
  load("data_sets.Rdata")
}

i <- 1 # choose in list below 

# [1] "dataset_cafetera_microondas.csv" [2]"dataset_cafetera.csv"
# [3] "dataset_calentador_cafetera.csv" [4] "dataset_calentador.csv"
# [5] "dataset_microondas.csv"          [6] "dataset_taladro_1.csv"          
# [7] "dataset_taladro_2.csv"           [8] "dataset_taladro_calentador.csv"
# [9] "dataset_taladro_microondas.csv" 

######################
# fit model function #
######################

fit.models <- function(ddata) {
  ddata <- ddata / 100
  ddata_ts <- ts(ddata$corr, start = 0, frequency = 8000)
  cat("****Estimating for corr****\n")
  cpu_time <- system.time({
    ff <- auto.arima(ddata_ts, stepwise = FALSE, approximation = FALSE,
                     parallel = TRUE, num.cores = 32)
  })
  return(list(corr_ts = ddata_ts, corr_model = ff, cpu_time = cpu_time))
}

sim <- fit.models(ddata = data_sets[[i]])
save(list = c("sim"), file = paste("sim_device_",i,".Rdata", sep = ""))
