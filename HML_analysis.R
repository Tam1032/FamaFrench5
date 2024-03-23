  rm(list=ls())
  library(glmnet)
  library(e1071)


  FF5 <- read.csv('Data.csv')
  month = 60
  print(nrow(FF5))
  df2<-FF5[(319-month):706,]
  n=nrow(df2)
  # SVR
  HML <- c()
  NoHML <- c()
  for(u in 1:10){
    for(i in (month+1):n){
      dta<-df2[(i-month):i,c(2:6,7+u)]
      X1<-as.matrix(dta[1:month,1:5])
      X2<-as.matrix(dta[1:month,c(1,2,4,5)])
      Y<-as.matrix(dta[1:month,6])
      x1<-as.matrix(dta[month+1,1:5])
      x2<-as.matrix(dta[month+1,c(1,2,4,5)])
      y <-dta[month+1,6]
      #SVR
      Svr_1<-svm(X1,Y,kernel="linear",cost=0.5)
      Svr_2<-svm(X2,Y,kernel="linear",cost=0.5)
      svr_HML<-as.numeric(predict(Svr_1,x1))
      svr_NoHML<-as.numeric(predict(Svr_2,x2))
      #RR
      Rr_1<-glmnet(X1,Y,alpha = 0,standardize = 1,lambda = 0.1)
      Rr_2<-glmnet(X2,Y,alpha = 0,standardize = 1,lambda = 0.1)
      rr_HML<-as.numeric(predict(Rr_1,s=0,newx=x1))
      rr_NoHML<-as.numeric(predict(Rr_2,s=0,newx=x2))
      #LR
      Lr_1<-glmnet(X1,Y,alpha = 1,standardize = 1,lambda = 0.1)
      Lr_2<-glmnet(X2,Y,alpha = 1,standardize = 1,lambda = 0.1)
      lr_HML<-as.numeric(predict(Lr_1,s=0,newx=x1))
      lr_NoHML<-as.numeric(predict(Lr_2,s=0,newx=x2))
      #Calculate the mean prediction
      pred_HML <- mean(c(svr_HML,rr_HML,lr_HML))
      pred_NoHML <- mean(c(svr_NoHML,rr_NoHML,lr_HML))
      #Save the absolute error
      HML <- append(HML,abs(pred_HML - y))
      NoHML <- append(NoHML,abs(pred_NoHML - y))
    }
  }
 t_test <- t.test(HML,NoHML, var.equal = TRUE)
 print(paste('SD_HML: ',sd(HML),' SD_NoHML: ', sd(NoHML)))
  