#!/bin/bash
set -euo pipefail


#### multiAffinity - STEP1 - Determining the metaDEGs  

# 0. Preparing environment
## Prepare directories and files
mkdir -p bin/metaDEGs/src; cp -r input/data bin/metaDEGs/src/; mkdir -p output; mkdir output/metaDEGs

## Create sample names file
ls input/data/counts/* | sed "s:input/data/counts/::" | cut -d"_" -f1 | sort -n -t E -k 2 > bin/metaDEGs/sample_names.txt 

## Create tmp and output directories
pushd bin/metaDEGs/ >& /dev/null
rm -rf src/tmp; mkdir src/tmp; mkdir src/tmp/counts; mkdir src/tmp/metadata; mkdir src/tmp/degs
rm -rf output; mkdir output; mkdir output/metaDEGs; mkdir output/normalized_counts; mkdir output/dif_exp; mkdir -p output/means

## Arguments to variables
DESeq2_padj=$1
DESeq2_LFC=$2
RRA_Score=$1
waddR_pvaladj=$1
control_id=$3


# 1. Processing input files and Obtaining DEGs list for each study
## Transform input names to number
(cd src/data/counts && ls -v | cat -n | while read n f; do mv -n "$f" "$n.txt"; done)
(cd src/data/metadata && ls -v | cat -n | while read n f; do mv -n "$f" "$n.txt"; done)

## Obtain distinct gene list
Rscript scripts/gene_list.R >& /dev/null 
for sid in $(ls src/data/counts/* | sed "s:src/data/counts/::" | cut -d"." -f1); do
  
  ( ## Check format for each datasets
    Rscript scripts/process_input.R $control_id $sid >& /dev/null;
    if [ ! -f "src/tmp/counts/${sid}_cts.txt" ]; then
        echo -e "      ☒ error"; echo "        >> Check the samples metadata labels argument"; exit 1; fi;
    name=$(sed -n "${sid}p" sample_names.txt );
    echo "$name" >> output/metaDEGs/degs_report_${sid}.txt;

    ## Obtain DEGs
    Rscript scripts/obtain_degs.R $DESeq2_padj $DESeq2_LFC $sid >> output/metaDEGs/degs_report_${sid}.txt 2> /dev/null;
    printf "\n" >> output/metaDEGs/degs_report_${sid}.txt;

    ## Obtain mean values for NT samples for each study
    python scripts/cts_to_mean.py ${sid}
  ) &
done; wait

cat output/metaDEGs/degs_report_*.txt > output/metaDEGs/degs_report.txt; rm -f output/metaDEGs/degs_report_*.txt

## Result check for DESeq
if  ! ls output/normalized_counts/1.txt > /dev/null; then
    echo -e "      ☒ error"; echo "        >> Could not run DESeq2"; exit 1
fi


# 2. Comparing distributions with paired Wasserstein tests
## Perform Wasserstein between sample pairs if > 1
files_counts=$(ls output/normalized_counts | cut -d"." -f1 | head -n 1)
if [ "$(ls output/normalized_counts | wc -l)" -gt "1" ]; then
    printf "Wasserstein test - pval:\n" > output/wasserstein.txt
    for Study1 in $(ls output/normalized_counts | cut -d"." -f1 | head -n 1); do
        for Study2 in $(ls output/normalized_counts | cut -d"." -f1); do
            if [ "$Study1" != "$Study2" ]; then
                name1=$(sed -n "${Study1}p" sample_names.txt)
                name2=$(sed -n "${Study2}p" sample_names.txt)
                printf "\n$name1 and $name2: " >> output/wasserstein.txt
                Rscript scripts/wasserstein.R $waddR_pvaladj $Study1 $Study2 >> output/wasserstein.txt 2> /dev/null
            fi; done; done; fi; rm -f -r output/means/
   
# 3. Obtaining metaDEGs
# Perform RRA 
echo "Robust DEGs:" >> output/metaDEGs/degs_report.txt
Rscript scripts/obtain_ranks.R $RRA_Score >> output/metaDEGs/degs_report.txt 2> /dev/null; rm -r -f src/tmp
[ "$(ls -A output/)" ] && : || (echo "metaDEGs processes NOT COMPLETED, please check the README.md to find a solution"; exit 1)

## Result check for RRA
if  ! ls output/metaDEGs/metaDEGs.txt > /dev/null; then
    echo -e "      ☒ error"; echo "        >> Could not perform DEGs meta-analysis"; exit 1
fi


# 4. Organize output files
popd >& /dev/null
mv bin/metaDEGs/output/metaDEGs/degs_report.txt bin/metaDEGs/output/; mv bin/metaDEGs/output/metaDEGs/metaDEGs.txt bin/metaDEGs/output/; mv bin/metaDEGs/output/metaDEGs/degs_names.txt bin/metaDEGs/output/
rm -rf bin/metaDEGs/output/metaDEGs/; cp -r bin/metaDEGs/output/* output/metaDEGs
echo -e "         ☑ done"