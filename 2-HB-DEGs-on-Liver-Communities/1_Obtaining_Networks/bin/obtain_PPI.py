import pandas as pd
import numpy as np

#loading the human annotated PPIs database from http://iid.ophid.utoronto.ca/
data = pd.read_csv('2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/src/human_annotated_PPIs.txt', sep='\t')

#liver interactions

## select liver interactions
liver_int = data.loc[data['liver'] != 0]

##subset gene symbols
liver_int_subset = liver_int[["symbol1","symbol2"]]
liver_int_subset.to_csv('2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/liver_PPI.gr', sep='\t', index=False, header=None)

#liver cancer interactions

##select liver interactions
liver_cancer_int = data.loc[data['liver cancer'] != 0]

##subset gene symbols
liver_cancer_int_subset = liver_cancer_int[["symbol1","symbol2"]]
liver_cancer_int_subset.to_csv('2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/livercancer_PPI.gr', sep='\t', index=False, header=None)


