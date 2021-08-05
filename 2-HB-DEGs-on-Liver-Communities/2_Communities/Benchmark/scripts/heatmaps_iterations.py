import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# load all table files
path_to_files = '/home/mar/Documents/TFM/GitHub/HB_PublicData/2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/'
lst = []
for filen in [x for x in os.listdir(path_to_files) if '.txt' in x]:
    lst.append(pd.read_csv(path_to_files+filen, delimiter= " "))
df = pd.concat(lst, ignore_index=True)

grouped_df = df.groupby(['N1','N2'])[['optimal_rands','num_comm','avg_size_comm']].mean().reset_index()

grouped_df = grouped_df.round(decimals=2)

# num rands
num_rands_df = grouped_df.reset_index().pivot(index='N1', columns='N2', values='optimal_rands')
num_rands_df.sort_index(axis=0, ascending=False, inplace=True)

plt.figure(figsize=(10, 10))
num_rands_hm = sns.heatmap(num_rands_df, linewidths=.5, annot=True, annot_kws={'fontsize':12}, fmt='2g').set(title='Optimal Number Randomizations')

plt.savefig('/home/mar/Documents/TFM/GitHub/HB_PublicData/2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/heatmap_randomizations.png')

# num communities
num_comm_df = grouped_df.reset_index().pivot(index='N1', columns='N2', values='num_comm')
num_comm_df.sort_index(axis=0, ascending=False, inplace=True)

plt.figure(figsize=(10, 10))
num_comm_hm = sns.heatmap(num_comm_df, linewidths=.5, annot=True, annot_kws={'fontsize':8}, fmt='2g').set(title='Number Communities')

plt.savefig('/home/mar/Documents/TFM/GitHub/HB_PublicData/2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/heatmap_number_communities.png')

# avg size communities
avg_size_comm_df = grouped_df.reset_index().pivot(index='N1', columns='N2', values='avg_size_comm')
avg_size_comm_df.sort_index(axis=0, ascending=False, inplace=True)

plt.figure(figsize=(10, 10))
avg_size_comm_hm = sns.heatmap(avg_size_comm_df, linewidths=.5, annot=True, annot_kws={'fontsize':12}).set(title='Average Size of Communities')

plt.savefig('/home/mar/Documents/TFM/GitHub/HB_PublicData/2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/heatmap_size_communities.png')