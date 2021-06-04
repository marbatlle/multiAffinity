import pandas as pd
import numpy as np

matches = pd.read_csv('/home/mar/Documents/TFM/GitHub/HB_PublicData/2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/matches.csv',sep='\t',header=None,names=['num_matches','matches'])

ppi_communities = pd.read_csv('/home/mar/Documents/TFM/GitHub/HB_PublicData/2-HB-DEGs-on-Liver-Communities/2_Communities/liver_ppi_clusters_effectif.csv',sep='\t')

df_concat = pd.concat([ppi_communities,matches], axis=1)

df_concat.set_index('Unnamed: 0', inplace=True)

df_concat.to_csv('2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/communities_genes_matches.csv')

df_sorted = df_concat.sort_values('num_matches', ascending=False)
matches_2 = df_sorted.head(19)

matches_2.to_csv('2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/table_2_matches.csv')


#python 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/join_tables.py