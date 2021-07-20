#!/usr/bin/python

import sys
import os
import pandas as pd
import numpy as np

#Load expression matrices and join
# load all table files
path_to_files = '2-HB-DEGs-on-Liver-Communities/4_NodeAffinity_neighbours/output/temp/'
lst_corr = []
for filen in [x for x in os.listdir(path_to_files) if '.txt' in x]:
    lst_corr.append(pd.read_csv(path_to_files+filen, delimiter= "\t"))
corr_joined = pd.concat(lst_corr, ignore_index=True)

lst_corr = []
for row in corr_joined.itertuples():
    index= row.Index
    if corr_joined.iloc[index,2] <= 0.05:
        lst_corr.append(index)

corr_joined = corr_joined.iloc[lst_corr]

corr_joined.sort_values(by=['corr'], ascending=False)
corr_joined.to_csv(r'2-HB-DEGs-on-Liver-Communities/4_NodeAffinity_neighbours/output/temp/corr.txt', sep='\t',index = False)