x1=read.csv(file.choose(),head=FALSE) 
x2=read.csv(file.choose(),head=FALSE)
xx1=rbind(x1,x2)                
xx=scale(xx1,center=T,scale=T)
y1<- matrix(1,nrow=878,ncol=1)
y2<- matrix(0,nrow=2405,ncol=1)
yy=rbind(y1,y2)
mydata<-data.frame(yy,xx)
library(DMwR)
mydata$yy<-factor(mydata$yy)
newData <- SMOTE(yy ~ ., mydata)
library(randomForest)
x3=read.csv(file.choose(),head=FALSE) 
x4=read.csv(file.choose(),head=FALSE)
xx2=rbind(x3,x4)                
xxx=scale(xx2,center=T,scale=T)
y11<- matrix(1,nrow=920,ncol=1)
y22<- matrix(0,nrow=920,ncol=1)
yyy=rbind(y11,y22)
mydata1<-data.frame(yyy,xxx)
mydata1$yyy<-factor(mydata1$yyy)

fold_test <- mydata1               
fold_train <- newData              
m<-randomForest(fold_train[,-1],fold_train$yy,ntree=500)
p<-predict(m,fold_test[,-1],type="response")
p1<-predict(m,fold_test[,-1],type="prob")
duibi<-data.frame(prob=p,obs=fold_test$yyy)
library(caret)
jieguo<-confusionMatrix(duibi$prob,duibi$obs,positive = "1")
print(jieguo)
average<-jieguo$overall[1]
average1<-jieguo$byClass[1]
average2<-jieguo$byClass[2]

p11=data.frame(p1)
roc_results=data.frame(fold_test$yyy,p11)
library(ROCR)
pred<-prediction(predictions = roc_results$X1,labels = roc_results$fold_test.yyy)
perf<-performance(pred,measure = "tpr",x.measure = "fpr")
plot(perf,main="test",col="blue",lwd=3)
abline(a=0,b=1,lty=2)
perf.auc<-performance(pred,measure = "auc")
str(perf.auc)
unlist(perf.auc@y.values)
average3<-as.numeric(perf.auc@y.values)


print(average)
print(average1)
print(average2)
print(average3)

write.csv(A,file="probability_AMP.csv")
write.csv(B,file="label_AMP.csv")