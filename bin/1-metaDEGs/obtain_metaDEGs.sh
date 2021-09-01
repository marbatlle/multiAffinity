#!/bin/bash
echo '  0/3 - Preparing environment'
Rscript scripts/packages_requirements.R >& /dev/null
rm -r -f src/tmp; mkdir src/tmp; mkdir src/tmp/counts; mkdir src/tmp/metadata; mkdir src/tmp/degs
rm -r -f output; mkdir output; mkdir output/metaDEGs; mkdir output/normalized_counts

# extra - download Filtered Metadata and Raw Counts Matrix

echo '  1/3 - Processing GREIN files'
## Step 1.1 - clean files
for sid in $(ls src/grein/*.csv | sed "s:src/grein/::" | cut -d"_" -f1 | sort | uniq)
do
    cp src/grein/${sid}_filtered_metadata.csv src/tmp/grein_meta.txt ; cp src/grein/${sid}_GeneLevel_Raw_data.csv src/tmp/grein_cts.txt
    Rscript scripts/clean_grein_input.R >& /dev/null
    FILE=src/tmp/clean_cts.txt
    if [ -f "$FILE" ]; then
        :
    else 
        echo "Sorry, there's an error :(" ; echo "  ${sid} files processed incorrectly from GREIN."
        echo "  It seems like we can't identify the labels. Please, change the non-tumour samples' metadata labels to say Normal"
        rm -f src/tmp/clean_* ; rm -f src/tmp/grein_*
        exit 1
    fi
    cp src/tmp/clean_cts.txt src/tmp/counts/${sid}_cts.txt; cp src/tmp/clean_meta.txt src/tmp/metadata/${sid}_meta.txt
    rm -f src/tmp/clean_* ; rm -f src/tmp/grein_*
done

## Step 1.2 - match genes
Rscript scripts/gene_list.R >& /dev/null; mv src/tmp/counts/gene_list.txt src/tmp/gene_list.txt #obtain distinct gene list
for sid in $(ls src/grein/*.csv | sed "s:src/grein/::" | cut -d"_" -f1 | sort | uniq)
do
    cp src/tmp/counts/${sid}_cts.txt src/tmp/cts.txt
    Rscript scripts/gene_matches.R >& /dev/null; cp src/tmp/cts.txt src/tmp/counts/${sid}_cts.txt
done
rm -f src/tmp/cts.txt; rm -f src/tmp/gene_list.txt

# Step 2 - obtain DEGs list for each study with DESeq2
echo '  2/3 - Obtaining DEGs list for each study'
for sid in $(ls src/tmp/counts/*.txt | sed "s:src/tmp/counts/::" | cut -d"_" -f1)
do
    # create temp files
    cp src/tmp/counts/${sid}_cts.txt src/tmp/raw_data.csv; cp src/tmp/metadata/${sid}_meta.txt src/tmp/metadata.csv
    # obtain degs
    echo "${sid}" >> output/metaDEGs/degs_report.txt; Rscript --slave scripts/obtain_degs.R >> output/metaDEGs/degs_report.txt 2> /dev/null
    # move outputs to permanent location
    cp src/tmp/normalized_counts.txt output/normalized_counts/${sid}.txt; cp src/tmp/tmp_up.txt src/tmp/degs/${sid}_DEGs_up.txt; cp src/tmp/tmp_down.txt src/tmp/degs/${sid}_DEGs_down.txt
done

echo '  3/3 - Obtaining metaDEGs'
Rscript scripts/obtain_ranks.R >& /dev/null; Rscript scripts/degs_names.R  >& /dev/null;  rm -r -f src/tmp # Clean folders
