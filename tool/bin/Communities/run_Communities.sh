#!/bin/bash
# STEP 0
echo '  0/2 - Preparing environment'
for file in input/layers/*; do mv "$file" "${file/.*/.gr}"; done
mkdir -p bin/Communities/src/genes; mkdir -p bin/Communities/src/networks; cp input/layers/*.gr bin/Communities/src/networks; cp output/metaDEGs/metaDEGs/degs_names.txt bin/Communities/src/genes/input_genes.txt

# arguments to variables
Molti_modularity=$1 
Molti_Louvain=$2

pushd bin/Communities/ >& /dev/null
rm -r -f output/*; mkdir -p output/tmp

# STEP 1
echo '  1/2 - Describing communities from multilayer networks'

networks=$(ls src/networks/*.gr)

src/MolTi-DREAM-master/src/molti-console -p ${Molti_modularity} -r ${Molti_Louvain} -o output/tmp/communities ${networks} >& /dev/null

# STEP 2
echo '  2/2 - Finding genes in COMM'

## check genes input name
#mv src/genes/*.txt src/genes/input_genes.txt 2>/dev/null
cp src/genes/input_genes.txt output/tmp/degs.txt; sed -i 's/$/;/g' output/tmp/degs.txt

## Obtain matches
for clusterid in $(cat output/tmp/communities | grep "ClusterID:" | cut -d"|" -f1 | sed "s:ClusterID\:::"); do
    cat output/tmp/communities | sed -n -e "/ClusterID:$clusterid||/,/ClusterID*/ p" | sed -e '1d;$d' > output/tmp/cluster_${clusterid}.txt
    sed -i '/^$/d' output/tmp/cluster_${clusterid}.txt
done


for clusterid in $(ls output/tmp/cluster_*.txt | cut -d"_" -f2 | cut -d"." -f1); do
    while read -r match; do
        if [[ $match = *[!\ ]* ]]; then
            sed -i "/^\"$match/ s/$/$clusterid,/" output/tmp/degs.txt
        fi
    done <output/tmp/cluster_${clusterid}.txt
done

sed -i 's/\,$//' output/tmp/degs.txt # remove end of line commas

## Clean result
mv output/tmp/degs.txt output/degs_communities.txt; mv output/tmp/communities output/communities.txt; rm -r -f output/tmp

popd >& /dev/null
mkdir -p output/Communities; mv bin/Communities/output/* output/Communities; rm -r bin/Communities/src/genes; rm -r bin/Communities/src/networks; rm -r bin/Communities/output
rm -r input/