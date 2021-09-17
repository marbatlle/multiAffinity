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

popd >& /dev/null

echo 'STEP1 - Finding metaDEGs'
bash bin/metaDEGs/run_metaDEGs.sh

echo 'STEP2 - Perform affinity study'
bash bin/Affinity/run_Affinity.sh

echo 'STEP3 - Analysing DEGs in network communities' #(if you you want to check optimal number randomizations, go to Communities/Communities.md)
bash bin/Communities/run_Communities.sh

python bin/join_output.py
echo 'multiAffinity completed. Check out the output folder'