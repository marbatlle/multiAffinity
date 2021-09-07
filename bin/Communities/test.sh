for clusterid in $(ls output/tmp/cluster_*.txt | cut -d"_" -f2 | cut -d"." -f1); do
    while read -r match; do
        if [[ $match = *[!\ ]* ]]; then
            sed -i "/^\"$match/ s/$/$clusterid,/" output/tmp/degs.txt
        fi
    done <output/tmp/cluster_${clusterid}.txt
done
