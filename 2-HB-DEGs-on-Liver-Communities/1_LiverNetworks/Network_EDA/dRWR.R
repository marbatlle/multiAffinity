
library(igraph)
library(dnet)

net <- erdos.renyi.game(12000, 0.3, type=c("gnp", "gnm"),
        directed = FALSE, loops = FALSE)
PTmatrix <- dRWR(net, normalise='laplacian', restart=0.75, normalise.affinity.matrix='quantile')

print(PTmatrix[1:5,1:5])
