import os
import pandas as pd
import numpy as np

expression_mats  = pd.read_csv('1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/normalized_counts.csv', delimiter= ",")
expression_mats = expression_mats.set_index(['Unnamed: 0'])

# Obtain T mean expression values
T_exp = expression_mats.loc[:, ~expression_mats.columns.str.startswith('Normal')]
T_exp = T_exp.mean(axis=1)
T_exp = pd.DataFrame(T_exp, columns=['expression'])
T_exp.index.names = ['genes']
T_exp.drop(T_exp.loc[T_exp['expression']==0].index, inplace=True)
T_exp = T_exp.rename(columns={'expression': "T"})
T_exp.index.names = ['genes']

# Obtain NT mean expression values
NT_exp = expression_mats.loc[:, ~expression_mats.columns.str.startswith('Hepatoblastoma')]
NT_exp = NT_exp.mean(axis=1)
NT_exp = pd.DataFrame(NT_exp, columns=['expression'])
NT_exp.index.names = ['genes']
NT_exp.drop(NT_exp.loc[NT_exp['expression']==0].index, inplace=True)
NT_exp = NT_exp.rename(columns={'expression': "NT"})
NT_exp.index.names = ['genes']

# Load degs
degs = pd.read_csv('1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/lfc.csv', usecols = ['Unnamed: 0','log2FoldChange'], delimiter= ",").set_index(['Unnamed: 0'])

# Join matrices
data = pd.concat([degs, NT_exp], axis=1, join='inner')
data = pd.concat([data, T_exp], axis=1, join='inner')
data.index.names = ['genes']
data['T-NT'] = data['T'] - data['NT'] 

data.to_csv('1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/study_expression.csv')