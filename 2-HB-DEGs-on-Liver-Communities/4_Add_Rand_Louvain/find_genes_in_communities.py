import pandas as pd
import numpy as np

DEG = pd.read_csv('4_Add_Rand_Louvain/HB_db_DEG.csv',sep=',')
DEG_list = DEG.gene.tolist()

community = pd.read_csv('4_Add_Rand_Louvain/clusters/cluster_genes_rand.txt', header=None)
community_list = community[0].tolist()

matches = list(set(DEG_list ).intersection(set(community_list)))

if len(matches) == 0:
    print('No gene matches')
else:
    print(len(matches),'genes match: ',matches)