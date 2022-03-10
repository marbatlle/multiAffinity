## FROM STEP 4.0. Create output report

import pandas as pd
import numpy as np

# import and process input files
degs = pd.read_csv('output/metaDEGs/metaDEGs.txt',sep=',')
degs = degs.groupby(['Name'],as_index=False).Score.mean()
degs = degs.rename(columns={'Name': 'metaDEGs', 'Score': 'Aggregate Rank'})
degs.to_csv("output/metaDEGs/metaDEGs.txt",sep = ",", index=None, header=True)
degs['metaDEGs'] = degs['metaDEGs'].astype('str')
affinity = pd.read_csv('output/Affinity/Affinity_Corr.txt',sep=',', dtype=str)
comm = pd.read_csv('output/Communities/degs_communities.txt',sep=';', names=['metaDEGs','Communities'], dtype=str)
comm['Communities'] = comm['Communities'].replace(np.nan,0)
comm = comm.rename(columns={'Communities': 'Community ID'})
metrics = pd.read_csv('output/Affinity/part_coef.txt',sep=',', dtype=str)
DifExp = pd.read_csv('output/Affinity/difexp.txt',sep=',', dtype=str)
DifExp.log2FoldChange = DifExp.log2FoldChange.replace(np.nan,0)
DifExp = DifExp.rename(columns={'genes': 'metaDEGs', 'log2FoldChange': 'log2FC'})
DifExp['log2FC'] = pd.to_numeric(DifExp['log2FC'])
DifExp = DifExp[DifExp['log2FC'].abs() > 1] 

# Join metadegs, affinity correlation,communities and metrics
df = pd.merge(affinity,degs,how='inner',on='metaDEGs')
df = pd.merge(df,comm,how='inner',on='metaDEGs')
df = pd.merge(df,DifExp,how='inner',on='metaDEGs')
df = pd.merge(df,metrics,how='inner',on='metaDEGs')
df = df.replace(np.nan,0)

# Rounds data
df = df.drop('Aggregate Rank', 1)
df['DifExp-Aff Corr'] = pd.to_numeric(df['DifExp-Aff Corr'])
df['DifExp-Aff Corr'] = df['DifExp-Aff Corr'].round(4)
df['Corr adj-p.val'] = pd.to_numeric(df['Corr adj-p.val'])
df['log2FC'] = pd.to_numeric(df['log2FC'])
df['log2FC'] = df['log2FC'].round(4)
df['part_coef'] = pd.to_numeric(df['part_coef'])
df['part_coef'] = df['part_coef'].round(4)

# present result
df = df.set_index(['metaDEGs']) 
df = df.groupby(level=0).first()
df = df.reindex(df['DifExp-Aff Corr'].abs().sort_values(ascending=False).index)
df = df.drop('Corr adj-p.val', 1)
df = df.rename(columns={'part_coef': 'Participation Coefficient','overlap_degree': 'Overlap Degree','DifExp-Aff Corr': 'AS-DE Corr' })

# export final df if it cas content
if not df.empty:
     df.to_csv("output/multiAffinity_report.csv",sep = ",", index=True, header=True)