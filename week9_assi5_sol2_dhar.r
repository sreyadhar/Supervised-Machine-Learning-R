# # -*- coding: utf-8 -*-
# """Week9 Assi5 Sol2.ipynb
# 
# Automatically generated by Colaboratory.
# 
# Original file is located at
#     https://colab.research.google.com/drive/1xF79pRxcxHrz7b9OtSMQwc1z2gPkMogS
# """
###########################################################################
## Week-9, Homework-5, Sol-2
## Sreya Dhar 
## Created: Nov 04, 2020
## Edited: Nov 16, 2020
###########################################################################

## installing all the libaries in R kernel

# install.packages("corrplot")
# install.packages("forecast")
# install.packages("zoo")
# install.packages("rsample")
# install.packages("leaps")
# install.packages("car")
# install.packages("caret")
# install.packages("ROCR")
# install.packages("PerformanceAnalytics")
# install.packages("funModeling")
# install.packages("hrbrthemes")
# install.packages("ggthemes")
# install.packages("GGally")
# install.packages("glmnet")
# install.packages("ISLR")
# install.packages("kableExtra")
# install.packages("broom")
# install.packages("knitr")
# install.packages("psych")
# install.packages("aod")
# install.packages("epiDisplay")
# install.packages("e1071")
# install.packages("class")
# install.packages("bootstrap")
# install.packages("boot")

## importing the libraries in R kernel

library(ggplot2)
library(dplyr)
library(tidyverse)
library(tidyr)
library(corrplot)
library(repr)
library(reshape2)
library(forecast)
library(zoo)
library(rsample)
library(gplots)
library(ROCR)
library(class)
library(readr)
library(leaps)
library(car)
library(PerformanceAnalytics)
library(funModeling)
library(caret)
library(MASS)
library(Hmisc)
library(hrbrthemes)
library(GGally)
library(glmnet)
library(pROC)
library(ISLR)
library(psych)
library(aod)
library(epiDisplay)
library(e1071)
library(ggthemes)
library(kableExtra)
library(broom)
library(knitr)
library(bootstrap)
library(boot)

## set directory ##
setwd("C:/File E/EAS 506 Statistical Mining I/Week 9/Assignment-5")

prostate <- read.csv("prostate.csv", header = TRUE)
# prostate

glimpse(prostate)

data <- prostate %>% mutate_if(is.logical, as.factor)
data_2 <- data %>% mutate_if(is.factor, as.numeric)
data_1 <- data_2[,-c(8,10)]
glimpse(data_1)

head(data_1)

names(data_1)

status(prostate)

options(repr.plot.width=5, repr.plot.height=5, repr.plot.res = 200)
L <- cor(prostate)
corrplot(L, method = "circle",  type = "lower")

status(data_1)

describe(data_1)

profiling_num(data_1)

summary(data_1)

options(repr.plot.width=6, repr.plot.height=6, repr.plot.res = 200)
plot_num(data_1)

options(repr.plot.width=8, repr.plot.height=8, repr.plot.res = 230)

pairs.panels(data_1, main = "Pairs cum panel plot on Prostate dataset", pch = 21, bg = c("blue", "green")[unclass(data$svi)], hist.col="red")

## min-max scaling on boston dataset prior to regression ############################################
max <- apply(data_1 , 2 , max)
min <- apply(data_1, 2 , min)
data_s <- as.data.frame(scale(data_1, center = min, scale = max - min))

################################### Exhaustive Subsets selection, nvmax=1 ##################################

data_exh <- regsubsets(lpsa~., data= data_s,
             nbest = 1,       # only 'one' best model for each number of predictors
             nvmax = NULL,    # NULL for no limit on number of variables
             force.in = NULL, force.out = NULL,
             really.big = TRUE,
             method = "exhaustive")
exh_sum <- summary(data_exh)
names(exh_sum)

as.data.frame(exh_sum$outmat)

exh_sum$rsq

as.data.frame(coef(data_exh ,7))

as.data.frame(coef(data_exh ,5))

as.data.frame(coef(data_exh ,3))

#plot of r2 for different models

options(repr.plot.width=4, repr.plot.height=4, repr.plot.res = 200)
exh_r2 <- as.data.frame(exh_sum$rsq)
names(exh_r2) <- "R2"
plot(x= 1:nrow(exh_r2), y=exh_r2[,'R2'],  xlab = "Number of Variables", ylab = "R^2 for Best Subset selection",type="l") 
points(x= 1:nrow(exh_r2), y=exh_r2[,'R2'], col="red",cex=1,pch=20)
abline(v=which.max(exh_r2[,'R2']), y=max(exh_r2['R2']),  type = "l", col = "blue", lty = 3) 
abline(x=which.max(exh_r2[,'R2']), h=max(exh_r2['R2']),  type = "l", col = "blue", lty = 3)

## Plot AIC, BIC, RSS, Adjusted R2 for ex.model(nbest=100)

options(repr.plot.width=7, repr.plot.height=7, repr.plot.res = 230)
par(mfrow = c(2,2))
plot(exh_sum$cp, xlab = "Number of Variables", ylab = "AIC", type = "l")
points(x= 1:7, y=exh_sum$cp, col="red",cex=1,pch=20)
abline(v=which.min(exh_sum$cp), y=min(exh_sum$cp),  type = "l", col = "blue", lty = 3) 
abline(x=which.min(exh_sum$cp), h=min(exh_sum$cp),  type = "l", col = "blue", lty = 3) 


plot(exh_sum$bic, xlab = "Number of Variables", ylab = "BIC", type = "l")
points(x= 1:7, y=exh_sum$bic, col="red",cex=1,pch=20)
abline(v=which.min(exh_sum$bic), y=min(exh_sum$bic),  type = "l", col = "blue", lty = 3) 
abline(x=which.min(exh_sum$bic), h=min(exh_sum$bic),  type = "l", col = "blue", lty = 3) 

plot(exh_sum$rss, xlab = "Number of Variables", ylab = "RSS", type = "l")
points(x= 1:7, y=exh_sum$rss, col="red",cex=1,pch=20)
abline(v=which.min(exh_sum$rss), y=min(exh_sum$rss),  type = "l", col = "blue", lty = 3) 
abline(x=which.min(exh_sum$rss), h=min(exh_sum$rss),  type = "l", col = "blue", lty = 3) 

plot(exh_sum$adjr2, xlab = "Number of Variables", ylab = "Adjusted R^2", type = "l")
points(x= 1:7, y=exh_sum$adjr2, col="red",cex=1,pch=20)
abline(v=which.max(exh_sum$adjr2), y=max(exh_sum$adjr2),  type = "l", col = "blue", lty = 3) 
abline(x=which.max(exh_sum$adjr2), h=max(exh_sum$adjr2),  type = "l", col = "blue", lty = 3)

#How many variables are needed for the best model fit.

data.frame(
  Adj.R2 = which.max(exh_sum$adjr2),
  AIC = which.min(exh_sum$cp),
  BIC = which.min(exh_sum$bic),
  RSS = which.min(exh_sum$rss)
  )

options(repr.plot.width=8, repr.plot.height=8, repr.plot.res = 200)
par(mfrow = c(2,2))
plot(data_exh, scale = "r2", main = "R^2")
plot(data_exh, scale = "adjr2", main = "Adjusted R^2")
plot(data_exh, scale = "Cp",main = "AIC", ylab= "AIC" )
plot(data_exh, scale = "bic", main = "BIC")

# coefficient output
exh_sum$outmat[7,]
exh_sum$outmat[5,]
exh_sum$outmat[3,]

# variables for best models 
options(repr.plot.width=8, repr.plot.height=4, repr.plot.res = 200)
par(mfrow = c(1,2))
## Adjusted R2
res_adjr <- subsets(data_exh, statistic="adjr2", legend = FALSE, min.size = 1, main = "Adjusted R^2")
## Mallow Cp
res_mcp <- subsets(data_exh, statistic="cp", legend = FALSE, min.size = 1, main = "AIC")
abline(a = 1, b = 1, lty = 2)

res_adjr ## gives the legend in the plots
################### performing CV for cross-checking, k=5 ###################################

set.seed(1234) # set seed for unique sampling 
k <- 5 # no. of folds in cv
cv_folds <- sample(1:k, nrow(data_s), replace = TRUE)
cv_errors <- matrix(NA, k, 7, dimnames = list(NULL, paste(1:7)))

predict.regsubsets <- function(object, newdata, id ,...) { ## from lecture slides
  form <- as.formula(object$call[[2]]) 
  mat <- model.matrix(form, newdata)
  coefi <- coef(object, id = id)
  xvars <- names(coefi)
  mat[, xvars] %*% coefi
  }

  for(j in 1:k) {
  
  # perform backward subset on rows not equal to j
  cv_subset <- regsubsets(lpsa ~ ., data_s[cv_folds != j, ], nvmax = 7, method="exhaustive")
  
  # prediction on test set from cross-validation
  for( i in 1:7) {
    pred_cv <- predict.regsubsets(cv_subset, data_s[cv_folds == j, ], id = i)
    cv_errors[j, i] <- mean((data_s$lpsa[cv_folds == j] - pred_cv)^2)
    }
  }

mean_cv_errors <- colMeans(cv_errors) # mse on test set in CV
se_cv_errors <- apply(cv_errors, 2, sd)/sqrt(k)


## plot of mse on test set with error bars
par(mfrow = c(1,2))
options(repr.plot.width=8, repr.plot.height=4, repr.plot.res = 200)
plot(mean_cv_errors, type = "l", col="black", xlab= "No. of Variables", ylab="MSE error rate in 5 fold CV")
points(mean_cv_errors, col="red",cex=1,pch=20)
abline(v=which.min(mean_cv_errors), y= mean_cv_errors, type = "d", col="black", lty=2, lwd= 1)
abline(h=min(mean_cv_errors), y= which.min(mean_cv_errors), type = "d", col="black", lty=2, lwd= 1)
errbar(1:7, mean_cv_errors, mean_cv_errors+se_cv_errors, mean_cv_errors-se_cv_errors, type="l", xlab= "No. of Variables",ylab="Error bars from 5 fold CV" )
points(mean_cv_errors, col="red",cex=1,pch=20)

cv_sum<-summary(cv_subset) ## summary of CV

#How many variables are needed for the best model fit.
data.frame(
  Adj.R2 = which.max(cv_sum$adjr2),
  AIC = which.min(cv_sum$cp),
  BIC = which.min(cv_sum$bic),
  RSS = which.min(cv_sum$rss)
  )

################### performing CV for cross-checking, k=10 ###################################

set.seed(1234) # set seed for unique sampling 
k <- 10 # no. of folds in cv
cv_folds <- sample(1:k, nrow(data_s), replace = TRUE)
cv_errors <- matrix(NA, k, 7, dimnames = list(NULL, paste(1:7)))

predict.regsubsets <- function(object, newdata, id ,...) { ## from lecture slides
  form <- as.formula(object$call[[2]]) 
  mat <- model.matrix(form, newdata)
  coefi <- coef(object, id = id)
  xvars <- names(coefi)
  mat[, xvars] %*% coefi
  }

  for(j in 1:k) {
  
  # perform backward subset on rows not equal to j
  cv_subset <- regsubsets(lpsa ~ ., data_s[cv_folds != j, ], nvmax = 9, method="exhaustive")
  
  # prediction on test set from cross-validation
  for( i in 1:7) {
    pred_cv <- predict.regsubsets(cv_subset, data_s[cv_folds == j, ], id = i)
    cv_errors[j, i] <- mean((data_s$lpsa[cv_folds == j] - pred_cv)^2)
    }
  }

mean_cv_errors <- colMeans(cv_errors) # mse on test set in CV
se_cv_errors <- apply(cv_errors, 2, sd)/sqrt(k)


## plot of mse on test set with error bars
par(mfrow = c(1,2))
options(repr.plot.width=8, repr.plot.height=4, repr.plot.res = 200)
plot(mean_cv_errors, type = "l", col="black", xlab= "No. of Variables", ylab="MSE error rate in 10 folds CV")
points(mean_cv_errors, col="red",cex=1,pch=20)
abline(v=which.min(mean_cv_errors), y= mean_cv_errors, type = "d", col="black", lty=2, lwd= 1)
abline(h=min(mean_cv_errors), y= which.min(mean_cv_errors), type = "d", col="black", lty=2, lwd= 1)
errbar(1:7, mean_cv_errors, mean_cv_errors+se_cv_errors, mean_cv_errors-se_cv_errors, type="l", xlab= "No. of Variables",ylab="Error bars from 10 folds CV")
points(mean_cv_errors, col="red",cex=1,pch=20)

cv_sum <-summary(cv_subset) ## summary of CV
#How many variables are needed for the best model fit.
data.frame(
  Adj.R2 = which.max(cv_sum$adjr2),
  AIC = which.min(cv_sum$cp),
  BIC = which.min(cv_sum$bic),
  RSS = which.min(cv_sum$rss)
  )

### bootstrapping :: 0.632 error for best subset selection #####

select = exh_sum$outmat

beta_fit <- function(X,Y){
	lsfit(X,Y)	
}

beta_predict <- function(fit, X){
	cbind(1,X)%*%fit$coef
}

sqrderror <- function(Y,Yhat){
	(Y-Yhat)^2
}

error_store <- c()
for (i in 1:7){
	# Pull out the model
	temp_data <- which(select[i,] == "*")
	
	boot_err <- bootpred(data_s[,temp_data], data_s$lpsa, nboot = 50, theta.fit = beta_fit, theta.predict = beta_predict, err.meas = sqrderror) 
	error_store <- c(error_store, boot_err[[3]])
	}

options(repr.plot.width=4, repr.plot.height=4, repr.plot.res = 200)
plot(1:7, error_store, xlab= "No. of Variables", ylab="Bootstrap 0.632 prediction error", type= "l")
points(error_store, col="red",cex=1,pch=20)

# Practice, WLOG lets look at a single model of best size = 3,5

temp_3 <- which(select[3,] == "*") # best 3 variable model
temp_5 <- which(select[5,] == "*") # best 3 variable model
res_3 <- bootpred(data_s[,temp_3], data_s$lpsa, nboot = 500, theta.fit = beta_fit, theta.predict = beta_predict, err.meas = sqrderror) 
res_5 <- bootpred(data_s[,temp_5], data_s$lpsa, nboot = 500, theta.fit = beta_fit, theta.predict = beta_predict, err.meas = sqrderror) 
res_3[[3]]
res_5[[3]]

#### bootstrapping :: 0.632 error CV model (k=5, 10) on best subset size =3 #####

library(bootstrap)
theta.fit <- function(x,y){lsfit(x,y)}
theta.predict <- function(fit,x){cbind(1,x)%*%fit$coef}
sq.err <- function(y,yhat) {(y-yhat)^2}

## for best subset size = 3
y =data_s[,8]
x = data_s[,c(1,2,5)]

cv5Errs = crossval(x,y, theta.fit, theta.predict,ngroup=5)
cv5_mean = mean((y-cv5Errs$cv.fit)^2)
# cv5_mean
boot_cv5 = bootpred(x,y,nboot=200, theta.fit, theta.predict,err.meas=sq.err)
boot_opt5 = boot_cv5[[1]] + boot_cv5[[2]] # boot + opt estimate
boot_opt5

boot5_632 = boot_cv5[[3]] # bootstrap 632 estimate
boot5_632


cv10Errs = crossval(x,y, theta.fit, theta.predict,ngroup=10)
cv10_mean = mean((y-cv10Errs$cv.fit)^2)
# cv10_mean
boot_cv10 = bootpred(x,y,nboot=200, theta.fit, theta.predict,err.meas=sq.err)
boot_opt10 = boot_cv10[[1]] + boot_cv10[[2]] # boot + opt estimate
boot_opt10

boot10_632 = boot_cv10[[3]] # bootstrap 632 estimate
boot10_632

#### bootstrapping :: 0.632 error CV model (k=5, 10) on best subset size =5 #####
y =data_s[,8]
x = data_s[,c(1:5)]

cv5Errs = crossval(x,y, theta.fit, theta.predict,ngroup=5)
cv5_mean = mean((y-cv5Errs$cv.fit)^2)
# cv5_mean
boot_cv5 = bootpred(x,y,nboot=200, theta.fit, theta.predict,err.meas=sq.err)
boot_opt5 = boot_cv5[[1]] + boot_cv5[[2]] # boot + opt estimate
boot_opt5

boot5_632 = boot_cv5[[3]] # bootstrap 632 estimate
boot5_632


cv10Errs = crossval(x,y, theta.fit, theta.predict,ngroup=10)
cv10_mean = mean((y-cv10Errs$cv.fit)^2)
# cv10_mean
boot_cv10 = bootpred(x,y,nboot=200, theta.fit, theta.predict,err.meas=sq.err)
boot_opt10 = boot_cv10[[1]] + boot_cv10[[2]] # boot + opt estimate
boot_opt10

boot10_632 = boot_cv10[[3]] # bootstrap 632 estimate
boot10_632

## end ##