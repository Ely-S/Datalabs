EPI_Data <- read.csv("~/data/2010EPI_data.csv", na.strings="..")
View(EPI_Data)
attach(EPI_Data)

explore <- function(VAR, name) {
  summary(VAR)
  fivenum(VAR, na.rm=TRUE)
  stem(VAR)
  hist(VAR, main=name, seq(30., 95., 1.0), breaks=floor(sqrt(length(x))), prob=TRUE)
  lines(density(VAR,na.rm=TRUE,bw=1.))
  rug(VAR)
  plot(ecdf(VAR), main=name,  do.points=FALSE, verticals=TRUE)
  par(pty="s")
  qqnorm(VAR, main=name); qqline(VAR)
  x <- rt(250, df = 5)
  qqnorm(x, main=name); qqline(x)
  x<-seq(30, 95, 1)
  qqplot(main=name, qt(ppoints(250), df = 5), x, xlab = "Q-Q plot for t dsn")
  qqline(x)
  plot(main=name, ecdf(VAR), do.points=FALSE, verticals=TRUE)help
}

explore(EPI, "EPI")
explore(DALY, "DALY")
explore(WATER_H, "WATER_H")

boxplot(EPI,DALY)
t.test(EPI,DALY)
qqplot(EPI,DALY)

EPILand<-EPI[!Landlock]
Eland <- EPILand[!is.na(EPILand)]
hist(ELand)
hist(ELand, seq(30., 95., 1.0), prob=TRUE)

shapiro.test(EPI)
ks.test(EPI,seq(30.,95.,1.0))

t.test(EPI, DALY)
var.test(EPI,DALY)

ks.test(EPI,DALY)
