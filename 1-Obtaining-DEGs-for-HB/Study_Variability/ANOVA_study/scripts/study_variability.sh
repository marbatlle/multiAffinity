mkdir -p 1-Obtaining-DEGs-for-HB/Study_Variability/ANOVA_study/tmp

for id in $(ls 1-Obtaining-DEGs-for-HB/Metadata_HB/*_metadata.csv | sed "s:1-Obtaining-DEGs-for-HB/Metadata_HB/::" | cut -d"_" -f1)
do
    # Create temp files
    cp 1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/${id}_raw_data.csv 1-Obtaining-DEGs-for-HB/Study_Variability/ANOVA_study/tmp/raw_data.csv
    cp 1-Obtaining-DEGs-for-HB/Metadata_HB/${id}_metadata.csv 1-Obtaining-DEGs-for-HB/Study_Variability/ANOVA_study/tmp/metadata.csv

    # Obtain degs and mean expression
    Rscript 1-Obtaining-DEGs-for-HB/Study_Variability/ANOVA_study/scripts/obtain_degs.R
    python 1-Obtaining-DEGs-for-HB/Study_Variability/ANOVA_study/scripts/join_matrices.py
    mv 1-Obtaining-DEGs-for-HB/Study_Variability/ANOVA_study/tmp/study_expression.csv 1-Obtaining-DEGs-for-HB/Study_Variability/ANOVA_study/output/${id}.csv

    # Remove temp files
    rm -f 1-Obtaining-DEGs-for-HB/Study_Variability/ANOVA_study/tmp/*
done

# Remove temp folder
rm -r -f 1-Obtaining-DEGs-for-HB/Study_Variability/ANOVA_study/tmp


