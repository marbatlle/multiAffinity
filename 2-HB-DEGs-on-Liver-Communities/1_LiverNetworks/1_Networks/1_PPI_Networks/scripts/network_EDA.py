import pandas as pd
import numpy as np
import networkx as nx
import matplotlib.pyplot as plt


df_path = '2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/tmp_PPI.gr'
df = pd.read_csv(df_path, sep='\t',names=['node1','node2'])

G=nx.from_pandas_edgelist(df, "node1", "node2")

[e for e in G.edges];


print('1. Basic graph info')
print(nx.info(G))

print('2. Draw larger component')

print('Total number of connected components:',len(sorted(nx.connected_components(G), key = len, reverse=True)))

Gcc = sorted(nx.connected_components(G), key=len, reverse=True)
G0 = G.subgraph(Gcc[0])

nx.draw(G0, node_size=50, node_color='lightblue')

print('3. Network characteristics')
density = nx.density(G)
print("Network density:", density)

# Next, use nx.connected_components to get the list of components,
# then use the max() command to find the largest one:
components = nx.connected_components(G)
largest_component = max(components, key=len)

# Create a "subgraph" of just the largest component
# Then calculate the diameter of the subgraph, just like you did with density.
subgraph = G.subgraph(largest_component)
diameter = nx.diameter(subgraph)
print("Network diameter of largest component:", diameter)

# add Degree dictionary
degree_dict = dict(G.degree(G.nodes()))
nx.set_node_attributes(G, degree_dict, 'degree')
# create dictionary of degrees
from operator import itemgetter
sorted_degree = sorted(degree_dict.items(), key=itemgetter(1), reverse=True)

print("Top 20 nodes by degree:")
for d in sorted_degree[:20]:
    print(d)
