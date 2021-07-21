import pandas as pd
import numpy as np
import networkx as nx
import matplotlib.pyplot as plt


df_path = '2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/tmp_PPI.gr'
df = pd.read_csv(df_path, sep='\t',names=['node1','node2'])

G=nx.from_pandas_edgelist(df, "node1", "node2")

print('1. Basic graph info')
print(nx.info(G))

print('2. Draw larger component')

print('Total number of connected components:',len(sorted(nx.connected_components(G), key = len, reverse=True)))

Gcc = sorted(nx.connected_components(G), key=len, reverse=True)
G0 = G.subgraph(Gcc[0])

#nx.draw(G0, node_size=50, node_color='lightblue')

print('3. Network characteristics')
density = nx.density(G)
print("Network density:", density)

