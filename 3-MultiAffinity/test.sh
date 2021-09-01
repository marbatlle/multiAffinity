# Edit config_minimal.yml
num_layers=$(ls 3-MultiAffinity/src/multiplex | wc -l)
printf "multiplex:\n    1:\n        layers:" > 3-MultiAffinity/src/config_minimal.yml
for i in $(seq 1 $num_layers); do 
    printf "\n            - multiplex/layer$i.tsv" >> 3-MultiAffinity/src/config_minimal.yml; done

printf "\nseed:\n    seeds.txt" >> 3-MultiAffinity/src/config_minimal.yml
