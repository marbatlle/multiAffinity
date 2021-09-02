# STEP 0
echo '  0/2 - Preparing environment'
cd COMMgenes
rm -r -f output/*; mkdir -p output/tmp

# STEP 1
echo '  1/2 - Describing communities from multilayer networks'

networks=$(ls src/networks/*.gr)
num_rands=$1

if [ $# -eq 0 ]
  then
    src/MolTi-DREAM-master/src/molti-console -o output/tmp/communities ${networks} >& /dev/null
  else
    src/MolTi-DREAM-master/src/molti-console -p ${num_rands} -o output/tmp/communities ${networks} >& /dev/null
fi

# STEP 2
echo '  2/2 - Finding genes in COMM'

## check genes input name
mv src/genes/*.txt src/genes/input_genes.txt 2>/dev/null

## Obtain matches
for clusterid in $(cat output/tmp/communities | grep "ClusterID:" | cut -d"|" -f1 | sed "s:ClusterID\:::"); do
    cat output/tmp/communities | sed -n -e "/ClusterID:${clusterid}||/,/ClusterID*/ p" | sed -e '1d;$d' > output/tmp/cluster_genes.txt
    echo "ClusterID:${clusterid} 	" >> output/tmp/DEGs_in_COMM.txt
    python scripts/find_genes_COMM.py >> output/tmp/DEGs_in_COMM.txt
done

## Join table
sed '/^C/d' output/tmp/DEGs_in_COMM.txt > output/tmp/matches.csv
python scripts/join_COMM_genes.py

## Clean result
mv output/tmp/communities_genes_matches.csv output/COMMgenes.txt; mv output/tmp/top_matches.csv output/COMMgenes_topmatches.txt; mv output/tmp/communities output/communities.txt; rm -r -f output/tmp


