# Code obtained from https://github.com/cirillodavide/gene_multilayer_network - edit to obtain nodes as gene names and not gene_id

import cobra
import os
from os.path import join
from collections import defaultdict
import re
import csv
import networkx as nx
from networkx.algorithms import bipartite
import itertools
from math import log
from collections import Counter
import datetime
import urllib.request
import zipfile
import shutil
from pathlib import Path
import io
import gzip

now = datetime.datetime.now()

# download and import Recon3D model

url = 'http://bigg.ucsd.edu/static/models/Recon3D.xml.gz'
outfile_path = '2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/src/Recon3D.xml'
response = urllib.request.urlopen(url)
with open(outfile_path, 'wb') as outfile:
    outfile.write(gzip.decompress(response.read()))
model = cobra.io.read_sbml_model(outfile_path)

# Import the metabolites to prune (Croes et al. 2006):

file = '2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/src/metabolites_to_prune.txt'
remove_metabolites = [x.split(' ')[0].strip('\n') for x in open(file).readlines()]

# Define a function to summarize the graph features:

def summary(graph):
    top_nodes = {n for n, d in graph.nodes(data=True) if d['bipartite']==0}
    bottom_nodes = set(graph) - top_nodes
    return top_nodes, bottom_nodes

# Group genes by metabolite (when product equals reactant):

products_dict = defaultdict(list)
reactants_dict = defaultdict(list)
for r in model.reactions:
    for g in r.genes:
        gene_id = g.id.split('_')[0] # remove isoform info
        gene_name = g.name #include gene name
        if gene_id != "0":
            for m in r.products:
                metabo_id = re.sub(r'_[clmerginx]$', '', m.id) # remove compartment info; _hs means homo sapiens
                if gene_id not in products_dict[m.id]:
                    products_dict[metabo_id].append(gene_name)
            for m in r.reactants:
                metabo_id = re.sub(r'_[clmerginx]$', '', m.id)
                if gene_id not in reactants_dict[m.id]:
                    reactants_dict[metabo_id].append(gene_name)

metabolites_dict = defaultdict(list)
for p_m, p_g in products_dict.items():
    for r_m, r_g in reactants_dict.items():
        if p_m == r_m:
            genes = p_g + r_g
            genes = [re.sub('__\d+__\d+$', '', j) for j in genes]
            metabolite = re.sub('__\d+__\S+__\d+__$', '', p_m)
            if metabolite not in remove_metabolites: # exclude superconnected metabolites (H2O, NAD, etc.)
                metabolites_dict[metabolite].append(genes)
for k,v in metabolites_dict.items():
    metabolites_dict[k] = list(set([item for sublist in v for item in sublist]))

# Summary and plot the bipartite graph:

B = nx.Graph()
for k,v in metabolites_dict.items():
        B.add_nodes_from([k], bipartite=0) # metabolites
        B.add_nodes_from(v, bipartite=1) # genes
        B.add_edges_from([ (k,i) for i in v ])

genes, metabolites = summary(B)        

# Save the entire edge list and ICs:

G = nx.Graph()
for k,v in metabolites_dict.items():
    G.add_edges_from(list(itertools.combinations(v, 2)), label=k)
nx.write_edgelist(G,"2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/Recon3D_metabolites"+".gr",data=['label'])

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
