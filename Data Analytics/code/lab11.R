# most code from http://escience.rpi.edu/data/DA/

library("robustbase")
library("cvRools")
data(coleman)

set.seed(1234) # set seed for reproducibility
## set up folds for cross-validation
folds <- cvFolds(nrow(coleman), K = 5, R = 50)
## compare LS, MM and LTS regression
# perform cross-validation for an LS regression model
fitLm <- lm(Y ~ ., data = coleman)
cvFitLm <- cvLm(fitLm, cost = rtmspe, folds = folds, trim = 0.1)
# perform cross-validation for an MM regression model
fitLmrob <- lmrob(Y ~ ., data = coleman, k.max = 500)
cvFitLmrob <- cvLmrob(fitLmrob, cost = rtmspe, folds = folds, trim = 0.1)
# perform cross-validation for an LTS regression model
fitLts <- ltsReg(Y ~ ., data = coleman)
cvFitLts <- cvLts(fitLts, cost = rtmspe, folds = folds, trim = 0.1)
# combine results into one object
cvFits <- cvSelect(LS = cvFitLm, MM = cvFitLmrob, LTS = cvFitLts)

# plot results for the MM regression model
densityplot(cvFitLmrob)
# plot combined results
densityplot(cvFits)
## compare raw and reweighted LTS estimators for
## 50% and 75% subsets
# 50% subsets
fitLts50 <- ltsReg(Y ~ ., data = coleman, alpha = 0.5)
cvFitLts50 <- cvLts(fitLts50, cost = rtmspe, folds = folds,
                    fit = "both", trim = 0.1)
# 75% subsets
fitLts75 <- ltsReg(Y ~ ., data = coleman, alpha = 0.75)
cvFitLts75 <- cvLts(fitLts75, cost = rtmspe, folds = folds,
                    fit = "both", trim = 0.1)
# combine and plot results
cvFitsLts <- cvSelect("0.5" = cvFitLts50, "0.75" = cvFitLts75)
cvFitsLts
densityplot(cvFitsLts)


tuning <- list(tuning.psi=c(3.14, 3.44, 3.88, 4.68))
# perform cross-validation
cvFitsLmrob <- cvTuning(fitLmrob$call, data = coleman, y = coleman$Y, tuning = tuning, cost = rtmspe, folds = folds, costArgs = list(trim = 0.1))




require(boot)
# leave-one-out and 6-fold cross-validation prediction error for 
# the mammals data set.
data(mammals, package="MASS")
mammals.glm <- glm(log(brain) ~ log(body), data = mammals)
(cv.err <- cv.glm(mammals, mammals.glm)$delta)
(cv.err.6 <- cv.glm(mammals, mammals.glm, K = 6)$delta)

# As this is a linear model we could calculate the leave-one-out 
# cross-validation estimate without any extra model-fitting.
muhat <- fitted(mammals.glm)
mammals.diag <- glm.diag(mammals.glm)
(cv.err <- mean((mammals.glm$y - muhat)^2/(1 - mammals.diag$h)^2))


# leave-one-out and 11-fold cross-validation prediction error for 
# the nodal data set.  Since the response is a binary variable an
# appropriate cost function is
cost <- function(r, pi = 0) mean(abs(r-pi) > 0.5)

nodal.glm <- glm(r ~ stage+xray+acid, binomial, data = nodal)
(cv.err <- cv.glm(nodal, nodal.glm, cost, K = nrow(nodal))$delta)
(cv.11.err <- cv.glm(nodal, nodal.glm, cost, K = 11)$delta)



library(e1071)
library(rpart)
library(mlbench) # etc.
library(randomForest) # or library(randomForest)
data(kyphosis)

fitKF <- randomForest(Kyphosis ~ Age + Number + Start,   data=kyphosis)
print(fitKF)   # view results
importance(fitKF) # importance of each predictor
# what else can you do?

data(Titanic)
fitkf2 <- randomForest(Survived ~ Mileage + Price + Country + Reliability + Type, data=Titanic)
print(fitkf2)
importance(fitkf2)

dist.au <- read.csv("http://rosetta.reltech.org/TC/v15/Mapping/data/dist-Aus.csv")
# Lab8b_mds1_2015.R
row.names(dist.au) <- dist.au[, 1]
dist.au <- dist.au[, -1]
dist.au

library(igraph)
g <- graph.full(nrow(dist.au))
V(g)$label <- city.names
layout <- layout.mds(g, dist = as.matrix(dist.au))
plot(g, layout = layout, vertex.size = 3)

fit <- cmdscale(dist.au, eig = TRUE, k = 2)
x <- fit$points[, 1]
y <- fit$points[, 2]

plot(x, y, pch = 19, xlim = range(x) + c(0, 600))
city.names <- c("Adelaide", "Alice Springs", "Brisbane", "Darwin", "Hobart", 
                "Melbourne", "Perth", "Sydney")
text(x, y, pos = 4, labels = city.names)



# Factor Analysis

data(iqitems)
#
data(ability)
ability.irt <- irt.fa(ability)
ability.scores <- score.irt(ability.irt,ability)

data(attitude)
cor(attitude)
# Compute eigenvalues and eigenvectors of the correlation matrix.
pfa.eigen<-eigen(cor(attitude))
pfa.eigen$values
# set a value for the number of factors (for clarity)
factors<-2
# Extract and transform two components.
pfa.eigen$vectors [ , 1:factors ]  %*% 
  + diag ( sqrt (pfa.eigen$values [ 1:factors ] ),factors,factors )

