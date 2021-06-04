mkdir -p 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/clusters/
rm -f 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/DEG_in_clusters.txt
for clusterid in $(cat 2-HB-DEGs-on-Liver-Communities/2_Communities/liver_ppi_clusters | grep "ClusterID:" | cut -d"|" -f1 | sed "s:ClusterID\:::")
do
    cat 2-HB-DEGs-on-Liver-Communities/2_Communities/liver_ppi_clusters | sed -n -e "/ClusterID:${clusterid}||/,/ClusterID*/ p" | sed -e '1d;$d' > 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/clusters/cluster_genes.txt
    echo "ClusterID:${clusterid} 	" >> 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/DEG_in_clusters.txt
    python 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/find_genes_in_communities.py>> 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/DEG_in_clusters.txt
done

rm -r 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/clusters

sed '/^C/d' 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/DEG_in_clusters.txt > 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/matches.csv

python 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/join_tables.py

rm -r 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/matches.csv

