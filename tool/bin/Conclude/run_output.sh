#!/bin/bash
set -euo pipefail


#### multiAffinity - STEP4 - Defining the final output 

# 0. Create output report
if ls output/Affinity/Affinity_Corr.txt > /dev/null; then python bin/Conclude/output.py; fi

# 1. Create output plot if there are results
if [ ! -f output/multiAffinity_report.csv ]; 
then echo 'No significantly correlated genes' >> output/multiAffinity_report.csv
else mapfile -n 3 < output/multiAffinity_report.csv
    if ((${#MAPFILE[@]}>2)); then python bin/Conclude/plot_participation.py; fi
fi

# 2. Organize output files
cd output
rm -rf metaDEGs/normalized_counts; rm -f metaDEGs/degs_names.txt ; rm -rf Communities/clusters; rm -f Communities/degs_communities.txt ; rm -f  Affinity/part_coef.txt ; rm -f Affinity/Affinity_Corr.txt ; rm -f Affinity/*_matrix.csv; rm -r -f metaDEGs/dif_exp; rm -f metaDEGs/MetaDEGs_*.txt; rm -f Affinity/difexp.txt

echo -e "         ☑ done"