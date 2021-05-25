mkdir -p 4_Add_Rand_Louvain/clusters/
mkdir -p 4_Add_Rand_Louvain/output/
rm -f 4_Add_Rand_Louvain/output/DEG_in_clusters_rand.txt
for clusterid in $(cat 4_Add_Rand_Louvain/liver_ppi_clusters_random | grep "ClusterID:" | cut -d"|" -f1 | sed "s:ClusterID\:::")
do
    cat 4_Add_Rand_Louvain/liver_ppi_clusters_random | sed -n -e "/ClusterID:${clusterid}||/,/ClusterID*/ p" | sed -e '1d;$d' > 4_Add_Rand_Louvain/clusters/cluster_genes_rand.txt
    echo "** Cluster ${clusterid} **" >> 4_Add_Rand_Louvain/output/DEG_in_clusters_rand.txt
    python 4_Add_Rand_Louvain/find_genes_in_communities.py >> 4_Add_Rand_Louvain/output/DEG_in_clusters_rand.txt
done

rm -r 4_Add_Rand_Louvain/clusters/