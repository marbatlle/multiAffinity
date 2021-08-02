import pandas as pd
import numpy as np

# only run after downloading data

GSE81928 = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE81928.csv")
GSE81928 = GSE81928.groupby('gene_symbol').mean().reset_index()
GSE81928_genes = GSE81928['gene_symbol'].tolist()

GSE89775 = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE89775.csv")
GSE89775 = GSE89775.groupby('gene_symbol').mean().reset_index()
GSE89775_genes = GSE89775['gene_symbol'].tolist()

GSE104766 = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE104766.csv")
GSE104766 = GSE104766.groupby('gene_symbol').mean().reset_index()
GSE104766_genes = GSE104766['gene_symbol'].tolist()

GSE133039 = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE133039.csv")
GSE133039 = GSE133039.groupby('gene_symbol').mean().reset_index()
GSE133039_genes = GSE133039['gene_symbol'].tolist()

GSE151347 = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE151347.csv")
GSE151347 = GSE151347.groupby('gene_symbol').mean().reset_index()
GSE151347_genes = GSE151347['gene_symbol'].tolist()


# List of repeated genes in all lists
genes = []
for x in GSE81928_genes:
  if x in GSE89775_genes:
      if x in GSE104766_genes:
          if x in GSE133039_genes:
              if x in GSE151347_genes:
                  genes.append(x)
genes = list(set(genes))

# Drop genes not in list
GSE81928_final = GSE81928[GSE81928['gene_symbol'].isin(genes)]
GSE89775_final = GSE89775[GSE89775['gene_symbol'].isin(genes)]
GSE104766_final = GSE104766[GSE104766['gene_symbol'].isin(genes)]
GSE133039_final = GSE133039[GSE133039['gene_symbol'].isin(genes)]
GSE151347_final = GSE151347[GSE151347['gene_symbol'].isin(genes)]


GSE81928_final.to_csv('1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE81928.csv', index=False)
GSE89775_final.to_csv('1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE89775.csv', index=False)
GSE104766_final.to_csv('1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE104766.csv', index=False)
GSE133039_final.to_csv('1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE133039.csv', index=False)
GSE151347_final.to_csv('1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE151347.csv', index=False)
