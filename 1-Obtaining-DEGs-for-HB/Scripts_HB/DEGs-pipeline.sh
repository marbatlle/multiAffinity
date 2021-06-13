#!/bin/bash

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
    cp 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/Tmp_up.csv 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/${sid}-DEGs-up.csv
    cp 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/Tmp_down.csv 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/${sid}-DEGs-down.csv
    # delete temp files
    rm -r 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/

done