####################
# library required #
####################
library(forecast)
options(scipen = 999)

########################
# import models fitted #
########################

temp <- list.files(pattern = "\\.Rdata$")
models <- vector("list", 7)

# [1] "dataset_cafetera_microondas.csv" "dataset_cafetera.csv"            "dataset_calentador_cafetera.csv"
# [4] "dataset_calentador.csv"          "dataset_microondas.csv"          "dataset_taladro_1.csv"          
# [7] "dataset_taladro_2.csv"           "dataset_taladro_calentador.csv"  "dataset_taladro_microondas.csv" 

id <- c(2, 4, 5, 6, 1, 8, 9)

for (i in 1:length(id)) {
  load(temp[id[i]])
  models[[i]] <- sim
}

names(models) <- c("Coffee machine", "Heater", "Microwave oven",
                   "Drill", "Coffee machine and microwave oven",
                   "Drill and heater", "Drill and microwave oven")

##################################
# descriptive analysis (Table 1) #
##################################

stat.desc <- function(x){
  data.frame(MIN=min(x$corr_ts), 
             MAX=max(x$corr_ts), 
             MEAN=mean(x$corr_ts),
             MEDIAN=median(x$corr_ts), 
             DESV= sqrt(x$corr_model$sigma2), 
             IntQR=IQR(x$corr_ts))
}

table1 <- do.call(rbind, lapply(models, function(x) stat.desc(x))); table1
write.csv(table1, file = "table1.csv")

###################################
# plotting time series (Figure 1) #
###################################

jpeg(filename = "Figure1.jpeg", width = 3400, height = 5000, res = 600)
xlab <- "Time (s)"
ylab <- "Ampere (A)"
lwd <- 0.3
cex.main <- 1
ii <- c("(A) ","(B) ","(C) ","(D) ","(E) ","(F) ","(G) ")
par(mfrow=c(4,2))
par(mar = c(4, 4, 1.6, 1.6))
for (j in 1:length(models)) {
  plot(models[[j]]$corr_ts, ylab = ylab, xlab = xlab, 
       main=paste(ii[j],names(models)[j],sep = ""), 
       lwd=lwd, cex.main=cex.main)
}
dev.off()

#############################
# Models elements (Table 2) #
#############################

GOF <- function(x){
  data.frame(.n=x[[2]]$nobs,
             AIC=round(x$corr_model$aic, 0),
             BIC=round(x$corr_model$bic, 0),
             RMSE=round(sqrt(mean(x$corr_model$residuals^2)), 4),
             MAE=round(mean(abs(x$corr_model$residuals)), 4),
             MASE=round(accuracy(x$corr_model)[6], 4),
             CPUtime=round(as.numeric(x$cpu_time[3]/60), 0))
}

table2 <- do.call(rbind, lapply(models, GOF))
table2$AIC <- table2$AIC-min(table2$AIC)
table2$BIC <- table2$BIC-min(table2$BIC)
table2
write.csv(table2, file = "table2.csv")
