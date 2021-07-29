mkdir -p 1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp


cp 1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/GSE81928_raw_data.csv 1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/raw_data.csv
cp 1-Obtaining-DEGs-for-HB/Metadata_HB/GSE81928_metadata.csv 1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/metadata.csv

# Obtain degs and mean expression
Rscript 1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/scripts/obtain_degs.R
#python 1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/scripts/join_matrices.py
#mv 1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/study_expression.csv 1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/output/${id}.csv

# Remove temp files
#rm -f 1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp/*


# Remove temp folder
#rm -r -f 1-Obtaining-DEGs-for-HB/DEGs_HB/Study_Variability/tmp
