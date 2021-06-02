library(tidyverse)
library(igraph)
library(dnet)
library(network)

#https://www.jessesadler.com/post/network-analysis-with-r/
# https://eehh-stanford.github.io/SNA-workshop/data-import.html#importing-an-edgelist

setwd("~/Documents/TFM/GitHub/HB_PublicData/2-HB-DEGs-on-Liver-Communities/1_LiverNetworks")

# importing the edgelist
liver.edges <- read_tsv('liver_PPI.txt', col_names = FALSE )

## subsetting first 1000 edges
liver.edges = head(liver.edges, 100000)

## convert to an igraph network
liver.edges.mat <- as.matrix(liver.edges)
liver.net <- graph_from_edgelist(liver.edges.mat, directed=FALSE)


#extract first names from list of names to make nicer labels. 
firsts <- unlist(lapply(strsplit(V(liver.net )$name,  " "), '[[', 1))



#let's take a look
# plot(liver.net, vertex.shape="none", vertex.label.cex=0.6, edge.arrow.size=0.4, vertex.label=firsts, layout=layout.kamada.kawai)

PTmatrix <- dRWR(liver.net, normalise='laplacian', restart=0.75, normalise.affinity.matrix='quantile')

print(PTmatrix[1:5,1:5])
