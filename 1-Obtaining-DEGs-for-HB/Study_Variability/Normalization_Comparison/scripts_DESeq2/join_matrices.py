import os
import pandas as pd
import numpy as np

# Study A
StudyA = pd.read_csv('1-Obtaining-DEGs-for-HB/Matrices_HB/Normalized_HB/normalized_GSE81928.txt',sep='\t')
StudyA = StudyA.set_index(['Unnamed: 0'])

StudyA_T = StudyA.loc[:, ~StudyA.columns.str.startswith('Normal')]
StudyA_T = StudyA_T.mean(axis=1)
StudyA_T = pd.DataFrame(StudyA_T, columns=['Expression'])
StudyA_T.index.names = ['genes']
StudyA_T.drop(StudyA_T.loc[StudyA_T['Expression']==0].index, inplace=True)
StudyA_T['Study'] = 'Study A'

StudyA_T.index = [x for x in range(1, len(StudyA_T.values)+1)]
#StudyA_T = StudyA_T.sample(500)


StudyA_NT = StudyA.loc[:, ~StudyA.columns.str.startswith('Hepatoblastoma')]
StudyA_NT = StudyA.mean(axis=1)
StudyA_NT = pd.DataFrame(StudyA_NT, columns=['Expression'])
StudyA_NT.index.names = ['genes']
StudyA_NT.drop(StudyA_NT.loc[StudyA_NT['Expression']==0].index, inplace=True)
StudyA_NT['Study'] = 'Study A'

StudyA_NT.index = [x for x in range(1, len(StudyA_NT.values)+1)]
#StudyA_NT = StudyA_NT.sample(500)


# Study B
StudyB = pd.read_csv('1-Obtaining-DEGs-for-HB/Matrices_HB/Normalized_HB/normalized_GSE89775.txt',sep='\t')
StudyB = StudyB.set_index(['Unnamed: 0'])

StudyB_T = StudyB.loc[:, ~StudyB.columns.str.startswith('Normal')]
StudyB_T = StudyB_T.mean(axis=1)
StudyB_T = pd.DataFrame(StudyB_T, columns=['Expression'])
StudyB_T.index.names = ['genes']
StudyB_T.drop(StudyB_T.loc[StudyB_T['Expression']==0].index, inplace=True)
StudyB_T['Study'] = 'Study B'

StudyB_T.index = [x for x in range(1, len(StudyB_T.values)+1)]
#StudyB_T = StudyB_T.sample(500)

StudyB_NT = StudyB.loc[:, ~StudyB.columns.str.startswith('Hepatoblastoma')]
StudyB_NT = StudyB.mean(axis=1)
StudyB_NT = pd.DataFrame(StudyB_NT, columns=['Expression'])
StudyB_NT.index.names = ['genes']
StudyB_NT.drop(StudyB_NT.loc[StudyB_NT['Expression']==0].index, inplace=True)
StudyB_NT['Study'] = 'Study B'

StudyB_NT.index = [x for x in range(1, len(StudyB_NT.values)+1)]
#StudyB_NT = StudyB_NT.sample(500)

# Study c
StudyC = pd.read_csv('1-Obtaining-DEGs-for-HB/Matrices_HB/Normalized_HB/normalized_GSE104766.txt',sep='\t')
StudyC = StudyC.set_index(['Unnamed: 0'])

StudyC_T = StudyC.loc[:, ~StudyC.columns.str.startswith('Normal')]
StudyC_T = StudyC_T.mean(axis=1)
StudyC_T = pd.DataFrame(StudyC_T, columns=['Expression'])
StudyC_T.index.names = ['genes']
StudyC_T.drop(StudyC_T.loc[StudyC_T['Expression']==0].index, inplace=True)
StudyC_T['Study'] = 'Study C'

StudyC_T.index = [x for x in range(1, len(StudyC_T.values)+1)]
StudyC_T = StudyC_T.sample(500)

StudyC_NT = StudyC.loc[:, ~StudyC.columns.str.startswith('Hepatoblastoma')]
StudyC_NT = StudyC.mean(axis=1)
StudyC_NT = pd.DataFrame(StudyC_NT, columns=['Expression'])
StudyC_NT.index.names = ['genes']
StudyC_NT.drop(StudyC_NT.loc[StudyC_NT['Expression']==0].index, inplace=True)
StudyC_NT['Study'] = 'Study C'

StudyC_NT.index = [x for x in range(1, len(StudyC_NT.values)+1)]
StudyC_NT = StudyC_NT.sample(500)

# Study D
StudyD = pd.read_csv('1-Obtaining-DEGs-for-HB/Matrices_HB/Normalized_HB/normalized_GSE133039.txt',sep='\t')
StudyD = StudyD.set_index(['Unnamed: 0'])

StudyD_T = StudyD.loc[:, ~StudyD.columns.str.startswith('Normal')]
StudyD_T = StudyD_T.mean(axis=1)
StudyD_T = pd.DataFrame(StudyD_T, columns=['Expression'])
StudyD_T.index.names = ['genes']
StudyD_T.drop(StudyD_T.loc[StudyD_T['Expression']==0].index, inplace=True)
StudyD_T['Study'] = 'Study D'

StudyD_T.index = [x for x in range(1, len(StudyD_T.values)+1)]
StudyD_T = StudyD_T.sample(500)

StudyD_NT = StudyD.loc[:, ~StudyD.columns.str.startswith('Hepatoblastoma')]
StudyD_NT = StudyD.mean(axis=1)
StudyD_NT = pd.DataFrame(StudyD_NT, columns=['Expression'])
StudyD_NT.index.names = ['genes']
StudyD_NT.drop(StudyD_NT.loc[StudyD_NT['Expression']==0].index, inplace=True)
StudyD_NT['Study'] = 'Study D'

StudyD_NT.index = [x for x in range(1, len(StudyD_NT.values)+1)]
StudyD_NT = StudyD_NT.sample(500)

# Study E
StudyE = pd.read_csv('1-Obtaining-DEGs-for-HB/Matrices_HB/Normalized_HB/normalized_GSE151347.txt',sep='\t')
StudyE = StudyE.set_index(['Unnamed: 0'])

StudyE_T = StudyE.loc[:, ~StudyE.columns.str.startswith('Normal')]
StudyE_T = StudyE_T.mean(axis=1)
StudyE_T = pd.DataFrame(StudyE_T, columns=['Expression'])
StudyE_T.index.names = ['genes']
StudyE_T.drop(StudyE_T.loc[StudyE_T['Expression']==0].index, inplace=True)
StudyE_T['Study'] = 'Study E'

StudyE_T.index = [x for x in range(1, len(StudyE_T.values)+1)]
StudyE_T = StudyE_T.sample(500)

StudyE_NT = StudyE.loc[:, ~StudyE.columns.str.startswith('Hepatoblastoma')]
StudyE_NT = StudyE.mean(axis=1)
StudyE_NT = pd.DataFrame(StudyE_NT, columns=['Expression'])
StudyE_NT.index.names = ['genes']
StudyE_NT.drop(StudyE_NT.loc[StudyE_NT['Expression']==0].index, inplace=True)
StudyE_NT['Study'] = 'Study E'

StudyE_NT.index = [x for x in range(1, len(StudyE_NT.values)+1)]
StudyE_NT = StudyE_NT.sample(500)


# NT
data_NT = pd.concat([StudyA_NT, StudyB_NT], axis=0)
data_NT.to_csv("1-Obtaining-DEGs-for-HB/Study_Variability/Normalization_Comparison/NT_deseq.csv", index=False)

# T
data_T = pd.concat([StudyA_T, StudyB_T], axis=0)
data_T.to_csv("1-Obtaining-DEGs-for-HB/Study_Variability/Normalization_Comparison/T_deseq.csv", index=False)
