import pandas as pd
import numpy as np
import itertools

matches = pd.read_csv('2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/output/liver_clusters_matches.csv')

#matches = matches[matches.matches.notnull()]

#matches = matches.drop(matches.index[matches['matches'] == 'NaN'], inplace = True)

matches_list = set(matches["matches"].to_list())
matches_list.remove(' NaN')


#matches_list = [item for sublist in  for item in sublist]


print(matches_list)