# Run function f on s$v 
ex <- function(s, f, v, ...){
  lapply(s, function(d){
    f(getElement(d[1], v), ...)
  })
}

exb <- function(s, f, v, ...){
  lapply(s, function(d){
    f(getElement(d, v), ...)
  })
}

showall <- function(...) {
  par(mfrow = c(2, 3))
  ex(...)
}

showallb <- function(...) {
  par(mfrow = c(2, 3))
  exb(...)
}

stest <- function(e){
  shapiro.test(sample(e, size = 5000, replace = TRUE )) 
}

files <- paste("http://escience.rpi.edu/data/DA/nyt/nyt", 1:5, ".csv", sep='')
dss <- lapply(files, read.csv)

showall(dss, boxplot, "Age", main = "Age")
showall(dss, hist, "Age", main = "Histogram of Age", xlab = "Age")
showall(dss, plot.ecdf, "Age", main = "Age")
showall(dss, qqplot, "Age", 0:100, main = "Age", xlab = "Age")
showall(dss, qqline, "Age", 0:100)
ex(dss, stest, "Age")

showallb(dss, boxplot, "Impressions", main="Impressions")
showallb(dss, hist, "Impressions", main = "Histogram of Impressions", xlab = "Impressions")
showallb(dss, plot.ecdf, "Impressions", main  = 'Impressions')
showallb(dss, qqplot, "Impressions", 0:100, main = "Impressions", xlab = "")
showallb(dss, qqline, "Impressions", 0:100)
exb(dss, stest, "Impressions")

filtered <- lapply(dss[1:2], function(d){
  subset(d, Signed_In = 0) 
})

showall(filtered, hist, "Age", main = "Histogram of Age", xlab = "Age")
showall(filtered, plot.ecdf, "Age", main = "Age")
showall(filtered, qqplot, "Age", 0:100, main = "Age", xlab = "Age")
showall(filtered, qqline, "Age", 0:100)
ex(filtered, stest, "Age")

showallb(filtered, hist, "Impressions", main = "Histogram of Impressions", xlab = "Impressions")
showallb(filtered, plot.ecdf, "Impressions", main  = 'Impressions')
showallb(filtered, qqplot, "Impressions", 0:100, main = "Impressions", xlab = "")
showallb(filtered, qqline, "Impressions", 0:100)
exb(filtered, stest, "Impressions")
