#!/usr/bin/env bash
set -euo pipefail
#pushd tool/ >& /dev/null

echo 'STEP1 - Finding metaDEGs'
bash bin/metaDEGs/run_metaDEGs.sh

echo 'STEP2 - Perform affinity study'
bash bin/Affinity/run_Affinity.sh

echo 'STEP3 - Analysing DEGs in network communities' #(if you you want to check optimal number randomizations, go to Communities/Communities.md)
bash bin/Communities/run_Communities.sh

python bin/join_output.py
echo 'multiAffinity completed. Check out the output folder'