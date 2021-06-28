for net_id in $(ls 2-HB-DEGs-on-Liver-Communities/2_Communities/*.csv | sed "s:2-HB-DEGs-on-Liver-Communities/2_Communities/::" | sed 's/_effectif.csv$//')
do
    mkdir -p 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/clusters/
    rm -f 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/DEG_in_clusters.txt

    # Obtain matches
    for clusterid in $(cat 2-HB-DEGs-on-Liver-Communities/2_Communities/${net_id} | grep "ClusterID:" | cut -d"|" -f1 | sed "s:ClusterID\:::")
    do
        cat 2-HB-DEGs-on-Liver-Communities/2_Communities/${net_id} | sed -n -e "/ClusterID:${clusterid}||/,/ClusterID*/ p" | sed -e '1d;$d' > 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/clusters/cluster_genes.txt
        echo "ClusterID:${clusterid} 	" >> 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/output/DEG_in_${net_id}.txt
        python 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/script/find_genes_in_communities.py>> 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/output/DEG_in_${net_id}.txt
    done

    mv 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/output/matches_list.txt 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/output/${net_id}_matches.txt #rename matches file
    
    # Join table
    sed '/^C/d' 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/output/DEG_in_${net_id}.txt > 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/matches.csv
    cp 2-HB-DEGs-on-Liver-Communities/2_Communities/${net_id}_effectif.csv 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/temp_effectif.csv
    python 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/script/join_tables.py

    # Clean folder
    rm -r 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/clusters
    rm -r 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/matches.csv
    rm 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/temp_effectif.csv
    mv 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/communities_genes_matches.csv 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/output/${net_id}_matches.csv
    mv 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/top_matches.csv 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/output/${net_id}_top_matches.csv
done


