library(tidyverse)
library(igraph)
library(dnet)
library(network)

#https://www.jessesadler.com/post/network-analysis-with-r/
# https://eehh-stanford.github.io/SNA-workshop/data-import.html#importing-an-edgelist

# Getting the path of your current open file

# importing the edgelist
liver.edges <- read.table('2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/tmp_PPI.txt')

## convert to an igraph network
liver.edges.mat <- as.matrix(liver.edges)
g <- graph_from_edgelist(liver.edges.mat, directed=FALSE)

PTmatrix <- dRWR(g, normalise='laplacian', restart=0.5, normalise.affinity.matrix='none')

write.table(as.matrix(PTmatrix),'2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/PTmatrix_tmp_PPI.txt',  sep="\t")
