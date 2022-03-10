#!/bin/bash
set -euo pipefail


#### multiAffinity - STEP2 - Uncovering the community structure  


# STEP 0. Preparing environment
## Organize files
for file in input/layers/*; do sed -i 's/,/ /g' $file ; mv "$file" "${file/.*/.gr}"; done
mkdir -p bin/Communities/src/genes; mkdir -p bin/Communities/src/networks; cp input/layers/*.gr bin/Communities/src/networks; cp output/metaDEGs/degs_names.txt bin/Communities/src/genes/input_genes.txt
rm -r -f bin/Communities/output/*; mkdir -p bin/Communities/output/tmp

## arguments to variables
Molti_modularity=$1 
Molti_Louvain=$2
pushd bin/Communities/ >& /dev/null


# 1. Defining Communities'
## Run Molti-DREAM
networks=$(ls src/networks/*.gr)
if [ $Molti_modularity = 1 ] && [ $Molti_Louvain = 0 ]; then
   ./src/MolTi-DREAM/src/molti-console -o output/tmp/communities ${networks} >& /dev/null
else
  ./src/MolTi-DREAM/src/molti-console -p ${Molti_modularity} -r ${Molti_Louvain} -o output/tmp/communities ${networks} >& /dev/null
fi

## Result check for step 1
if [[ ! -f output/tmp/communities ]] ; then
    echo -e "      ☒ error"; echo "        >> Could not run MolTi-DREAM"; exit 1
fi


# 2. Analysing gene distribution in communities
## Check genes input name
cp src/genes/input_genes.txt output/tmp/degs.txt; sed -i 's/$/;/g' output/tmp/degs.txt

## Obtain matches
for clusterid in $(cat output/tmp/communities | grep "ClusterID:" | cut -d"|" -f1 | sed "s:ClusterID\:::"); do
    (cat output/tmp/communities | sed -n -e "/ClusterID:$clusterid||/,/ClusterID*/ p" | sed -e '1d;$d' > output/tmp/cluster_${clusterid}.txt;
    sed -i '/^$/d' output/tmp/cluster_${clusterid}.txt ) &
done; wait

for clusterid in $(ls output/tmp/cluster_*.txt | cut -d"_" -f2 | cut -d"." -f1); do
    while read -r match; do
        if [[ $match = *[!\ ]* ]]; then
            sed -i "/^\"$match\";/ s/$/$clusterid/" output/tmp/degs.txt 
        fi;
    done <output/tmp/cluster_${clusterid}.txt
done; wait

## Removing small communities
sed -ri 's/.* ClusterID: (.*)/\1/' output/tmp/communities_effectif.csv


# 3. Organize output files
mv output/tmp/degs.txt output/degs_communities.txt; mv output/tmp/communities output/molti_output.txt; mv output/tmp/communities_effectif.csv output/size_communities.txt ;mkdir -p output/clusters; mv output/tmp/cluster_*.txt output/clusters/ ; rm -r -f output/tmp
popd >& /dev/null
mkdir -p output/Communities; mv bin/Communities/output/* output/Communities

echo -e "         ☑ done"