#!/usr/bin/env bash
pushd bin/metaDEGs/ >& /dev/null

# Step 3 - check input QC - Confounders
echo "  3/4 - Comparing distributions"
# Obtain mean values for NT samples for each study
mkdir -p output/means
for sid in $(ls output/normalized_counts | cut -d"." -f1)
do
   cp output/normalized_counts/${sid}.txt output/normalized_counts/normalized.txt
   python scripts/cts_to_mean.py
   cp output/means/mean.txt output/means/${sid}_mean.txt
done
rm -f output/normalized_counts/normalized.txt; rm -f output/means/mean.txt

touch output/wasserstein.txt
for Study1 in $(ls output/normalized_counts | cut -d"." -f1 | head -n 1)
do
    for Study2 in $(ls output/normalized_counts | cut -d"." -f1)
    do
        name1=$(sed -n "${Study1}p" sample_names.txt)
        name2=$(sed -n "${Study2}p" sample_names.txt)
        echo "$name1 and $name2" >> output/wasserstein.txt
        if [ "$Study1" != "$Study2" ]; then
            cp output/means/${Study1}_mean.txt output/means/Study1_mean.txt
            cp output/means/${Study2}_mean.txt output/means/Study2_mean.txt
            Rscript scripts/wasserstein.R $waddR_resolution $waddR_permnum > output/means/wass_out.txt 2> /dev/null
            if grep -q TRUE "output/means/wass_out.txt"; then
                name1=$(sed -n "${Study1}p" sample_names.txt)
                name2=$(sed -n "${Study2}p" sample_names.txt)
                echo "$name1 and $name2" >> output/wasserstein.txt
            fi
        fi
    done
done; rm -f -r output/means



