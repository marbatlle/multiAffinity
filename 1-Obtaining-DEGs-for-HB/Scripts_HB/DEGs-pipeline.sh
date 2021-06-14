#!/bin/bash

# If you start from downloaded GREIN raw matrix and metadata
# Rscript 1-Obtaining-DEGs-for-HB/Scripts_HB/clean_grein_data.R

# Obtainig DEGs lists from each study
for sid in $(ls 1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/*.csv | sed "s:1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/::" | cut -d"_" -f1)
do
    # create temp files
    mkdir 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/
    echo "** Obtaining DEGs from Sample $sid **"
    cp 1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/${sid}_raw_data.csv 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/raw_data.csv
    cp 1-Obtaining-DEGs-for-HB/Metadata_HB/${sid}_metadata.csv 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/metadata.csv
    # obtain degs
    Rscript 1-Obtaining-DEGs-for-HB/Scripts_HB/obtain_degs.R
    # move degs files to permanent location
    cp 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/Tmp_up.csv 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/${sid}_DEGs_up.csv
    cp 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/Tmp_down.csv 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/${sid}_DEGs_down.csv
    # delete temp files
    rm -r 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/
done

# Obtain ranks and aggregate
echo "** Obtain ranks and aggregate **"
Rscript 1-Obtaining-DEGs-for-HB/Scripts_HB/obtain_ranks.R 

for sid in $(ls 1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/*.csv | sed "s:1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/::" | cut -d"_" -f1)
do
    #delete temp files
    rm 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/${sid}_DEGs_down.csv
    rm 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/${sid}_DEGs_up.csv
done
