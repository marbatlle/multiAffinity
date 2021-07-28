import os
import pandas as pd
import numpy as np

# Load matrices
degs = pd.read_csv('1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/degs.csv', usecols = ['Unnamed: 0','log2FoldChange'], delimiter= ",").set_index(['Unnamed: 0'])
NT_exp = pd.read_csv('1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/NT_exp.csv', delimiter= ",").set_index(['genes'])
T_exp = pd.read_csv('1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/T_exp.csv', delimiter= ",").set_index(['genes'])

# Join matrices
data = pd.concat([degs, NT_exp], axis=1, join='inner')
data = pd.concat([data, T_exp], axis=1, join='inner')
data.index.names = ['genes']

data.to_csv('1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/study_expression.csv')