library(missMethods)
library(mice)
library(datasets)
library(Metrics)

###SET UP DATA
datahouse <- house
datahouse

set.seed(x)
dfmissing <- delete_MCAR(datahouse, .50 ,6)
dfmissing


###MRNM
getImpute <- function(df, x){
  R = is.na(df[x])
  initialRs = R
  colnames(initialRs) = ('Ri')
  initialRs
  initialRs[R=='TRUE'] <- 0
  initialRs[R=='FALSE'] <- 1
  
  imputed_Data_norm <- mice(df, m=10, maxit = 100, method = 'norm', seed = 500)
  imputed_Data_pmm <- mice(df, m=10, maxit = 100, method = 'pmm', seed = 500)
  
  dfnorm = complete(imputed_Data_norm)[x]
  names(dfnorm) = ('pi_hat_norm')
  dfnorm
  
  sigmamN = sd(as.numeric(unlist(dfnorm$pi_hat)))
  phatmeanN = mean(as.numeric(unlist(dfnorm$pi_hat)))
  dfnorm$Si = (dfnorm$pi_hat - phatmeanN) / sigmamN
  
  dfpmm = complete(imputed_Data_pmm)[x]
  names(dfpmm) = ('pi_hat_pmm')
  dfpmm
  
  sigmamP = sd(as.numeric(unlist(dfpmm$pi_hat_pmm)))
  phatmeanP = mean(as.numeric(unlist(dfpmm$pi_hat_pmm)))
  dfpmm$Sj = (dfpmm$pi_hat_pmm - phatmeanP) / sigmamP
  
  standards = cbind(dfnorm, dfpmm)
  standards$Ri = initialRs
  standards
  
  return(standards)
}

originalsample <- getImpute(dfmissing, 7)
X <- split(originalsample, originalsample$Ri)
originalsamplemissings <- X$'0'


imputeData <- function(df, missings, x){
  
  resample <- dfmissing[sample(4308, 4308, replace=T),  ]
  imputation <- getImpute(resample, x)
  
  imputationsscores <- imputation[c(2,4)]
  originalScores <- missings[c(2,4)]
  
  distances <- as.data.frame(as.matrix(pdist(imputationsscores, originalScores)))
  
  predicted <- c()
  for (column in 1:ncol(distances)){
    sorted <- order(distances[column][,1])
    neighborhood <- head(sorted, 3)
    selection <- sample(neighborhood, 1)
    selectionrow <- imputation[selection, ]
    Y_hat_norm <- as.numeric(selectionrow['pi_hat_norm'])
    Y_hat_pmm <- as.numeric(selectionrow['pi_hat_pmm'])
    Y_hat <- mean(Y_hat_norm, Y_hat_pmm)
    predicted <- append(predicted, Y_hat)
  }
  
  
  return(predicted)
}

resulting = c()
for (i in 1:10){
  x = imputeData(dfmissing, originalsamplemissings, 7)
  resulting = cbind(resulting, x)
}

pooledPred = rowMeans(as.data.frame(resulting))
pooledPred

dfmissing2 <- dfmissing
dfmissing2$original = datahouse[7]

dfmissing3 <- dfmissing2[rowSums(is.na(dfmissing2)) > 0,]

rmse(as.numeric(unlist(as.vector(dfmissing3[8]))), pooledPred)


#MICE
imputed_Data_norm <- mice(dfmissing, m=10, maxit = 5, method = 'norm', seed = 500)

dfmissing4 <- dfmissing2
dfmissing4$mice <- complete(imputed_Data_norm)[7]
dfmissing4 <- dfmissing4[rowSums(is.na(dfmissing4)) > 0,]
rmse(as.numeric(unlist(as.vector(dfmissing4[8]))), as.numeric(unlist(as.vector(dfmissing4[9]))))

#Amelia
amelia_fit <- amelia(dfmissing, m=5, parallel = "multicore")
amelia_fit$imputations[[5]][7]

dfmissing7 <- dfmissing2
dfmissing7$original <- datahouse[7]
dfmissing7$miss <- amelia_fit$imputations[[5]][7]

dfmissing8 <- dfmissing7[rowSums(is.na(dfmissing7)) > 0,]
dfmissing8

rmse(as.numeric(unlist(as.vector(dfmissing8[8]))), as.numeric(unlist(as.vector(dfmissing8[9]))))

#Mean
dfmean <- dfmissing
dfmean$price[is.na(dfmean$price)]<-mean(dfmean$price,na.rm=TRUE)
dfmean

dfmissing9 <- dfmissing2
dfmissing9$original <- datahouse[7]
dfmissing9$miss <- dfmean[7]

dfmissing10 <- dfmissing9[rowSums(is.na(dfmissing9)) > 0,]
dfmissing10

rmse(as.numeric(unlist(as.vector(dfmissing10[8]))), as.numeric(unlist(as.vector(dfmissing10[9]))))
