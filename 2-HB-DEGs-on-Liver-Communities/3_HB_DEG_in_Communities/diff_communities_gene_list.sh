mkdir -p 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/clusters/
mkdir -p 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/output/
rm -f 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/DEG_in_clusters.txt
for clusterid in $(cat 2-HB-DEGs-on-Liver-Communities/2_Communities/liver_ppi_clusters | grep "ClusterID:" | cut -d"|" -f1 | sed "s:ClusterID\:::")
do
    cat 2-HB-DEGs-on-Liver-Communities/2_Communities/liver_ppi_clusters | sed -n -e "/ClusterID:${clusterid}||/,/ClusterID*/ p" | sed -e '1d;$d' > 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/clusters/cluster_genes.txt
    echo "ClusterID:${clusterid} 	" >> 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/DEG_in_clusters.txt
    python 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/find_genes_in_communities.py>> 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/DEG_in_clusters.txt
done

rm -r 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/clusters

sed '/^C/d' /home/mar/Documents/TFM/GitHub/HB_PublicData/2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_liver_clusters/output/DEG_in_clusters.txt > matches.csv