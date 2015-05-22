library(e1071)
library(kernlab)
library(rpart)
data(Ozone, package="mlbench")
# http://math.furman.edu/~dcs/courses/math47/R/library/mlbench/html/Ozone.html # for field codes
## split data into a train and test set
index <- 1:nrow(Ozone)
testindex <- sample(index, trunc(length(index)/3))
testset <- na.omit(Ozone[testindex,-3])
trainset <- na.omit(Ozone[-testindex,-3])
# Ganna = 1/sigma
svm.model <- svm(V4 ~ ., data = trainset, cost = 1, gamma = 0.1)
svm.pred <- predict(svm.model, testset[,-3])
crossprod(svm.pred - testset[,3]) / length(testindex)

data(Glass, package="mlbench")
index <- 1:nrow(Glass)
testindex <- sample(index, trunc(length(index)/3))
testset <- Glass[testindex,]
trainset <- Glass[-testindex,]
svm.model <- svm(Type ~ ., data = trainset, cost = 100, gamma = 1)
svm.pred <- predict(svm.model, testset[,-10])

table(pred = svm.pred, true = testset[,10])

n <- 150 # number of data points
p <- 2 # dimension
sigma <- 1 # variance of the distribution
meanpos <- 0 # centre of the distribution of positive examples
meanneg <- 3 # centre of the distribution of negative examples
npos <- round(n/2) # number of positive examples
nneg <- n-npos # number of negative examples
# Generate the positive and negative examples
xpos <- matrix(rnorm(npos*p,mean=meanpos,sd=sigma),npos,p)
xneg <- matrix(rnorm(nneg*p,mean=meanneg,sd=sigma),npos,p)
x <- rbind(xpos,xneg)
# Generate the labels
y <- matrix(c(rep(1,npos),rep(-1,nneg)))
# Visualize the data
plot(x,col=ifelse(y>0,1,2))
legend("topleft",c('Positive','Negative'),col=seq(2),pch=1,text.col=seq(2))

ntrain <- round(n*0.8) # number of training examples
tindex <- sample(n,ntrain) # indices of training samples
xtrain <- x[tindex,]
xtest <- x[-tindex,]
ytrain <- y[tindex]
ytest <- y[-tindex]
istrain=rep(0,n)
istrain[tindex]=1
# Visualize
plot(x,col=ifelse(y>0,1,2), pch=ifelse(istrain==1,1,2))
legend("topleft",c('Positive Train','Positive Test','Negative Train','Negative Test'),col=c(1,1,2,2), pch=c(1,2,1,2), text.col=c(1,1,2,2))

svp <- ksvm(xtrain,ytrain,type="C-svc", kernel='vanilladot', C=100,scaled=c())
# General summary
svp
# Attributes that you can access
attributes(svp) # did you look?
# For example, the support vectors
alpha(svp)
alphaindex(svp)
b(svp)  	# remember b?
# Use the built-in function to pretty-plot the classifier
plot(svp,data=xtrain)

data(promotergene)
## create test and training set
ind <- sample(1:dim(promotergene)[1],20)
genetrain <- promotergene[-ind, ]
genetest <- promotergene[ind, ]
## train a support vector machine
gene <-  ksvm(Class~., data=genetrain, kernel="rbfdot",
            kpar=list(sigma=0.03), C=70, cross=4, prob.model=TRUE)
# KSVM is more nonlinear with more kernels 
## predict gene type probabilities on the test set
genetype <- predict(gene,genetest,type="probabilitie")


library(caret)
ctrl <- trainControl(method = "cv", savePred=T)
mod <- train(Type~., data=Glass, method = "svmLinear", trControl = ctrl)
head(mod$pred)
