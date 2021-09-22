#!/bin/bash

# STEP 1
echo '  1/5 - Creating environment'

cp -r output/metaDEGs bin/Affinity/src; cp -r input/layers/ bin/Affinity/src
pushd bin/ >& /dev/null
rm -r -f Affinity/tmp; mkdir -p Affinity/tmp; rm -r -f Affinity/src/multiplex; mkdir -p Affinity/src/multiplex; rm -r -f Affinity/output/*; mkdir -p Affinity/output
# add input layers to src folder
cp Affinity/src/layers/*.gr Affinity/tmp
(cd Affinity/tmp && ls -v | cat -n | while read n f; do mv -n "$f" "layer$n.tsv"; done)
# arguments to variables
multiXrank_r=$1 
multiXrank_selfloops=$2
multiXrank_delta=$3

# STEP 2
echo '  2/5 - Preparing for running multiXrank'
# create dictionary
python Affinity/scripts/create_dict.py > Affinity/tmp/len_genes.txt
# translate gene names to numbers ids
python Affinity/scripts/genes_to_ids.py
# add input layers to src folder
mv Affinity/tmp/layer*.tsv Affinity/src/multiplex
# add degs for seeds
cp Affinity/src/metaDEGs/metaDEGs/degs_names.txt Affinity/tmp
python Affinity/scripts/degs_to_ids.py
sed -i '/^$/d' Affinity/tmp/degs_ids.txt # remove empty lines
# Edit config_full.yml
num_layers=$(ls Affinity/src/multiplex | wc -l)
printf "seed: seeds.txt\n" > Affinity/src/config_full.yml
printf "r: $multiXrank_r\n" >> Affinity/src/config_full.yml
printf "self_loops: $multiXrank_selfloops\n" >> Affinity/src/config_full.yml
printf "multiplex:\n    1:\n        layers:" >> Affinity/src/config_full.yml
for i in $(seq 1 $num_layers); do 
    printf "\n            - multiplex/layer$i.tsv" >> Affinity/src/config_full.yml; done
printf "\n        delta: $multiXrank_delta" >> Affinity/src/config_full.yml

# STEP 3
echo '  3/5 - Running multiXrank for each deg as seed'
while IFS="" read -r p || [ -n "$p" ]
do
    seed=$p
    echo ${seed} > Affinity/src/seeds.txt;
    python Affinity/src/multiXrank.py;
    mv Affinity/src/output/multiplex_1.tsv Affinity/output/${seed}.tsv
done < Affinity/tmp/degs_ids.txt

# STEP 4
echo '  4/5 - Creating dRWR matrix with outputs'
python Affinity/scripts/create_matrix.py; rm Affinity/output/*.tsv

# STEP 5 
echo '  5/5 - Find correlation between node affinity and ranks'
echo 'Genes,Corr,Adj. p-val' > Affinity/output/Affinity_Corr.txt
python Affinity/scripts/difussion_analysis.py >> Affinity/output/Affinity_Corr.txt

# remove temp files
rm -r -f Affinity/tmp
rm -f Affinity/src/multiplex/*.tsv

popd >& /dev/null
rm -r bin/Affinity/src/metaDEGs; rm -r bin/Affinity/src/layers; mkdir -p output/MultiAffinity; mv bin/Affinity/output/* output/MultiAffinity; rm -f Affinity/src/seeds.txt; rm -f Affinity/src/config_full.yml
find . -type d -empty -delete