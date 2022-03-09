## FROM STEP 3.2. Find correlation between node affinity and ranks

import os
import pandas as pd
import numpy as np
from scipy import stats
from scipy.stats import spearmanr
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('padj', type=float)
parser.add_argument('min_nodes', type=int)
args = parser.parse_args()

#Load community genes
comm_path = 'Affinity/src/clusters/cluster_tmp.txt'
comm_df = pd.read_csv(comm_path, dtype=str, header=None)
comm_genes = comm_df[0].tolist()

#Load diferential expressions and join
path_to_files = 'Affinity/src/metaDEGs/dif_exp/'
lst_difexp = []
for filen in [x for x in os.listdir(path_to_files) if '.txt' in x]:
    lst_difexp.append(pd.read_csv(path_to_files+filen, delimiter= ","))
difexp = pd.concat(lst_difexp)
difexp = difexp.groupby(difexp.index).mean()
print(difexp)
#difexp = difexp.set_index(['Unnamed: 0'])
difexp = pd.DataFrame(difexp, columns=['log2FoldChange'])
print(difexp)
difexp.index.names = ['genes']
print(difexp)
difexp.to_csv("Affinity/output/difexp.txt",sep = ",", index=True, header=True)
difexp = difexp[difexp.index.isin(comm_genes)]

print(difexp)

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
path = 'Affinity/output/'

from sklearn.preprocessing import MinMaxScaler
scaler=MinMaxScaler(feature_range=(0,1))

#calculate spearman Rank correlation and corresponding p-value
for i in genes:
    corr_df = result[['log2FoldChange',i]]
    corr_df = corr_df.dropna()
    corr_df = corr_df[~corr_df.index.isin(genes)]
    AS_array = corr_df[[i]].to_numpy()
    mean = np.mean(AS_array)
    outlier = abs(AS_array - mean) > 1.5 * np.std(AS_array)
    outliers = AS_array[outlier].tolist()
    corr_df = corr_df[~corr_df[i].isin(outliers)]
    corr_df[i] = scaler.fit_transform(corr_df[[i]])
    export_path = os.path.join(path, i + '_matrix.csv')
    corr_df.to_csv(export_path,sep = ",", index=True, header=True)
    com_size = len(corr_df)
    rho, p = spearmanr(corr_df['log2FoldChange'], corr_df[i])
    if p < args.padj:
        if com_size >= args.min_nodes:
            print(i+','+str(rho)+','+str(p)+','+str(com_size))



