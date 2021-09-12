import pandas as pd
import numpy as np

#import metadegs
degs = pd.read_csv('output/metaDEGs/metaDEGs/metaDEGs.txt',sep=',')
degs = degs.rename(columns={'Name': 'metaDEGs', 'Score': 'RRA Score'})
degs['metaDEGs'] = degs['metaDEGs'].astype('str')

#import affinity correlation
affinity = pd.read_csv('output/MultiAffinity/Affinity_Corr.txt',sep=',',usecols=['Genes','Corr'])

affinity = affinity.rename(columns={'Genes': 'metaDEGs', 'Corr': 'Affinity Corr'})
affinity['metaDEGs'] = affinity['metaDEGs'].astype('str')

#import communities
comm = pd.read_csv('output/Communities/degs_communities.txt',sep=';', names=['metaDEGs','Communities'])

# Join metadegs and affinity
df = pd.merge(pd.merge(degs,affinity,how='left',on='metaDEGs'),comm,how='left',on='metaDEGs')
df = df.replace(np.nan,0)

# export final df
df.to_csv("output/multiAffinity-output.txt",sep = ",", index=None, header=True)