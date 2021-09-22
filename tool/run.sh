#!/usr/bin/env bash
set -euo pipefail
#pushd tool/ >& /dev/null

pushd $1 >& /dev/null
# inputs
present() {
        ls "$@" >/dev/null 2>&1
}
if ! present *_data.csv && ! present *_metadata.csv && ! present *_layer.csv; then
    echo "All required inputs are not present"; exit 1; else
    mkdir layers; mkdir data; mkdir data/counts; mkdir data/metadata
    cp *_data.csv data/counts; cp *_metadata.csv data/metadata/; cp *_layer.csv layers/; rm -f *.csv
    for file in layers/*.csv; do mv "$file" "${file/.csv/.gr}"; done
fi

# setting pipeline arguments as variables
FILE=arguments
while read line; do
    name=$(echo "$line" | cut -d"=" -f1)
    export "$name=$(echo "$line" | cut -d"=" -f2)"
done < "$FILE"

popd >& /dev/null

echo 'STEP1 - Finding metaDEGs'
bash bin/metaDEGs/run_metaDEGs.sh $DESeq2_padj $DESeq2_LFC $RRA_Score $waddR_resolution $waddR_permnum

echo 'STEP2 - Perform affinity study'
bash bin/Affinity/run_Affinity.sh $multiXrank_r $multiXrank_selfloops $multiXrank_delta

echo 'STEP3 - Analysing DEGs in network communities' #(if you you want to check optimal number randomizations, go to Communities/Communities.md)
bash bin/Communities/run_Communities.sh $Molti_modularity $Molti_Louvain

python bin/join_output.py
echo 'multiAffinity completed. Check out the output folder'