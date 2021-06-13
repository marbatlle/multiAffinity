#!/bin/bash



# create temp files
mkdir 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/
#echo "** Obtaining DEGs from Sample**"
cp 1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/GSE104766_raw_data.csv 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/raw_data.csv
cp 1-Obtaining-DEGs-for-HB/Metadata_HB/GSE104766_metadata.csv 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/metadata.csv
# obtain degs
Rscript 1-Obtaining-DEGs-for-HB/Scripts_HB/obtain_degs.R
# move degs files to permanent location
cp 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/Tmp_up.csv 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/GSE104766-DEGs_up.csv
cp 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/Tmp_down.csv 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/GSE104766-DEGs_down.csv
# delete temp files
rm -r 1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/

