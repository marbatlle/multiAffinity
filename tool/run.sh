#!/usr/bin/env bash
set -euo pipefail
#pushd tool/ >& /dev/null

echo 'STEP1 - Finding metaDEGs'
bash bin/metaDEGs/obtain_metaDEGs.sh

echo 'STEP2 - Perform affinity study'
cp -r output/metaDEGs bin/Affinity/src; cp -r input/layers/ bin/Affinity/src
(cd bin/; bash Affinity/Affinity.sh)
rm -r bin/Affinity/src/metaDEGs; rm -r bin/Affinity/src/layers; mkdir -p output/MultiAffinity; mv bin/Affinity/output/* output/MultiAffinity

echo 'STEP3 - Analysing DEGs in network communities' #(if you you want to check optimal number randomizations, go to Communities/Communities.md)
mkdir -p bin/Communities/src/genes; mkdir -p bin/Communities/src/networks; cp input/layers/*.gr bin/Communities/src/networks; cp output/metaDEGs/metaDEGs/degs_names.txt bin/Communities/src/genes/input_genes.txt
(cd bin/; bash Communities/obtain_Communities.sh)
mkdir -p output/Communities; mv bin/Communities/output/* output/Communities; rm -r bin/Communities/src/genes; rm -r bin/Communities/src/networks; rm -r bin/Communities/output

find . -type d -empty -delete
python bin/join_output.py
echo 'multiAffinity completed. Check out the output folder'