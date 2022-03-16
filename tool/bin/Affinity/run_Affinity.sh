#!/bin/bash
set -euo pipefail


#### multiAffinity - STEP3 - Performing the affinity study 

# 0. Preparing environment and data
mkdir -p bin/Affinity/src; cp -r output/metaDEGs bin/Affinity/src; cp -r output/Communities/clusters bin/Affinity/src
cp -r input/layers/ bin/Affinity/src

pushd bin/ >& /dev/null
rm -rf Affinity/tmp; mkdir -p Affinity/tmp; rm -rf Affinity/src/multiplex; mkdir -p Affinity/src/multiplex; rm -rf Affinity/output; mkdir -p Affinity/output
cp Affinity/src/layers/* Affinity/tmp; (cd Affinity/tmp && ls -v | cat -n | while read n f; do mv -n "$f" "layer$n.tsv"; done)

## arguments to variables
multiXrank_r=$1 
multiXrank_selfloops=$2
padj=$3
communities_approach=$4
min_nodes=$5

## Prepare degs as seeds
### remove small communities if following community approach
cp Affinity/src/metaDEGs/degs_names.txt Affinity/tmp
if [ "$communities_approach" = 'local' ] ; then
    for clusterid in $(ls Affinity/src/clusters/cluster_*.txt | cut -d"_" -f2 | cut -d"." -f1); do
        num_genes=$(cat Affinity/src/clusters/cluster_${clusterid}.txt | wc -l)
        if [ "$num_genes" -lt "$min_nodes" ]; then
            while read gene_symbol; do
                sed -i "/$gene_symbol/d" "Affinity/tmp/degs_names.txt"
                done < Affinity/src/clusters/cluster_${clusterid}.txt 
        fi; done; fi

## Create dictionary and translate gene names to numbers ids
python Affinity/scripts/dict_gene_id.py > Affinity/tmp/len_genes.txt
sed -i '/^$/d' Affinity/tmp/degs_ids.txt # remove empty lines

## Prepare files for multiXrank
### add input layers to src folder
mv Affinity/tmp/layer*.tsv Affinity/src/multiplex
### Edit config_full.yml
num_layers=$(ls Affinity/src/multiplex | wc -l)
printf "seed: seeds.txt\n" > Affinity/src/config_full.yml
printf "r: $multiXrank_r\n" >> Affinity/src/config_full.yml
printf "self_loops: $multiXrank_selfloops\n" >> Affinity/src/config_full.yml
printf "multiplex:\n    1:\n        layers:" >> Affinity/src/config_full.yml
for i in $(seq 1 $num_layers); do 
    printf "\n            - multiplex/layer$i.tsv" >> Affinity/src/config_full.yml; done


# 1. Run multiXrank
## Create function
run_multiXrank () {
  echo $1 > Affinity/src/seeds_$1.txt 
  sed "s/seeds.txt/seeds_${1}.txt/g" Affinity/src/config_full.yml > Affinity/src/config_full_${1}.yml
  python -W ignore Affinity/scripts/multiXrank.py $1 >& /dev/null 
  mv Affinity/src/output_$1/multiplex_1.tsv Affinity/output/$1.tsv
}

## Run multiXrank for each gene
max_jobs=2
declare -A cur_jobs=( ) # build an associative array w/ PIDs of jobs we started
for seed in $(cat Affinity/tmp/degs_ids.txt); do
  if (( ${#cur_jobs[@]} >= max_jobs )); then
    wait -n # wait for at least one job to exit
    # ...and then remove any jobs that aren't running from the table
    for pid in "${!cur_jobs[@]}"; do
      kill -0 "$pid" 2>/dev/null && unset cur_jobs[$pid]
    done; fi
  run_multiXrank $seed & cur_jobs[$!]=1
done; wait

## Creating RWR matrix with outputs
python Affinity/scripts/create_matrix.py; rm Affinity/output/*.tsv

## Result check for step 1
if  ! ls Affinity/output/RWR_matrix.txt > /dev/null; then
    echo -e "      ☒ error"; echo "        >> While performing the RWR analysis"; exit 1
fi


# 2. Find correlation between node affinity and ranks
if [ "$communities_approach" = 'global' ] ; then
    echo 'metaDEGs,DifExp-Aff Corr,Corr adj-p.val' > Affinity/output/Affinity_Corr.txt
    python -W ignore Affinity/scripts/difussion_analysis.py $padj >> Affinity/output/Affinity_Corr.txt 2> /dev/null; else
    echo 'metaDEGs,DifExp-Aff Corr,Corr adj-p.val,Community Size' > Affinity/output/Affinity_Corr.txt
    for cluster in $(ls Affinity/src/clusters/*.txt | cut -d"/" -f4); do
        if [[ $(wc -l Affinity/src/clusters/${cluster} | cut -d" " -f1) -le 1 ]]; then
            rm -r Affinity/src/clusters/${cluster}
        fi
    done
    if ls Affinity/src/clusters/*.txt > /dev/null
    then
        for cluster in $(ls Affinity/src/clusters/*.txt | cut -d"/" -f4); do
           cp Affinity/src/clusters/${cluster} Affinity/src/clusters/cluster_tmp.txt
           python -W ignore Affinity/scripts/difussion_analysis_comm.py $padj $min_nodes >> Affinity/output/Affinity_Corr_$cluster 2> /dev/null
           rm -r Affinity/src/clusters/cluster_tmp.txt
        done
        cat Affinity/output/Affinity_Corr_*.txt >> Affinity/output/Affinity_Corr.txt
        rm -rf Affinity/output/Affinity_Corr_*.txt
    else
        echo -e "      ☒ error"; echo "        >> WNo significant clusters, try modifying the Molti-Dream parameters"; exit 1
    fi; fi


# 3. Calculate total degree and participation coefficient
python Affinity/scripts/part_coefficient.py
if  ! ls Affinity/output/part_coef.txt > /dev/null; then
    printf "\n        error. Could not define the participation coefficient"
fi


# 4. Organize output files
popd >& /dev/null
mkdir -p output/Affinity; mv bin/Affinity/output/* output/Affinity
rm -r -f bin/Affinity/output; rm -r -f bin/Affinity/src; rm -r -f bin/Affinity/tmp

echo -e "         ☑ done"
