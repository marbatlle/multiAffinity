library(tidyverse)
library(igraph)
library(dnet)
library(network)

#https://www.jessesadler.com/post/network-analysis-with-r/
# https://eehh-stanford.github.io/SNA-workshop/data-import.html#importing-an-edgelist

# Getting the path of your current open file

# importing the edgelist
liver.edges <- read.table('liver_PPI.txt')

## convert to an igraph network
liver.edges.mat <- as.matrix(liver.edges)
liver.net <- graph_from_edgelist(liver.edges.mat, directed=FALSE)

#let's take a look
# plot(liver.net)

PTmatrix <- dRWR(liver.net, normalise='laplacian', restart=0.75, normalise.affinity.matrix='quantile')

print(PTmatrix[1:5,1:5])
write.table(as.matrix(PTmatrix),'PTmatrix_liver.txt',  sep="\t")
