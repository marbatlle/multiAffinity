
#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

database = args[1]

library(tidyverse)
library(igraph)
library(dnet)
library(network)


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
    betweenness <- estimate_betweenness(g,deg_name,cutoff=2)
    print(betweenness)
  }
}
