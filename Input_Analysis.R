rm(list=ls())
library(glmnet)
library(e1071)
library(ggplot2)
library(reshape2)

FF5 <- read.csv('Data.csv')
years <- c(0.5,1,2,5,10)
forecast = data.frame()
port_visual = data.frame()
for(yr in years){
  month = yr*12
  df2<-FF5[(319-month):706,]
  n=nrow(df2)
  pred<-matrix(NA,nrow = n,ncol = 10)
  for(u in 1:10){
    for(i in (month+1):n){
      dta<-df2[(i-month):i,c(2:6,7+u)]
      X<-as.matrix(dta[1:month,1:5])
      Y<-as.matrix(dta[1:month,6])
      x<-as.matrix(dta[month+1,1:5])
      #SVR
      Svr<-svm(X,Y,kernel="linear",cost=0.5)
      y_svr <- as.numeric(predict(Svr,x))
      #RR
      Rr<-glmnet(X,Y,alpha = 0,standardize = 1,lambda = 0.1)
      y_rr<-as.numeric(predict(Rr,s=0,newx=x))
      #LR
      Lr<-glmnet(X,Y,alpha = 1,standardize = 1,lambda = 0.1)
      y_lr<-as.numeric(predict(Lr,s=0,newx=x))
      
      pred[i,u] <- mean(c(y_svr,y_rr,y_lr)) 
    }
  }
  
  # Save to a dataframe
  predict <- na.omit(pred)
  year <- c(rep(yr,length(predict)))
  real<- as.matrix(df2[(month+1):n,8:17])
  port_test <- abs(predict-real)
  port_mean <- colMeans(port_test)
  port_visual <- rbind(port_visual,port_mean)
  test <- c(as.vector(port_test))
  forecast_new <- data.frame(year,test)
  forecast <- rbind(forecast,forecast_new)
}
ftest <- aov(test~factor(year),data = forecast)
summary(ftest)
tukey <- TukeyHSD(ftest)
tukeyround <- round(tukey$`factor(year)`, digits = 4)
write.csv(tukeyround,'Tukey.csv')

#Visualize the results
colnames(port_visual) <- colnames(FF5)[8:17]
port_visual['Length'] <- c('6 months', '1 year', '2 years', '5 years', '10 years')
port_visualize <- melt(port_visual, id.vars=c("Length"))
colnames(port_visualize)[2:3] <- c('Portfolio', 'MAE')
ggplot(port_visualize, aes(x = Portfolio, y = MAE)) +
    geom_point(aes(shape = Length))
ggsave("scatter.png",height = 10,width = 20,units = "cm")
