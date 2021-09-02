import pandas as pd
import numpy as np

matches = pd.read_csv('output/tmp/matches.csv',sep='\t',header=None,names=['num_matches','matches'])

ppi_communities = pd.read_csv('output/tmp/communities_effectif.csv',sep='\t')

df_concat = pd.concat([ppi_communities,matches], axis=1)

df_concat.set_index('Unnamed: 0', inplace=True)

df_concat.to_csv('output/tmp/communities_genes_matches.csv')

df_sorted = df_concat.sort_values('num_matches', ascending=False)
matches_2 = df_sorted.head(20)

matches_2.to_csv('output/tmp/top_matches.csv')
