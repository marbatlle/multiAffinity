import os
import pandas as pd
import numpy as np

expression_mats  = pd.read_csv('1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/normalized_counts.txt', delimiter= "\t")
expression_mats = expression_mats.set_index(['Unnamed: 0'])

# Obtain T mean expression values
expression_T = expression_mats.loc[:, ~expression_mats.columns.str.startswith('Normal')]
expression_genes = expression_T.mean(axis=1)
expression_genes = pd.DataFrame(expression_genes, columns=['expression'])
expression_genes.index.names = ['genes']
expression_genes.drop(expression_genes.loc[expression_genes['expression']==0].index, inplace=True)
expression_genes = expression_genes.rename(columns={'expression': "T"})

expression_genes.to_csv('1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/T_exp.csv')

# Obtain NT mean expression values
expression_NT = expression_mats.loc[:, ~expression_mats.columns.str.startswith('Hepatoblastoma')]
expression_genes = expression_NT.mean(axis=1)
expression_genes = pd.DataFrame(expression_genes, columns=['expression'])
expression_genes.index.names = ['genes']
expression_genes.drop(expression_genes.loc[expression_genes['expression']==0].index, inplace=True)
expression_genes = expression_genes.rename(columns={'expression': "NT"})

expression_genes.to_csv('1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/NT_exp.csv')