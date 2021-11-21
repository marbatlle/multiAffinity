#!/bin/bash
set -euo pipefail

python bin/Conclude/output.py
python bin/Conclude/plot_participation.py
cd output
rm -rf metaDEGs/dif_exp
rm -rf metaDEGs/normalized_counts
rm -f metaDEGs/degs_names.txt

rm -rf Communities/clusters
rm -f Communities/degs_communities.txt

rm -f  Affinity/part_coef.txt
rm -f Affinity/difexp.txt
rm -f Affinity/Affinity_Corr.txt