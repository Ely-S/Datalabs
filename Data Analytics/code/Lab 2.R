hdata <- read.csv("~/data/data/dataset_multipleRegression.csv")
attach(hdata)
model1 = lm(ROLL~UNEM+HGRAD)
predict(model1, data.frame(HGRAD = 100000, UNEM=9.0), se.fit = TRUE)
model2 = lm(ROLL~UNEM+HGRAD+INC)
predict(model2, data.frame(HGRAD = 100000, UNEM=9.0, INC=30000), se.fit = TRUE)
summary(model1)
summary(model2)

# Abalone Data
library("class")

abalone <- read.csv("~/data/data/abalone.csv", quote="")

abalone$Sex = as.numeric(abalone$Sex)

set.seed(43)

d<-dim(abalone)[1]
#90% to train
sampling.rate=0.9
#remainder to test
num.test.set.labels=d*(1.-sampling.rate)
#construct a random set of training indices (training)
training <-sample(1:d,sampling.rate*d, replace=FALSE)
#build the training set (train)
train<-abalone[training, -c(9)]
#construct the remaining test indices (testing)
testing<-setdiff(1:d, training)
#define the test set
test<-abalone[testing, -c(9)]
#construct labels for another variable (Gender) in the training set
cl<-abalone$Rings[training]
cls <- knn(train, test, cl, prob=TRUE, k=3)
  
ccls <- knn.cv(abalone[-c(9)], cl<-abalone$Rings)


data(“iris”)

numericaldata <- iris[-c(5)]

clus <- kmeans(numericaldata, 3, iter.max = 1000)
table(iris[,5], clus$cluster)
