import os
import pandas as pd
import numpy as np
from scipy import stats
from scipy.stats import spearmanr
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('padj', type=float)
args = parser.parse_args()

#Load diferential expressions and join
path_to_files = 'Affinity/src/metaDEGs/dif_exp/'
lst_difexp = []
for filen in [x for x in os.listdir(path_to_files) if '.txt' in x]:
    lst_difexp.append(pd.read_csv(path_to_files+filen, delimiter= ",", usecols=['Unnamed: 0','log2FoldChange']))
difexp_df = pd.concat(lst_difexp, ignore_index=True)
difexp_df = difexp_df.groupby(['Unnamed: 0']).mean().reset_index()
difexp_df = difexp_df.set_index(['Unnamed: 0'])
difexp_genes = pd.DataFrame(difexp_df, columns=['log2FoldChange'])
difexp_genes.index.names = ['genes']

difexp_genes.to_csv("Affinity/output/difexp.txt",sep = ",", index=True, header=True)

#Load degs
degs_path = 'Affinity/src/metaDEGs/metaDEGs.txt'
degs = pd.read_csv(degs_path, index_col=0, dtype={"metaDEGs": "string", "RRA Score": float})
degs_names = degs.index.tolist()

#Load rwr matrix
mat_path = 'Affinity/output/RWR_matrix.txt'
mat = pd.read_csv(mat_path, sep='\t', index_col=0)

#Find gene matches 
mat_names = mat.index.tolist()
matches = list(set(degs_names).intersection(set(mat_names)))

# create joined matrix
mat_degs = mat.filter(matches, axis=1) # filter only DEGs in column
mat_degs.index.names = ['genes']

result = difexp_genes.merge(mat_degs, left_index=True, right_index=True)
result = result.apply (pd.to_numeric, errors='coerce')

genes = (result.columns[1:])

#calculate Spearman Rank correlation and corresponding p-value
for i in genes:
    corr_df = result[['log2FoldChange',i]]
    corr_df = corr_df.dropna()
    rho, p = spearmanr(corr_df['log2FoldChange'], corr_df[i])
    if p < args.padj:
        print(i+','+str(rho)+','+str(p))