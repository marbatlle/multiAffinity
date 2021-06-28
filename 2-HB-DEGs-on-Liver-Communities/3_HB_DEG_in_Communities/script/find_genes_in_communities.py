import pandas as pd
import numpy as np

DEG = pd.read_csv('1-Obtaining-DEGs-for-HB/DEGs_HB/HB_db_DEG.csv',sep=',')
DEG_list = DEG.Name.tolist()

community = pd.read_csv('2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/clusters/cluster_genes.txt', header=None)
community_list = community[0].tolist()

matches = list(set(DEG_list).intersection(set(community_list)))

if len(matches) == 0:
    print('0 	','NaN')
else:
    print(len(matches),' 	',matches)

with open('2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/output/matches_list.txt', 'a') as f:
    for item in matches:
        f.write("%s\n" % item)