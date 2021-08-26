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
StudyA_T['Study'] = 'Study A'

StudyA_T.index = [x for x in range(1, len(StudyA_T.values)+1)]
#StudyA_T = StudyA_T.sample(500)


StudyA_NT = StudyA.loc[:, ~StudyA.columns.str.startswith('T')]
StudyA_NT = StudyA.mean(axis=1)
StudyA_NT = pd.DataFrame(StudyA_NT, columns=['Expression'])
StudyA_NT.index.names = ['genes']
StudyA_NT.drop(StudyA_NT.loc[StudyA_NT['Expression']==0].index, inplace=True)
StudyA_NT['Study'] = 'Study A'

StudyA_NT.index = [x for x in range(1, len(StudyA_NT.values)+1)]
#StudyA_NT = StudyA_NT.sample(500)


# Study B
StudyB = pd.read_csv('1-metaDEGs/output/normalized_counts/GSE89775.txt',sep=',')
StudyB = StudyB.set_index(['Unnamed: 0'])

StudyB_T = StudyB.loc[:, ~StudyB.columns.str.startswith('NT')]
StudyB_T = StudyB_T.mean(axis=1)
StudyB_T = pd.DataFrame(StudyB_T, columns=['Expression'])
StudyB_T.index.names = ['genes']
StudyB_T.drop(StudyB_T.loc[StudyB_T['Expression']==0].index, inplace=True)
StudyB_T['Study'] = 'Study B'

StudyB_T.index = [x for x in range(1, len(StudyB_T.values)+1)]
#StudyB_T = StudyB_T.sample(500)

StudyB_NT = StudyB.loc[:, ~StudyB.columns.str.startswith('T')]
StudyB_NT = StudyB.mean(axis=1)
StudyB_NT = pd.DataFrame(StudyB_NT, columns=['Expression'])
StudyB_NT.index.names = ['genes']
StudyB_NT.drop(StudyB_NT.loc[StudyB_NT['Expression']==0].index, inplace=True)
StudyB_NT['Study'] = 'Study B'

StudyB_NT.index = [x for x in range(1, len(StudyB_NT.values)+1)]
#StudyB_NT = StudyB_NT.sample(500)

# Study c
StudyC = pd.read_csv('1-metaDEGs/output/normalized_counts/GSE104766.txt',sep=',')
StudyC = StudyC.set_index(['Unnamed: 0'])

StudyC_T = StudyC.loc[:, ~StudyC.columns.str.startswith('NT')]
StudyC_T = StudyC_T.mean(axis=1)
StudyC_T = pd.DataFrame(StudyC_T, columns=['Expression'])
StudyC_T.index.names = ['genes']
StudyC_T.drop(StudyC_T.loc[StudyC_T['Expression']==0].index, inplace=True)
StudyC_T['Study'] = 'Study C'

StudyC_T.index = [x for x in range(1, len(StudyC_T.values)+1)]
StudyC_T = StudyC_T.sample(500)

StudyC_NT = StudyC.loc[:, ~StudyC.columns.str.startswith('T')]
StudyC_NT = StudyC.mean(axis=1)
StudyC_NT = pd.DataFrame(StudyC_NT, columns=['Expression'])
StudyC_NT.index.names = ['genes']
StudyC_NT.drop(StudyC_NT.loc[StudyC_NT['Expression']==0].index, inplace=True)
StudyC_NT['Study'] = 'Study C'

StudyC_NT.index = [x for x in range(1, len(StudyC_NT.values)+1)]
#StudyC_NT = StudyC_NT.sample(500)

# Study D
StudyD = pd.read_csv('1-metaDEGs/output/normalized_counts/GSE133039.txt',sep=',')
StudyD = StudyD.set_index(['Unnamed: 0'])

StudyD_T = StudyD.loc[:, ~StudyD.columns.str.startswith('NT')]
StudyD_T = StudyD_T.mean(axis=1)
StudyD_T = pd.DataFrame(StudyD_T, columns=['Expression'])
StudyD_T.index.names = ['genes']
StudyD_T.drop(StudyD_T.loc[StudyD_T['Expression']==0].index, inplace=True)
StudyD_T['Study'] = 'Study D'

StudyD_T.index = [x for x in range(1, len(StudyD_T.values)+1)]
StudyD_T = StudyD_T.sample(500)

StudyD_NT = StudyD.loc[:, ~StudyD.columns.str.startswith('T')]
StudyD_NT = StudyD.mean(axis=1)
StudyD_NT = pd.DataFrame(StudyD_NT, columns=['Expression'])
StudyD_NT.index.names = ['genes']
StudyD_NT.drop(StudyD_NT.loc[StudyD_NT['Expression']==0].index, inplace=True)
StudyD_NT['Study'] = 'Study D'

StudyD_NT.index = [x for x in range(1, len(StudyD_NT.values)+1)]
#StudyD_NT = StudyD_NT.sample(500)

# Study E
StudyE = pd.read_csv('1-metaDEGs/output/normalized_counts/GSE151347.txt',sep=',')
StudyE = StudyE.set_index(['Unnamed: 0'])

StudyE_T = StudyE.loc[:, ~StudyE.columns.str.startswith('NT')]
StudyE_T = StudyE_T.mean(axis=1)
StudyE_T = pd.DataFrame(StudyE_T, columns=['Expression'])
StudyE_T.index.names = ['genes']
StudyE_T.drop(StudyE_T.loc[StudyE_T['Expression']==0].index, inplace=True)
StudyE_T['Study'] = 'Study E'

StudyE_T.index = [x for x in range(1, len(StudyE_T.values)+1)]
StudyE_T = StudyE_T.sample(500)

StudyE_NT = StudyE.loc[:, ~StudyE.columns.str.startswith('T')]
StudyE_NT = StudyE.mean(axis=1)
StudyE_NT = pd.DataFrame(StudyE_NT, columns=['Expression'])
StudyE_NT.index.names = ['genes']
StudyE_NT.drop(StudyE_NT.loc[StudyE_NT['Expression']==0].index, inplace=True)
StudyE_NT['Study'] = 'Study E'

StudyE_NT.index = [x for x in range(1, len(StudyE_NT.values)+1)]
StudyE_NT = StudyE_NT.sample(500)


# NT
data_NT = pd.concat([StudyA_NT, StudyB_NT], axis=0)
data_NT.to_csv("1b-StudyVariability/src/NT.csv", index=False)

# T
data_T = pd.concat([StudyA_T, StudyB_T], axis=0)
data_T.to_csv("1b-StudyVariability/src/T.csv", index=False)

# ONLY DEGS

# Import DEGs

degs = pd.read_csv('1-metaDEGs/output/metaDEGs/metaDEGs.txt',sep=',')
degs_list = degs['Name'].tolist()

# Study A - DEGs
StudyA = pd.read_csv('1-metaDEGs/output/normalized_counts/GSE81928.txt',sep=',')
StudyA = StudyA.set_index(['Unnamed: 0'])
StudyA = StudyA[StudyA.index.isin(degs_list)]

StudyA_T = StudyA.loc[:, ~StudyA.columns.str.startswith('NT')]
StudyA_T = StudyA_T.mean(axis=1)
StudyA_T = pd.DataFrame(StudyA_T, columns=['Expression'])
StudyA_T.index.names = ['genes']
StudyA_T.drop(StudyA_T.loc[StudyA_T['Expression']==0].index, inplace=True)
StudyA_T['Study'] = 'Study A'
StudyA_T.index = [x for x in range(1, len(StudyA_T.values)+1)]

StudyA_NT = StudyA.loc[:, ~StudyA.columns.str.startswith('T')]
StudyA_NT = StudyA.mean(axis=1)
StudyA_NT = pd.DataFrame(StudyA_NT, columns=['Expression'])
StudyA_NT.index.names = ['genes']
StudyA_NT.drop(StudyA_NT.loc[StudyA_NT['Expression']==0].index, inplace=True)
StudyA_NT['Study'] = 'Study A'
StudyA_NT.index = [x for x in range(1, len(StudyA_NT.values)+1)]


# Study B - DEGs
StudyB = pd.read_csv('1-metaDEGs/output/normalized_counts/GSE89775.txt',sep=',')
StudyB = StudyB.set_index(['Unnamed: 0'])
StudyB = StudyB[StudyB.index.isin(degs_list)]

StudyB_T = StudyB.loc[:, ~StudyB.columns.str.startswith('NT')]
StudyB_T = StudyB_T.mean(axis=1)
StudyB_T = pd.DataFrame(StudyB_T, columns=['Expression'])
StudyB_T.index.names = ['genes']
StudyB_T.drop(StudyB_T.loc[StudyB_T['Expression']==0].index, inplace=True)
StudyB_T['Study'] = 'Study B'
StudyB_T.index = [x for x in range(1, len(StudyB_T.values)+1)]

StudyB_NT = StudyB.loc[:, ~StudyB.columns.str.startswith('T')]
StudyB_NT = StudyB.mean(axis=1)
StudyB_NT = pd.DataFrame(StudyB_NT, columns=['Expression'])
StudyB_NT.index.names = ['genes']
StudyB_NT.drop(StudyB_NT.loc[StudyB_NT['Expression']==0].index, inplace=True)
StudyB_NT['Study'] = 'Study B'
StudyB_NT.index = [x for x in range(1, len(StudyB_NT.values)+1)]


# NT
data_NT = pd.concat([StudyA_NT, StudyB_NT], axis=0)
data_NT.to_csv("1b-StudyVariability/src/NT_DEGs.csv", index=False)

# T
data_T = pd.concat([StudyA_T, StudyB_T], axis=0)
data_T.to_csv("1b-StudyVariability/src/T_DEGs.csv", index=False)