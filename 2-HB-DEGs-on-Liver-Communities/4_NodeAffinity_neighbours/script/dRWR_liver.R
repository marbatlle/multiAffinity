setwd("~/Documents/TFM/GitHub/HB_PublicData")

#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

database = args[1]


library(tidyverse)
library(igraph)
library(dnet)
library(network)

#https://www.jessesadler.com/post/network-analysis-with-r/
# https://eehh-stanford.github.io/SNA-workshop/data-import.html#importing-an-edgelist

# Getting the path of your current open file

# importing the edgelist
liver.edges <- read.table(file=paste("2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/",database,"_PPI.gr", sep=""))

## convert to an igraph network
liver.edges.mat <- as.matrix(liver.edges)
g <- graph_from_edgelist(liver.edges.mat, directed=FALSE)
g_nodes <- as.list(unique(unlist(V(g)[name], use.names = FALSE)))

# import degs
HB_db_DEG <- read_csv("1-Obtaining-DEGs-for-HB/DEGs_HB/HB_db_DEG.csv",col_types = cols_only(Name = col_guess()))
nodes_of_interest <- as.list(unique(unlist(HB_db_DEG[,1], use.names = FALSE)))

for(i in 1:length(nodes_of_interest)){
  if (!is.null(g_nodes[[nodes_of_interest[[i]]]]) ) {
    deg_name=nodes_of_interest[[i]]
    # subset neighbourhood of graph vertices (https://igraph.org/r/doc/ego.html)
    g_neighbours = ego(g, order = 3, nodes = nodes_of_interest[[i]])
    g_neigh_network <- induced_subgraph(g,unlist(g_neighbours))
    # obtain dRWR matrix
    PTmatrix <- dRWR(g_neigh_network, normalise='laplacian', restart=0.5, normalise.affinity.matrix='none')
    write.table(as.matrix(PTmatrix),file=paste("2-HB-DEGs-on-Liver-Communities/4_NodeAffinity_neighbours/output/PTmatrix_",database,"_",deg_name,".txt", sep=""),  sep="\t")
  }
}

