\name{CWindowCluster}
\alias{CWindowCluster}

\title{
Window-Level Time Series Clustering
}

\description{This function clusters time series at a window level, based on the Algorithm 2 of Ciampi et al. (2010).}

\usage{
CWindowCluster(X, Alpha = NULL, Beta = NULL, Delta = NULL, Theta = 0.8, 
  p, w, s, Epsilon = 1)
}

\arguments{
  \item{X}{a matrix of time series to be clustered (time series in columns).}
  \item{Alpha}{lower limit of the time series domain, passed to \code{\link{CSlideCluster}}.}
  \item{Beta}{upper limit of the time series domain, passed to \code{\link{CSlideCluster}}.}
  \item{Delta}{closeness parameter, passed to \code{\link{CSlideCluster}}.}
  \item{Theta}{connectivity parameter, passed to \code{\link{CSlideCluster}}.}
  \item{p}{number of layers (time series observations) in each slide.}
  \item{w}{number of slides in each window.}
  \item{s}{step to shift a window, calculated in number of slides. Recommended values are 1 (overlapping windows) or \code{w} (non-overlapping windows).}
  \item{Epsilon}{a real value in [0,1] used to identify each pair of time series that are clustered together over at least \code{w*Epsilon} slides within a window (see Definition 7 by Ciampi et al., 2010). Default is 1.}
}

\details{
This is the upper-level function for time series clustering. It exploits the function \code{\link{CSlideCluster}} to cluster time series within each slide based on closeness and homogeneity measures. Then, it uses slide-level cluster assignments to cluster time series within each window. 

The total length of time series (number of levels, i.e., \code{nrow(X)}) should be divisible by \code{p}.
}

\value{
A vector (if \code{X} contains only one window) or matrix with cluster labels for each time series (columns) and window (rows). 
}

\references{
Ciampi, A., Appice, A., and Malerba, D. (2010). Discovering trend-based clusters in spatially distributed data streams. In \emph{International Workshop of Mining Ubiquitous and Social Environments}, pages 107--122.
}

\author{
Vyacheslav Lyubchich
}

\seealso{\code{\link{CNeighbor}}, 
         \code{\link{CHomogeneity}},
         \code{\link{CExpandSlideCluster}},
         \code{\link{CExpandWindowCluster}},
         \code{\link{CSlideCluster}}
}

\examples{
#For example, weekly data come in slides of 4 weeks
p <- 4 #number of layers in each slide (data come in a slide)

#We want to analyze the trend clusters within a window of 1 year
w <- 13 #number of slides in each window
s <- w  #step to shift a window

#Simulate 26 autoregressive time series with two years of weekly data (52*2 weeks), 
#with a 'burn-in' period of 300.
N <- 26
T <- 2*p*w

set.seed(123) 
phi <- c(0.5) #parameter of autoregression
X <- sapply(1:N, function(x) arima.sim(n = T + 300, 
  list(order = c(length(phi), 0, 0), ar = phi)))[301:(T + 300),]
colnames(X) <- paste("TS", c(1:dim(X)[2]), sep = "")

tmp <- CWindowCluster(X, Delta = NULL, Theta = 0.8, p = p, w = w, s = s, Epsilon = 1)

#Time series were simulated with the same parameters, but based on the clustering parameters,
#not all time series join the same cluster. We can plot the main cluster for each window, and 
#time series out of the cluster:
par(mfrow = c(2, 2))
ts.plot(X[c(1:(p*w)), tmp[1,] == 1], ylim = c(-4, 4), 
  main = "Time series cluster 1 in window 1")
ts.plot(X[c(1:(p*w)), tmp[1,] != 1], ylim = c(-4, 4), 
  main = "The rest of the time series in window 1")
ts.plot(X[c(1:(p*w)) + s*p, tmp[2,] == 1], ylim = c(-4, 4), 
  main = "Time series cluster 1 in window 2")
ts.plot(X[c(1:(p*w)) + s*p, tmp[2,] != 1], ylim = c(-4, 4), 
  main = "The rest of the time series in window 2")
}

\keyword{ts}
\keyword{trend}
