import os
import pandas as pd
import numpy as np
from scipy import stats
from scipy.stats import spearmanr
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('padj', type=float)
args = parser.parse_args()

#Load community genes
comm_path = 'Affinity/src/clusters/cluster_tmp.txt'
comm_df = pd.read_csv(comm_path, dtype=str, header=None)
comm_genes = comm_df[0].tolist()

#Load diferential expressions and join
path_to_files = 'Affinity/src/metaDEGs/dif_exp/'
lst_difexp = []
for filen in [x for x in os.listdir(path_to_files) if '.txt' in x]:
    lst_difexp.append(pd.read_csv(path_to_files+filen, delimiter= ",", usecols=['Unnamed: 0','log2FoldChange']))
difexp = pd.concat(lst_difexp, ignore_index=True)
difexp = difexp.groupby(['Unnamed: 0']).mean().reset_index()
difexp = difexp.set_index(['Unnamed: 0'])
difexp = pd.DataFrame(difexp, columns=['log2FoldChange'])
difexp.index.names = ['genes']
difexp.to_csv("Affinity/output/difexp.txt",sep = ",", index=True, header=True)
difexp = difexp[difexp.index.isin(comm_genes)]

#Load degs
degs_path = 'Affinity/src/metaDEGs/metaDEGs.txt'
degs = pd.read_csv(degs_path, index_col=0, dtype={"metaDEGs": "string", "RRA Score": float})
degs_names = degs.index.tolist()
degs_names = list(set(degs_names).intersection(set(comm_genes)))

#Load rwr matrix
mat_path = 'Affinity/output/RWR_matrix.txt'
mat = pd.read_csv(mat_path, sep='\t', index_col=0)

#Find gene matches 
mat_names = mat.index.tolist()
matches = list(set(degs_names).intersection(set(mat_names)))

# create joined matrix
mat_degs = mat.filter(matches, axis=1) # filter only DEGs in column
mat_degs.index.names = ['genes']
mat_degs = mat_degs[mat_degs.index.isin(comm_genes)]

result = difexp.merge(mat_degs, left_index=True, right_index=True)
result = result.apply(pd.to_numeric, errors='coerce')
genes = (result.columns[1:])

#calculate Spearman Rank correlation and corresponding p-value
for i in genes:
    corr_df = result[['log2FoldChange',i]]
    corr_df = corr_df.dropna()
    rho, p = spearmanr(corr_df['log2FoldChange'], corr_df[i])
    if p < args.padj:
        print(i+','+str(rho)+','+str(p))