#!/bin/bash
set -euo pipefail

# Create output report
python bin/Conclude/output.py

# Create output plot
mapfile -n 2 < output/multiAffinity_report.csv
if ((${#MAPFILE[@]}>1)); then
    python bin/Conclude/plot_participation.py
fi

# Organize output files
cd output
rm -rf metaDEGs/dif_exp ; rm -rf metaDEGs/normalized_counts; rm -f metaDEGs/degs_names.txt ; rm -rf Communities/clusters; rm -f Communities/degs_communities.txt ; rm -f  Affinity/part_coef.txt ; rm -f Affinity/difexp.txt; rm -f Affinity/Affinity_Corr.txt