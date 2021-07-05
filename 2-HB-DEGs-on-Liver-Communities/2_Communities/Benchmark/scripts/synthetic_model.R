library(igraph)

# Import args
args <- commandArgs(TRUE)

# Create random edge
m <- args # the number of edges in the graph
g <- sample_gnm(20000, m)
edges <- as_edgelist(g)

write.table(edges, file='2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/edges_tmp', sep='\t', row.names = FALSE, col.names = FALSE,)
