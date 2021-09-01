import os
import pandas as pd
import numpy as np
from scipy import stats
from scipy.stats import spearmanr

#Load expression matrices and join
# load all table files
path_to_files = '1-metaDEGs/output/normalized_counts/'
lst_expmat = []
for filen in [x for x in os.listdir(path_to_files) if '.txt' in x]:
    lst_expmat.append(pd.read_csv(path_to_files+filen, delimiter= ","))
expression_mats = pd.concat(lst_expmat, ignore_index=True)
expression_mats = expression_mats.groupby(['Unnamed: 0']).mean().reset_index()

expression_mats = expression_mats.set_index(['Unnamed: 0'])
expression_mats = expression_mats.loc[:, ~expression_mats.columns.str.startswith('NT')]
expression_genes = expression_mats.mean(axis=1)
expression_genes = pd.DataFrame(expression_genes, columns=['expression'])
expression_genes.index.names = ['genes']
expression_genes.drop(expression_genes.loc[expression_genes['expression']==0].index, inplace=True)

#Load degs
degs_path = '1-metaDEGs/output/metaDEGs/metaDEGs.txt'
degs = pd.read_csv(degs_path, index_col=0)
degs_names = degs.index.tolist()

#Load rwr matrix
mat_path = '3-MultiAffinity/output/dRWR_matrix.txt'
mat = pd.read_csv(mat_path, sep='\t', index_col=0)

#Find gene matches 
mat_names = mat.index.tolist()
matches = list(set(degs_names).intersection(set(mat_names)))

# create joined matrix
mat_degs = mat.filter(matches, axis=1) # filter only DEGs in column
mat_degs.index.names = ['genes']

result = expression_genes.merge(mat_degs, left_index=True, right_index=True)

# Find larger correlations (top 10)
genes = (result.columns[1:])

corr_list = []
for i in genes:
    corr_df = result[['expression',i]]
    corr_df.corr(method='spearman')
    corr = spearmanr(corr_df)[0]
    if spearmanr(corr_df)[1] <= 0.05:
        print(i,'\t',spearmanr(corr_df)[0],'\t',spearmanr(corr_df)[1])
