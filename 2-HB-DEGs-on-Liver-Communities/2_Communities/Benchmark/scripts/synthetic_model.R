pacman::p_load(igraph)

m <- 100 # the number of edges in the graph
set.seed(64)
g <- sample_gnm(20000, m)
edges <- as_edgelist(g)

write.table(edges, file='2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/edges_tmp', sep='\t')
