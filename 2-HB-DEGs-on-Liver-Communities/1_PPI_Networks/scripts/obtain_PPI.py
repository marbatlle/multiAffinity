import pandas as pd
import numpy as np

#loading the human annotated PPIs database from http://iid.ophid.utoronto.ca/
data = pd.read_csv('2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/human_annotated_PPIs.txt', sep='\t')
print(data.head())

#liver interactions

##select liver interactions
#liver_int = data.loc[data['liver'] == "1"]

##subset gene symbols
#liver_int_subset = liver_int[["symbol1","symbol2"]]
#liver_int_subset.to_csv('2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/liver_PPI.txt', sep='\t', index=False, header=None)

#liver cancer interactions

##select liver interactions
#liver_int = data.loc[data['liver cancer'] == "1"]

##subset gene symbols
#liver_int_subset = liver_int[["symbol1","symbol2"]]
#liver_int_subset.to_csv('2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/livercancer_PPI.txt', sep='\t', index=False, header=None)
#liver_int_subset.head()

