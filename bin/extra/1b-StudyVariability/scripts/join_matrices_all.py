import os
import pandas as pd
import numpy as np

# Study A
StudyA = pd.read_csv('1-metaDEGs/output/normalized_counts/GSE81928.txt',sep=',')
StudyA = StudyA.set_index(['Unnamed: 0'])

StudyA_T = StudyA.loc[:, ~StudyA.columns.str.startswith('NT')]
StudyA_T = StudyA_T.mean(axis=1)
StudyA_T = pd.DataFrame(StudyA_T, columns=['Expression'])
StudyA_T.index.names = ['genes']
StudyA_T.drop(StudyA_T.loc[StudyA_T['Expression']==0].index, inplace=True)
StudyA_T = StudyA_T.rename(columns={"Expression": "T"})

StudyA_NT = StudyA.loc[:, ~StudyA.columns.str.startswith('T')]
StudyA_NT = StudyA.mean(axis=1)
StudyA_NT = pd.DataFrame(StudyA_NT, columns=['Expression'])
StudyA_NT.index.names = ['genes']
StudyA_NT.drop(StudyA_NT.loc[StudyA_NT['Expression']==0].index, inplace=True)
StudyA_NT = StudyA_NT.rename(columns={"Expression": "NT"})

StudyA_joined = StudyA_T.merge(StudyA_NT, how='inner', on='genes')
StudyA_joined['Study'] = 'Study A'
StudyA_joined.index = [x for x in range(1, len(StudyA_joined.values)+1)]


# Study B
StudyB = pd.read_csv('1-metaDEGs/output/normalized_counts/GSE89775.txt',sep=',')
StudyB = StudyB.set_index(['Unnamed: 0'])

StudyB_T = StudyB.loc[:, ~StudyB.columns.str.startswith('NT')]
StudyB_T = StudyB_T.mean(axis=1)
StudyB_T = pd.DataFrame(StudyB_T, columns=['Expression'])
StudyB_T.index.names = ['genes']
StudyB_T.drop(StudyB_T.loc[StudyB_T['Expression']==0].index, inplace=True)
StudyB_T = StudyB_T.rename(columns={"Expression": "T"})

StudyB_NT = StudyB.loc[:, ~StudyB.columns.str.startswith('T')]
StudyB_NT = StudyB.mean(axis=1)
StudyB_NT = pd.DataFrame(StudyB_NT, columns=['Expression'])
StudyB_NT.index.names = ['genes']
StudyB_NT.drop(StudyB_NT.loc[StudyB_NT['Expression']==0].index, inplace=True)
StudyB_NT = StudyB_NT.rename(columns={"Expression": "NT"})

StudyB_joined = StudyB_T.merge(StudyB_NT, how='inner', on='genes')
StudyB_joined['Study'] = 'Study B'
StudyB_joined.index = [x for x in range(1, len(StudyB_joined.values)+1)]

# Join studies
data = pd.concat([StudyA_joined, StudyB_joined], axis=0)
data.to_csv("1b-StudyVariability/src/T_and_NT.csv", index=False)

# ONLY DEGS

# Import DEGs
degs = pd.read_csv('1-metaDEGs/output/metaDEGs/metaDEGs.txt',sep=',')
degs_list = degs['Name'].tolist()


# Study A
StudyA = pd.read_csv('1-metaDEGs/output/normalized_counts/GSE81928.txt',sep=',')
StudyA = StudyA.set_index(['Unnamed: 0'])
StudyA = StudyA[StudyA.index.isin(degs_list)]

StudyA_T = StudyA.loc[:, ~StudyA.columns.str.startswith('NT')]
StudyA_T = StudyA_T.mean(axis=1)
StudyA_T = pd.DataFrame(StudyA_T, columns=['Expression'])
StudyA_T.index.names = ['genes']
StudyA_T.drop(StudyA_T.loc[StudyA_T['Expression']==0].index, inplace=True)
StudyA_T = StudyA_T.rename(columns={"Expression": "T"})

StudyA_NT = StudyA.loc[:, ~StudyA.columns.str.startswith('T')]
StudyA_NT = StudyA.mean(axis=1)
StudyA_NT = pd.DataFrame(StudyA_NT, columns=['Expression'])
StudyA_NT.index.names = ['genes']
StudyA_NT.drop(StudyA_NT.loc[StudyA_NT['Expression']==0].index, inplace=True)
StudyA_NT = StudyA_NT.rename(columns={"Expression": "NT"})

StudyA_joined = StudyA_T.merge(StudyA_NT, how='inner', on='genes')
StudyA_joined['Study'] = 'Study A'
StudyA_joined.index = [x for x in range(1, len(StudyA_joined.values)+1)]


# Study B
StudyB = pd.read_csv('1-metaDEGs/output/normalized_counts/GSE89775.txt',sep=',')
StudyB = StudyB.set_index(['Unnamed: 0'])
StudyB = StudyB[StudyB.index.isin(degs_list)]

StudyB_T = StudyB.loc[:, ~StudyB.columns.str.startswith('NT')]
StudyB_T = StudyB_T.mean(axis=1)
StudyB_T = pd.DataFrame(StudyB_T, columns=['Expression'])
StudyB_T.index.names = ['genes']
StudyB_T.drop(StudyB_T.loc[StudyB_T['Expression']==0].index, inplace=True)
StudyB_T = StudyB_T.rename(columns={"Expression": "T"})

StudyB_NT = StudyB.loc[:, ~StudyB.columns.str.startswith('T')]
StudyB_NT = StudyB.mean(axis=1)
StudyB_NT = pd.DataFrame(StudyB_NT, columns=['Expression'])
StudyB_NT.index.names = ['genes']
StudyB_NT.drop(StudyB_NT.loc[StudyB_NT['Expression']==0].index, inplace=True)
StudyB_NT = StudyB_NT.rename(columns={"Expression": "NT"})

StudyB_joined = StudyB_T.merge(StudyB_NT, how='inner', on='genes')
StudyB_joined['Study'] = 'Study B'
StudyB_joined.index = [x for x in range(1, len(StudyB_joined.values)+1)]

# Join studies
data = pd.concat([StudyA_joined, StudyB_joined], axis=0)
data.to_csv("1b-StudyVariability/src/T_and_NT_DEGs.csv", index=False)
