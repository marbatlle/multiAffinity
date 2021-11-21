#!/bin/bash

#STEP 0
echo '      - Preparing environment and data'
mkdir -p bin/Affinity/src; cp -r output/metaDEGs bin/Affinity/src; cp -r output/Communities/clusters bin/Affinity/src
cp -r input/layers/ bin/Affinity/src
pushd bin/ >& /dev/null

rm -rf Affinity/tmp; mkdir -p Affinity/tmp; rm -rf Affinity/src/multiplex; mkdir -p Affinity/src/multiplex; rm -rf Affinity/output; mkdir -p Affinity/output
cp Affinity/src/layers/* Affinity/tmp; (cd Affinity/tmp && ls -v | cat -n | while read n f; do mv -n "$f" "layer$n.tsv"; done)

# arguments to variables
multiXrank_r=$1 
multiXrank_selfloops=$2
padj=$3
communities_approach=$4


# create dictionary
python Affinity/scripts/create_dict.py > Affinity/tmp/len_genes.txt

# translate gene names to numbers ids
python Affinity/scripts/genes_to_ids.py

# add input layers to src folder
mv Affinity/tmp/layer*.tsv Affinity/src/multiplex

# add degs for seeds
cp Affinity/src/metaDEGs/degs_names.txt Affinity/tmp
python Affinity/scripts/degs_to_ids.py >& /dev/null
sed -i '/^$/d' Affinity/tmp/degs_ids.txt # remove empty lines

# Edit config_full.yml
num_layers=$(ls Affinity/src/multiplex | wc -l)
printf "seed: seeds.txt\n" > Affinity/src/config_full.yml
printf "r: $multiXrank_r\n" >> Affinity/src/config_full.yml
printf "self_loops: $multiXrank_selfloops\n" >> Affinity/src/config_full.yml
printf "multiplex:\n    1:\n        layers:" >> Affinity/src/config_full.yml
for i in $(seq 1 $num_layers); do 
    printf "\n            - multiplex/layer$i.tsv" >> Affinity/src/config_full.yml; done

# STEP 1
echo '      - Running multiXrank for each deg as seed'
while IFS="" read -r p || [ -n "$p" ]
do
    seed=$p
    echo ${seed} > Affinity/src/seeds.txt;
    python -W ignore Affinity/scripts/multiXrank.py >& /dev/null;
    mv Affinity/src/output/multiplex_1.tsv Affinity/output/${seed}.tsv
done < Affinity/tmp/degs_ids.txt

# Creating RWR matrix with outputs'
python Affinity/scripts/create_matrix.py; rm Affinity/output/*.tsv

# STEP 2
echo '      - Find correlation between node affinity and ranks'
echo 'Genes,Corr,Adj. p-val' > Affinity/output/Affinity_Corr.txt

if [ "$communities_approach" = 'full' ] ; then
    echo '      - Following full approach'
    python -W ignore Affinity/scripts/difussion_analysis.py $padj >> Affinity/output/Affinity_Corr.txt; else
    echo '      - Following communities approach'
    for cluster in $(ls Affinity/src/clusters/*.txt | cut -d"/" -f4); do
        if [[ $(wc -l Affinity/src/clusters/${cluster} | cut -d" " -f1) -le 1 ]]; then
            continue; else
            cp Affinity/src/clusters/${cluster} Affinity/src/clusters/cluster_tmp.txt
            python -W ignore Affinity/scripts/difussion_analysis_comm.py $padj >> Affinity/output/Affinity_Corr_$cluster
            rm -r Affinity/src/clusters/cluster_tmp.txt
        fi
    done
    cat Affinity/output/Affinity_Corr_*.txt >> Affinity/output/Affinity_Corr.txt
    rm -rf Affinity/output/Affinity_Corr_*.txt
fi

# STEP 3
echo '      - Calculate total degree and participation coefficient'
python Affinity/scripts/part_coefficient.py

# remove temp files
popd >& /dev/null
mkdir -p output/Affinity; mv bin/Affinity/output/* output/Affinity
rm -r -f bin/Affinity/output; rm -r -f bin/Affinity/src; rm -r -f bin/Affinity/tmp
