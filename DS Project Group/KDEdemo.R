# Kernels
require(graphics)
require(KernSmooth)
require(ggplot2)

pairs(USArrests, panel = panel.smooth, main = "USArrests data")


plot(density(USArrests$Murder, kernel = "rectangular"))
plot(density(USArrests$Murder, kernel = "epanechnikov"))
plot(density(USArrests$Murder, kernel = "cosine"))
plot(density(USArrests$Murder, kernel = "triangular"))
plot(density(USArrests$Murder, kernel = "gaussian", bw = .1))

gdist <-density(USArrests$Murder, kernel = "gaussian")
plot(gdist)

x.new <- rnorm(1e6, sample(USArrests$Murder, size = 1e6, replace = TRUE), gdist$bw)
lines(density(x.new), col = "blue")

x <- cbind(USArrests$UrbanPop, USArrests$Assault)
est <- bkde2D(x, bandwidth=c(0.7, 7))
contour(est$x1, est$x2, est$fhat) # fhat is a density estimate
persp(est$fhat)


gg <- ggplot(USArrests)
gg + geom_density_2d(aes(x = Murder, y = Rape))
gg + geom_density(aes(x = Murder))

fit <- locpoly(x, USArrests$Assault, bandwidth = .2)
lines(fit)

