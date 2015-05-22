library(caret)
library(AppliedPredictiveModeling)
#library(dplyr)

bank <- read.csv("~/data/bank-full.csv", sep=";")
attach(bank)
summary(bank)

hist(bank$age)
hist(bank$campaign)

# Kernel density plots for mpg
# grouped by number of gears (indicated by color)
qplot(bank$y, data=bank, geom="density", alpha=I(.5), 
      main="Distribution of Gas Milage", xlab="Miles Per Gallon", 
      ylab="Density")

qplot(bank$y, data=bank, main="Yeses and Nos", xlab='', ylab="number")

fitControl <- trainControl(
  ## 10-fold CV
  method = "cv",
  number = 10,
  repeats = 5)

set.seed(825)
boostedLogistic <- train(bank$y ~ ., data = bank,
                 method = 'LogitBoost',
                 allowParallel = T,
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = TRUE)
boostedLogistic


rf <- train(bank$y ~ ., data = bank,
     method = 'rf',
      trControl = trainControl(
      method = "cv",
      number = 5))

rf

#transparentTheme(trans = .4)
#featurePlot(bank[, 1:5],y = bank$y, plot="pairs", auto.key = list(columns = 3))

wine <- read.csv("C:/Users/sakoveT430/Downloads/winequality-red.csv", sep=";")
qplot(wine$quality, data=wine, main="wine quality", xlab='', ylab="number")

# Seems like bimodal distribution
densityplot(wine$quality, data=wine)
featurePlot(wine, wine$quality)


winerf <- train(wine$quality ~ ., data = wine,
                         method = 'rf',
                         allowParallel = T,
                         trControl = fitControl,
                         ## This last option is actually one
                         ## for gbm() that passes through
                         verbose = TRUE)
winerf



winesvm <- train(wine$quality ~ ., data = wine,
                 method = 'svmPoly',
                 allowParallel = T,
                 trControl = fitControl,
                 ## This last option is actually one,
                 ## for gbm() that passes through
                 verbose = TRUE)
winesvm

