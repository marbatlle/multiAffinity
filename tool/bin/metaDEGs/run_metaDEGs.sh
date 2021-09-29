#!/usr/bin/env bash
set -euo pipefail

echo '  0/4 - Preparing environment'
## Check presence of required files
if find -- "input/data/counts" -prune -type d -empty | grep -q '^'; then echo 'Add all required input files' | exit 1;fi
if find -- "input/data/metadata" -prune -type d -empty | grep -q '^'; then echo 'Add all required input files' | exit 1;fi
if find -- "input/layers" -prune -type d -empty | grep -q '^'; then echo 'Add all required input files' | exit 1;fi
# prepare directories and files
mkdir -p bin/metaDEGs/src; mkdir -p bin/metaDEGs/src/grein; cp -r input/data/* bin/metaDEGs/src/grein/
# create sample names file
ls input/data/counts/* | sed "s:input/data/counts/::" | cut -d"_" -f1 > bin/metaDEGs/sample_names.txt

pushd bin/metaDEGs/ >& /dev/null
rm -r -f src/tmp; mkdir src/tmp; mkdir src/tmp/counts; mkdir src/tmp/metadata; mkdir src/tmp/degs
rm -r -f output; mkdir output; mkdir output/metaDEGs; mkdir output/normalized_counts
# arguments to variables
DESeq2_padj=$1 
DESeq2_LFC=$2
RRA_Score=$3
waddR_resolution=$4
waddR_permnum=$5

echo '  1/4 - Processing input files'
(cd src/grein/counts && ls -v | cat -n | while read n f; do mv -n "$f" "$n.txt"; done)
(cd src/grein/metadata && ls -v | cat -n | while read n f; do mv -n "$f" "$n.txt"; done)

for sid in $(ls src/grein/counts/* | sed "s:src/grein/counts/::" | cut -d"." -f1); do
    cp src/grein/metadata/${sid}.txt src/tmp/grein_meta.txt; cp src/grein/counts/${sid}.txt src/tmp/grein_cts.txt

    # check format input
    Rscript scripts/process_input.R >& /dev/null
    FILE=src/tmp/clean_cts.txt
    if [ -f "$FILE" ]; then
        :
    else 
        echo "Error, change the non-tumour samples' metadata labels to --> Normal"
        rm -f src/tmp/clean_* ; rm -f src/tmp/grein_*
        exit 1
    fi
    cp src/tmp/clean_cts.txt src/tmp/counts/${sid}_cts.txt; cp src/tmp/clean_meta.txt src/tmp/metadata/${sid}_meta.txt
    rm -f src/tmp/clean_* ; rm -f src/tmp/grein_*
done

## Step 1.2 - match genes
Rscript scripts/gene_list.R >& /dev/null; mv src/tmp/counts/gene_list.txt src/tmp/gene_list.txt #obtain distinct gene list
for sid in $(ls src/grein/counts/* | sed "s:src/grein/counts/::" | cut -d"." -f1)
do
    cp src/tmp/counts/${sid}_cts.txt src/tmp/cts.txt
    Rscript scripts/gene_matches.R >& /dev/null; cp src/tmp/cts.txt src/tmp/counts/${sid}_cts.txt
done
rm -f src/tmp/cts.txt; rm -f src/tmp/gene_list.txt

# Step 2 - obtain DEGs list for each study with DESeq2
echo '  2/4 - Obtaining DEGs list for each study'
for sid in $(ls src/tmp/counts/*.txt | sed "s:src/tmp/counts/::" | cut -d"_" -f1)
do
    # create temp files
    cp src/tmp/counts/${sid}_cts.txt src/tmp/raw_data.csv; cp src/tmp/metadata/${sid}_meta.txt src/tmp/metadata.csv
    # obtain degs
    echo "${sid}" >> output/metaDEGs/degs_report.txt; Rscript --slave scripts/obtain_degs.R $DESeq2_padj $DESeq2_LFC >> output/metaDEGs/degs_report.txt 2> /dev/null
    # move outputs to permanent location
    cp src/tmp/normalized_counts.txt output/normalized_counts/${sid}.txt; cp src/tmp/tmp_up.txt src/tmp/degs/${sid}_DEGs_up.txt; cp src/tmp/tmp_down.txt src/tmp/degs/${sid}_DEGs_down.txt
done
# Step 3 - check input QC - Confounders
echo "  3/4 - Comparing distributions"
# Obtain mean values for NT samples for each study
mkdir -p output/means
for sid in $(ls output/normalized_counts | cut -d"." -f1)
do
   cp output/normalized_counts/${sid}.txt output/normalized_counts/normalized.txt
   python scripts/cts_to_mean.py
   cp output/means/mean.txt output/means/${sid}_mean.txt
done
rm -f output/normalized_counts/normalized.txt; rm -f output/means/mean.txt

touch output/wasserstein.txt
for Study1 in $(ls output/normalized_counts | cut -d"." -f1 | head -n 1)
do
    for Study2 in $(ls output/normalized_counts | cut -d"." -f1)
    do
        if [ "$Study1" != "$Study2" ]; then
            cp output/means/${Study1}_mean.txt output/means/Study1_mean.txt
            cp output/means/${Study2}_mean.txt output/means/Study2_mean.txt
            Rscript scripts/wasserstein.R $waddR_resolution $waddR_permnum > output/means/wass_out.txt 2> /dev/null
            if grep -q TRUE "output/means/wass_out.txt"; then
                name1=$(sed -n "${Study1}p" sample_names.txt)
                name2=$(sed -n "${Study2}p" sample_names.txt)
                echo "$name1 and $name2" >> output/wasserstein.txt
            fi
        fi
    done
done; rm -f -r output/means


#find . -type f -size 0 -exec rm {} \; #remove empty files

echo '  4/4 - Obtaining metaDEGs'
Rscript scripts/obtain_ranks.R $RRA_Score >& /dev/null; Rscript scripts/degs_names.R  >& /dev/null;  rm -r -f src/tmp # Clean folders

# Closing script
popd >& /dev/null
[ "$(ls -A bin/metaDEGs/output/)" ] && : || (echo "metaDEGs processes NOT COMPLETED, please check the README.md to find a solution"; exit 1) #STEP1 check
mkdir -p output; rm -r -f output/*; mkdir -p output/metaDEGs; mv bin/metaDEGs/output/* output/metaDEGs; rm -r -f bin/metaDEGs/src; rm -r -f bin/metaDEGs/output, rm -f  bin/metaDEGs/sample_names.txt