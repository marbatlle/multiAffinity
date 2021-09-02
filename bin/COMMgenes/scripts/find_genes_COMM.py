import pandas as pd
import numpy as np

DEG = pd.read_csv('src/genes/input_genes.txt',sep=',',names=['Name'])
DEG_list = DEG.Name.tolist()

community = pd.read_csv('output/tmp/cluster_genes.txt', header=None)
community_list = community[0].tolist()

matches = list(set(DEG_list).intersection(set(community_list)))

if len(matches) == 0:
    print('0 	','NaN')
else:
    print(len(matches),' 	',matches)

with open('output/tmp/matches_list.txt', 'a') as f:
    for item in matches:
        f.write("%s\n" % item)