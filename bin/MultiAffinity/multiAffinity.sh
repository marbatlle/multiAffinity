# STEP 1
echo '  1/5 - Creating environment'
rm -r -f MultiAffinity/tmp; mkdir -p MultiAffinity/tmp; rm -r -f MultiAffinity/src/multiplex; mkdir -p MultiAffinity/src/multiplex; rm -r -f MultiAffinity/output/*; mkdir -p MultiAffinity/output
# add input layers to src folder
cp MultiAffinity/src/layers/*.gr MultiAffinity/tmp
(cd MultiAffinity/tmp && ls -v | cat -n | while read n f; do mv -n "$f" "layer$n.tsv"; done)

# STEP 2
echo '  2/5 - Preparing for running multiXrank'
# create dictionary
python MultiAffinity/scripts/create_dict.py > MultiAffinity/tmp/len_genes.txt
# translate gene names to numbers ids
python MultiAffinity/scripts/genes_to_ids.py
# add input layers to src folder
mv MultiAffinity/tmp/layer*.tsv MultiAffinity/src/multiplex
# add degs for seeds
cp MultiAffinity/src/metaDEGs/metaDEGs/degs_names.txt MultiAffinity/tmp
python MultiAffinity/scripts/degs_to_ids.py
sed -i '/^$/d' MultiAffinity/tmp/degs_ids.txt # remove empty lines
# Edit config_minimal.yml
num_layers=$(ls MultiAffinity/src/multiplex | wc -l)
printf "multiplex:\n    1:\n        layers:" > MultiAffinity/src/config_minimal.yml
for i in $(seq 1 $num_layers); do 
    printf "\n            - multiplex/layer$i.tsv" >> MultiAffinity/src/config_minimal.yml; done

printf "\nseed:\n    seeds.txt" >> MultiAffinity/src/config_minimal.yml

# STEP 3
echo '  3/5 - Running multiXrank for each deg as seed'
while IFS="" read -r p || [ -n "$p" ]
do
    seed=$p
    echo ${seed} > MultiAffinity/src/seeds.txt;
    python MultiAffinity/src/multiXrank.py;
    mv MultiAffinity/src/output/multiplex_1.tsv MultiAffinity/output/${seed}.tsv
done < MultiAffinity/tmp/degs_ids.txt

# STEP 4
echo '  4/5 - Creating dRWR matrix with outputs'
python MultiAffinity/scripts/create_matrix.py; rm MultiAffinity/output/*.tsv

# STEP 5 
echo '  5/5 - Find correlation between node affinity and ranks'
echo 'Genes         Corr            Adj. p-val' > MultiAffinity/output/Affinity_Corr.txt
python MultiAffinity/scripts/difussion_analysis.py >> MultiAffinity/output/Affinity_Corr.txt

# remove temp files
rm -r -f MultiAffinity/tmp
