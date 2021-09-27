#!/usr/bin/env bash
set -euo pipefail
#pushd tool/ >& /dev/null

# Defining default values for parameters
DESeq2_padj=0.05
DESeq2_LFC=1
RRA_Score=0.05
waddR_resolution=0.001
waddR_permnum=10000
multiXrank_r=0.5
multiXrank_selfloops=0
multiXrank_delta=0.5
Molti_modularity=1
Molti_Louvain=0

# Classifying input arguments
while getopts "c:m:n:a:b:d:e:f:g:h:i:j:k:" opt; do
  case $opt in
    c) set -f
       IFS=','
       counts=($OPTARG)           ;;
    m) set -f
       IFS=','
       metadata=($OPTARG)         ;;
    n) set -f
       IFS=','
       network=($OPTARG)           ;;
    a) DESeq2_padj=($OPTARG)      ;;
    b) DESeq2_LFC=($OPTARG)       ;;
    d) RRA_Score=($OPTARG)        ;;
    e) waddR_resolution=($OPTARG) ;;
    f) waddR_permnum=($OPTARG)    ;;
    g) multiXrank_r=($OPTARG)    ;;
    h) multiXrank_selfloops=($OPTARG)    ;;
    i) multiXrank_delta=($OPTARG)    ;;
    j) Molti_modularity=($OPTARG)    ;;
    k) Molti_Louvain=($OPTARG)    ;;
  esac
done

# Defining mandatory arguments
if [ -z ${counts+x} ]; then echo "-c is obligatory"; exit 1; fi
if [ -z ${metadata+x} ]; then echo "-m is obligatory"; exit 1; fi
if [ -z ${network+x} ]; then echo "-n is obligatory"; exit 1; fi

# Creating input directories and organizing data
mkdir -p input; mkdir -p input/layers; mkdir -p input/data; mkdir -p input/data/counts; mkdir -p input/data/metadata
for i in "${counts[@]}"; do mv ${i} input/data/counts; done
for i in "${metadata[@]}"; do mv ${i} input/data/metadata; done
for i in "${network[@]}"; do mv ${i} input/layers; done

echo 'STEP1 - Finding metaDEGs'
bash bin/metaDEGs/run_metaDEGs.sh $DESeq2_padj $DESeq2_LFC $RRA_Score $waddR_resolution $waddR_permnum

echo 'STEP2 - Perform affinity study'
bash bin/Affinity/run_Affinity.sh $multiXrank_r $multiXrank_selfloops $multiXrank_delta

echo 'STEP3 - Analysing DEGs in network communities' #(if you you want to check optimal number randomizations, go to Communities/Communities.md)
bash bin/Communities/run_Communities.sh $Molti_modularity $Molti_Louvain

python bin/join_output.py
echo 'multiAffinity completed. Check out the output folder'
