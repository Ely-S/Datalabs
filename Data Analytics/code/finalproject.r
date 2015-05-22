d <- read.csv("C:/Users/sakoveT430/Desktop/blanchard.csv", quote="")
#dd <- read.csv("C:\\Users\\sakoveT430\\Desktop\\Data\\data.csv")
library(caret)
library(rworldmap)
library(mass)
view(d)
summary(d)
set.seed(825)

# Preprocessing

data <- data.frame(unr = scale(d$unr),
                   fpgap = scale(d$tfpgap),
                   rrate=scale(d$rrate),
                   di = scale(d$dpi), # delta rrate
                   ltr = scale(d$rl), # Long term interest rate
                   benefit = scale(d$benefit),
                   e5unr = scale(d$e5unr),
                   e15unr = scale(d$e15unr),
                   tfpgap = scale(d$tfpgap),
                   empro=scale(d$empro),
                   tuden=scale(d$uden),
                   coord=scale(d$coord),
                   cty = factor(d$country),
                   meanunr = scale(d$meanunr),
                   empro2 = scale(d$newep),
                   tax = scale(d$t), # Tax 
                   almp = scale(d$almphat),
                   duration = scale(d$duration),
                   time = factor(d$period),
                   lds = scale(d$ld8) #  labor demand shifter
                   
)

attach(data)

fitControl <- trainControl(method = "LOOCV")
treefc <- trainControl(method = "oob")

tree <- train(unr ~ ., data = data,  method = 'ctree',  trControl = fitControl)
tree
plot(tree)
plot(tree$finalModel)

m2 <- train(unr ~ ., data = na.omit(data),  method = 'rf',  trControl = treefc)
m2
plot(m2)
plot(m2$finalModel)

# Boosted Tree

bstTree  <- train(unr ~ ., data = data,  method = 'bstTree',  trControl = fitControl)
bstTree

plot(bstTree)
plot(bstTree$finalModel)

specification <- empro + lds + e15unr + e5unr + ltr + di+ tfpgap + benefit 
+ time + duration + almp + tax + empro2 + coord+ uden + tfpgap  + factor(cty) 

glm(formula = s , data = data)

glmm <- train(unr ~ . , data = data,
           method = 'glmboost',
           trControl = fitControl)
glmm
plot(m)
plot(m$finalModel)


#m2 <- train(dd$youth.youth ~ ., data = dd,
#        method = 'glmboost',
#        trControl = fitControl)


km <-  kmeans(x = na.omit(c(d$cty, d$empro, d$union, d$tfp)), centers = 2)

data$cluster <- d$cluster
data$cluster3 <- d$cluster3

sPDF <- joinCountryData2Map(data, joinCode = "NAME", nameJoinColumn = "cty")
mapCountryData(sPDF, nameColumnToPlot = "meanunr", mapTitle = "Mean Unemployment Rates")
mapCountryData(sPDF, nameColumnToPlot = "cluster", 
               , catMethod = "categorical"
               , numCats = 2
               , colourPalette = "heat")
mapCountryData(sPDF, nameColumnToPlot = "cluster3", 
               , catMethod = "categorical"
               , numCats = 3
               , colourPalette = "heat")

# cluster kmeans duration empro coord uden union almphat benefit rrate, k(2) measure(L2) name(cluster) start(krandom)

mapCountryData(sPDF, nameColumnToPlot = "empro", 
               , catMethod = "pretty"
               , mapTitle = "Employment Protection"
               , colourPalette = "heat")


par(mfrow=c(2, 2))
ggplot(d, aes(cty, unr)) + geom_boxplot()   + labs(title = "Unemployment by Country", y = 'Unemployment Rate', x = 'Country')
ggplot(d, aes(cty, empro)) + geom_bar(stat='identity') + labs(title = "Employment Protection by Country", y = 'Employment Protection', x = 'Country')
ggplot(d, aes(cty, union)) + geom_bar(stat='identity') + labs(title = "Union by Country", y = 'Union Rate', x = 'Country')
ggplot(d, aes(cty, uden)) + geom_bar(stat='identity')  + labs(title = "Union Density by Country", y = 'Union Density', x = 'Country')
ggplot(d, aes(cty, tfp)) + geom_boxplot()   + labs(title = "Total Factor Productivity by Country", y = 'TFP', x = 'Country')

ggplot(d, aes(cty, tax)) + geom_bar(stat='identity')   + labs(title = "Tax Wedge", y = '', x = 'Country')

lm(unr ~ .)