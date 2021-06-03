mkdir -p 3_HB_DEG_in_liver_clusters/clusters/
mkdir -p 3_HB_DEG_in_liver_clusters/output/
rm -f 3_HB_DEG_in_liver_clusters/output/DEG_in_clusters.txt
for clusterid in $(cat 2_FindMolTiCommunities/liver_ppi_clusters | grep "ClusterID:" | cut -d"|" -f1 | sed "s:ClusterID\:::")
do
    cat 2_FindMolTiCommunities/liver_ppi_clusters | sed -n -e "/ClusterID:${clusterid}||/,/ClusterID*/ p" | sed -e '1d;$d' > 3_HB_DEG_in_liver_clusters/clusters/cluster_genes.txt
    echo "ClusterID:${clusterid} 	" >> 3_HB_DEG_in_liver_clusters/output/DEG_in_clusters.txt
    python 3_HB_DEG_in_liver_clusters/find_genes_in_communities.py >> 3_HB_DEG_in_liver_clusters/output/DEG_in_clusters.txt
done

rm -r 3_HB_DEG_in_liver_clusters/clusters