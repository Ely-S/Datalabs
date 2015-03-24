convertCurrency <- function(currency) {
  currency1 <- sub('$','',as.character(currency),fixed=TRUE)
  currency2 <- as.numeric(gsub('\\,','',as.character(currency1))) 
  currency2
}
bronx <- read.csv("~/data/data/rollingsales_bronx.csv")
bronx$price <- convertCurrency(bronx$SALE.PRICE)
bronx$sq <- as.numeric(bronx$GROSS.SQUARE.FEET)
bronx<-bronx[which(bronx$sq>0 & bronx$sq>0 & bronx$price>0),]
View(bronx)
plot(log(bronx$sq), log(bronx$price))
m1<-lm(log(bronx$price)~log(bronx$sq),data=bronx)
summary(m1)
plot(log(bronx$sq), log(bronx$price))
abline(m1,col="red",lwd=2) 
plot(resid(m1))
bronx$NEIGHBORHOOD <- as.numeric(bronx$NEIGHBORHOOD)
bronx$BUILDING.CLASS.CATEGORY <- as.numeric(bronx$BUILDING.CLASS.CATEGORY)
bronx$lsq <- as.numeric(bronx$GROSS.SQUARE.FEET)
summary(m1)
plot(log(bronx$sq), log(bronx$price))
abline(m1,col="red",lwd=2) 
plot(resid(m1))



m3<-lm(log(bronx$price)~0+log(bronx$sq)+log(bronx$lsq)+bronx$NEIGHBORHOOD+bronx$BUILDING.CLASS.CATEGORY,data=bronx)
summary(m3)
plot(resid(m3))

m4<-lm(log(bronx$price)~0+log(bronx$sq)+log(bronx$lsq)+bronx$NEIGHBORHOOD*bronx$BUILDING.CLASS.CATEGORY,data=bronx)
summary(m4)
plot(resid(m4))

