# STEP 1
echo '  1/5 - Creating environment'
rm -r -f 3-MultiAffinity/tmp; mkdir -p 3-MultiAffinity/tmp; rm -r -f 3-MultiAffinity/src/multiplex; mkdir -p 3-MultiAffinity/src/multiplex; rm -r -f 3-MultiAffinity/output/*; mkdir -p 3-MultiAffinity/output
# add input layers to src folder
cp 3-MultiAffinity/src/layers/*.gr 3-MultiAffinity/tmp
(cd 3-MultiAffinity/tmp && ls -v | cat -n | while read n f; do mv -n "$f" "layer$n.tsv"; done)

# STEP 2
echo '  2/5 - Preparing for running multiXrank'
# create dictionary
python 3-MultiAffinity/scripts/create_dict.py > 3-MultiAffinity/tmp/len_genes.txt
# translate gene names to numbers ids
python 3-MultiAffinity/scripts/genes_to_ids.py
# add input layers to src folder
mv 3-MultiAffinity/tmp/layer*.tsv 3-MultiAffinity/src/multiplex
# add degs for seeds
cp 3-MultiAffinity/src/1-metaDEGs/metaDEGs/degs_names.txt 3-MultiAffinity/tmp
python 3-MultiAffinity/scripts/degs_to_ids.py
sed -i '/^$/d' 3-MultiAffinity/tmp/degs_ids.txt # remove empty lines
# Edit config_minimal.yml
num_layers=$(ls 3-MultiAffinity/src/multiplex | wc -l)
printf "multiplex:\n    1:\n        layers:" > 3-MultiAffinity/src/config_minimal.yml
for i in $(seq 1 $num_layers); do 
    printf "\n            - multiplex/layer$i.tsv" >> 3-MultiAffinity/src/config_minimal.yml; done

printf "\nseed:\n    seeds.txt" >> 3-MultiAffinity/src/config_minimal.yml

# STEP 3
echo '  3/5 - Running multiXrank for each deg as seed'
while IFS="" read -r p || [ -n "$p" ]
do
    seed=$p
    echo ${seed} > 3-MultiAffinity/src/seeds.txt;
    python 3-MultiAffinity/src/multiXrank.py;
    mv 3-MultiAffinity/src/output/multiplex_1.tsv 3-MultiAffinity/output/${seed}.tsv
done < 3-MultiAffinity/tmp/degs_ids.txt

# STEP 4
echo '  4/5 - Creating dRWR matrix with outputs'
python 3-MultiAffinity/scripts/create_matrix.py; rm 3-MultiAffinity/output/*.tsv

# STEP 5 
echo '  5/5 - Find correlation between node affinity and ranks'
echo 'Genes         Corr            Adj. p-val' > 3-MultiAffinity/output/Affinity_Corr.txt
python 3-MultiAffinity/scripts/difussion_analysis.py >> 3-MultiAffinity/output/Affinity_Corr.txt

# remove temp files
rm -r -f 3-MultiAffinity/tmp
