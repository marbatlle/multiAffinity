#!/bin/bash
set -euo pipefail

# Preparing environment

## prepare directories and files
mkdir -p bin/metaDEGs/src; cp -r input/data bin/metaDEGs/src/

## create sample names file
ls input/data/counts/* | sed "s:input/data/counts/::" | cut -d"_" -f1 > bin/metaDEGs/sample_names.txt | sort

## create tmp and output directories
pushd bin/metaDEGs/ >& /dev/null
rm -rf src/tmp; mkdir src/tmp; mkdir src/tmp/counts; mkdir src/tmp/metadata; mkdir src/tmp/degs
rm -rf output; mkdir output; mkdir output/metaDEGs; mkdir output/normalized_counts; mkdir output/dif_exp

##  arguments to variables
DESeq2_padj=$1
DESeq2_LFC=$2
RRA_Score=$1
waddR_pvaladj=$1
control_id=$3

echo '      - Processing input files'

# input names to number
(cd src/data/counts && ls -v | cat -n | while read n f; do mv -n "$f" "$n.txt"; done)
(cd src/data/metadata && ls -v | cat -n | while read n f; do mv -n "$f" "$n.txt"; done)

# check format for each datasets
for sid in $(ls src/data/counts/* | sed "s:src/data/counts/::" | cut -d"." -f1); do
    cp src/data/metadata/${sid}.txt src/tmp/grein_meta.txt; cp src/data/counts/${sid}.txt src/tmp/grein_cts.txt
    Rscript scripts/process_input.R $control_id >& /dev/null
    FILE=src/tmp/clean_cts.txt
    if [ -f "$FILE" ]; then
        :; else 
        echo "ERROR. It seems like we can't identify the labels. Please, change the control samples' metadata labels argument"
        rm -f src/tmp/clean_* ; rm -f src/tmp/grein_*
        exit 1; fi
    cp src/tmp/clean_cts.txt src/tmp/counts/${sid}_cts.txt; cp src/tmp/clean_meta.txt src/tmp/metadata/${sid}_meta.txt
    rm -f src/tmp/clean_* ; rm -f src/tmp/grein_*
done

echo '      - Obtaining DEGs list for each study'

for sid in $(ls src/tmp/counts/*.txt | sed "s:src/tmp/counts/::" | cut -d"_" -f1 | sort); do
    # create temp files
    cp src/tmp/counts/${sid}_cts.txt src/tmp/raw_data.csv; cp src/tmp/metadata/${sid}_meta.txt src/tmp/metadata.csv
    # obtain degs
    name=$(sed -n "${sid}p" sample_names.txt )
    echo "$name" >> output/metaDEGs/degs_report.txt
    Rscript scripts/obtain_degs.R $DESeq2_padj $DESeq2_LFC >> output/metaDEGs/degs_report.txt 2> /dev/null
    printf "\n" >> output/metaDEGs/degs_report.txt
    # move outputs to permanent location
    cp src/tmp/normalized_counts.txt output/normalized_counts/${sid}.txt; cp src/tmp/tmp_up.txt src/tmp/degs/${sid}_DEGs_up.txt; cp src/tmp/tmp_down.txt src/tmp/degs/${sid}_DEGs_down.txt; cp src/tmp/sample_difexp.txt output/dif_exp/${sid}.txt
done; wait

#cat output/metaDEGs/degs_report.txt

echo "      - Comparing distributions for batch effect"

# obtain mean values for NT samples for each study
mkdir -p output/means
for sid in $(ls output/normalized_counts | cut -d"." -f1); do
   mv output/normalized_counts/${sid}.txt output/normalized_counts/normalized.txt
   python scripts/cts_to_mean.py
   mv output/means/mean.txt output/means/${sid}_mean.txt; done

# paired Wasserstein tests
printf "Wasserstein test shows a significant difference in the distributions between:\n" > output/wasserstein.txt
for Study1 in $(ls output/normalized_counts | cut -d"." -f1 | head -n 1); do
    for Study2 in $(ls output/normalized_counts | cut -d"." -f1); do
        if [ "$Study1" != "$Study2" ]; then
            cp output/means/${Study1}_mean.txt output/means/Study1_mean.txt
            cp output/means/${Study2}_mean.txt output/means/Study2_mean.txt
            Rscript scripts/wasserstein.R $waddR_pvaladj > output/means/wass_out.txt 2> /dev/null
            if grep -q TRUE "output/means/wass_out.txt"; then
                name1=$(sed -n "${Study1}p" sample_names.txt)
                name2=$(sed -n "${Study2}p" sample_names.txt)
                printf "\n" >> output/wasserstein.txt
                echo "$name1 and $name2" >> output/wasserstein.txt; fi; fi; done; done; rm -f -r output/means

echo '      - Obtaining metaDEGs'
Rscript scripts/obtain_ranks.R $RRA_Score >& /dev/null; rm -r -f src/tmp
[ "$(ls -A output/)" ] && : || (echo "metaDEGs processes NOT COMPLETED, please check the README.md to find a solution"; exit 1)

# Closing script
popd >& /dev/null
mkdir -p output; mkdir output/metaDEGs
mv bin/metaDEGs/output/metaDEGs/degs_report.txt bin/metaDEGs/output/; mv bin/metaDEGs/output/metaDEGs/metaDEGs.txt bin/metaDEGs/output/; mv bin/metaDEGs/output/metaDEGs/degs_names.txt bin/metaDEGs/output/
rm -rf bin/metaDEGs/output/metaDEGs/; cp -r bin/metaDEGs/output/* output/metaDEGs

