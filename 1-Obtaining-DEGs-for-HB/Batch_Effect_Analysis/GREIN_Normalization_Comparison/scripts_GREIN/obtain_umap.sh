

# 1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/scripts/equal_genes.py ## only run after downloading data
Rscript 1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/scripts_GREIN/clean_matrices.R
python 1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/scripts_GREIN/join_matrices.py
Rscript 1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/scripts_GREIN/umap_HB.Rmd

#Clean temp files
rm -f 1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/*_NT.csv
rm -f 1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/*_T.csv