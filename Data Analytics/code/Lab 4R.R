require(class)
require(gdata)
require(ggmap)
require("xlsx")
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



m3<-lm(log(bronx$price)~0+log(bronx$sq)+log(bronx$lsq)*factor(bronx$NEIGHBORHOOD)+bronx$BUILDING.CLASS.CATEGORY,data=bronx)
summary(m3)
plot(resid(m3))

m4<-lm(log(bronx$price)~0+log(bronx$sq)+log(bronx$lsq)+bronx$NEIGHBORHOOD*bronx$BUILDING.CLASS.CATEGORY,data=bronx)
summary(m4)
plot(resid(m4))



# Begin Lab 4

#clean up with regular expressions
bronx$SALE.PRICE<- as.numeric(gsub("[^]:digit:]]","",bronx$SALE.PRICE))
#missing values?
sum(is.na(bronx$SALE.PRICE))
#zero sale prices
sum(bronx$SALE.PRICE==0)
#clean these numeric and date fields
bronx$GROSS.SQUARE.FEET<- as.numeric(gsub("[^]:digit:]]","",bronx$GROSS.SQUARE.FEET))
bronx$LAND.SQUARE.FEET<- as.numeric(gsub("[^]:digit:]]","",bronx$LAND.SQUARE.FEET))
bronx$SALE.DATE<- as.Date(gsub("[^]:digit:]]","",bronx$SALE.DATE))
bronx$YEAR.BUILT<- as.numeric(gsub("[^]:digit:]]","",bronx$YEAR.BUILT))
bronx$ZIP.CODE<- as.character(gsub("[^]:digit:]]","",bronx$ZIP.CODE))





#addresses contain apartment #'s even though there is another column for that - remove them - compresses addresses
bronx$ADDRESSONLY<- gsub("[,][[:print:]]*","",gsub("[ ]+","",trim(bronx$ADDRESS)))


#filter out low prices
bronxa <- unique(bronx[bronx$price>1000, c("ADDRESSONLY", "ZIP.CODE")])
#how many left?
nval<-dim(bronxa)[1]
#new data frame for sorting the addresses, fixing etc.
#bronxadd<-unique(data.frame(bronxa$ADDRESSONLY, bronxa$ZIP.CODE,stringsAsFactors=FALSE))
# fix the names
#names(bronxadd)<-c("ADDRESSONLY","ZIP.CODE")
#bronxadd<-bronxadd[order(bronxadd$ADDRESSONLY),]

# "Oh Bloody Hell!, I thought we resolved it."

#problem, we need a spatial distribution since none of the columns have that
#we will use google maps so limit the number to under 500 (ask me why)
nsample <- 350
addsample<-bronxa[sample.int(dim(bronxa)[1], nsample),]
#new data frame for the full address
addrlist<-data.frame(1:nsample,addsample$ADDRESSONLY,rep("NEW YORK",times=nsample), rep("NY",times=nsample), addsample$ZIP.CODE, rep("US",times=nsample))

addsample$add <- paste(addrlist$addsample.ADDRESSONLY, addrlist$addsample.ZIP.CODE)
addsample$loc <- geocode(addsample$ADDRESSONLY)

ggmap(get_googlemap("New York" ))
bronx1 <- bronx
bronx1$SALE.PRICE<-sub("\\$","",bronx1$SALE.PRICE)
bronx1$SALE.PRICE<-as.numeric(gsub(",","", bronx1$SALE.PRICE))
bronx1$GROSS.SQUARE.FEET<-as.numeric(gsub(",","", bronx1$GROSS.SQUARE.FEET))
bronx1$LAND.SQUARE.FEET<-as.numeric(gsub(",","", bronx1$LAND.SQUARE.FEET))
bronx1$SALE.DATE<- as.Date(gsub("[^]:digit:]]","",bronx1$SALE.DATE))
bronx1$YEAR.BUILT<- as.numeric(gsub("[^]:digit:]]","",bronx1$YEAR.BUILT))
bronx1$ZIP.CODE<- as.character(gsub("[^]:digit:]]","",bronx1$ZIP.CODE))
minprice<-10000
bronx1<-bronx1[which(bronx1$SALE.PRICE>=minprice),]
nval<-dim(bronx1)[1]
bronx1$ADDRESSONLY<- gsub("[,][[:print:]]*","",gsub("[ ]+","",trim(bronx1$ADDRESS)))
bronxadd<-unique(data.frame(bronx1$ADDRESSONLY, bronx1$ZIP.CODE,stringsAsFactors=FALSE))
names(bronxadd)<-c("ADDRESSONLY","ZIP.CODE")
bronxadd<-bronxadd[order(bronxadd$ADDRESSONLY),]
duplicates<-duplicated(bronx1$ADDRESSONLY)
for(i in 1:2345) {
  if(duplicates[i]==FALSE) dupadd<-bronxadd[bronxadd$duplicates,1]
}#Did not quite understand what we are doing with dupadd. Wrong one.
nsample=450
addsample<-bronxadd[sample.int(dim(bronxadd),size=nsample),]#I use nval here
library(ggmap)
addrlist<-paste(addsample$ADDRESSONLY, "NY", addsample$ZIP.CODE, "US", sep=" ")
querylist<-geocode(addrlist) #This is cool. Take a break.
matched<-(querylist$lat!=0 &&querylist$lon!=0)
addsample<-cbind(addsample,querylist$lat,querylist$lon)
names(addsample)<-c("ADDRESSONLY","ZIPCODE","Latitude","Longitude")# correct the column names. Worked
adduse<-merge(bronx1,addsample)
adduse<-adduse[!is.na(adduse$Latitude),]
mapcoord<-adduse[,c(2,3,24,25)]
table(mapcoord$NEIGHBORHOOD)
mapcoord$NEIGHBORHOOD <- as.factor(mapcoord$NEIGHBORHOOD)
map <- get_map(location = 'Bronx', zoom = 12)#Zoom 11 or 12
ggmap(map) + geom_point(aes(x = mapcoord$Longitude, y = mapcoord$Latitude, size =1,
                            color=mapcoord$NEIGHBORHOOD), data = mapcoord)
+theme(legend.position = "none")
#It would be perfect if I can decrease the size of points
mapmeans<-cbind(adduse,as.numeric(mapcoord$NEIGHBORHOOD))
colnames(mapmeans)[26] <- "NEIGHBORHOOD" #This is the right way of renaming.
keeps <- c("ZIP.CODE","NEIGHBORHOOD","TOTAL.UNITS","LAND.SQUARE.FEET","GROSS.SQUARE.FEET",
           "SALE.PRICE","Latitude","Longitude")
mapmeans<-mapmeans[keeps]#Dropping others
mapmeans$NEIGHBORHOOD<-as.numeric(mapcoord$NEIGHBORHOOD)
for(i in 1:8){
  mapmeans[,i]=as.numeric(mapmeans[,i])
}
mapobj<-kmeans(mapmeans,5, iter.max=10, nstart=5, algorithm = c("Hartigan-Wong", "Lloyd",
                                                                "Forgy", "MacQueen"))
fitted(mapobj,method=c("centers","classes"))
mapobj$centers
library(cluster)
clusplot(mapmeans, mapobj$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)
library(fpc)#Need to install.packages("fpc")
plotcluster(mapmeans, mapobj$cluster)
mapmeans1<-mapmeans[,-c(1,3,4)]
mapobjnew<-kmeans(mapmeans1,5, iter.max=10, nstart=5, algorithm = c("Hartigan-Wong", "Lloyd",
                                                                    "Forgy", "MacQueen"))
fitted(mapobjnew,method=c("centers","classes"))
clusplot(mapmeans1, mapobjnew$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)
plotcluster(mapmeans1, mapobjnew$cluster)
ggmap(map) + geom_point(aes(x = mapcoord$Longitude, y = mapcoord$Latitude, size =1,
                            color=mapobjnew$cluster), data = mapcoord)#How to change colors?



