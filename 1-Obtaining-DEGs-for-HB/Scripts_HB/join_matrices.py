import os
import pandas as pd
import numpy as np

#Load expression matrices and join
# load all table files
path_to_files = '1-Obtaining-DEGs-for-HB/Matrices_HB/Normalized_HB/'
lst_expmat = []
for filen in [x for x in os.listdir(path_to_files) if '.txt' in x]:
    lst_expmat.append(pd.read_csv(path_to_files+filen, delimiter= "\t"))
expression_mats = pd.concat(lst_expmat, ignore_index=True)
expression_mats = expression_mats.groupby(['Unnamed: 0']).mean().reset_index()

expression_mats = expression_mats.set_index(['Unnamed: 0'])
expression_mats = expression_mats.loc[:, ~expression_mats.columns.str.startswith('Normal')]
expression_genes = expression_mats.mean(axis=1)
expression_genes = pd.DataFrame(expression_genes, columns=['expression'])
expression_genes.index.names = ['genes']
expression_genes.drop(expression_genes.loc[expression_genes['expression']==0].index, inplace=True)

expression_genes.to_csv('1-Obtaining-DEGs-for-HB/Matrices_HB/Normalized_HB/mean_expression.csv')