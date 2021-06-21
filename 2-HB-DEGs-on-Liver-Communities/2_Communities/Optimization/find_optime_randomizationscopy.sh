# Procesing number of randomizations
rm -f 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/output_num_randomizations.txt
for (( COUNTER=0; COUNTER<=100; COUNTER+=5 )); do
    echo $COUNTER
done >> 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/output_num_randomizations.txt

# Procesing number of communities
rm -f 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/output_num_communities.txt
for (( COUNTER=0; COUNTER<=100; COUNTER+=5 )); do
    tail -1 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/liver_ppi_clusters_${COUNTER}_effectif.csv | cut -d":" -f2 | cut -f 1
done >> 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/output_num_communities.txt

# Procesing number of average size
rm -f 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/output_avg_com_size.txt
for (( COUNTER=0; COUNTER<=100; COUNTER+=5 )); do
    cat 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/liver_ppi_clusters_${COUNTER}_effectif.csv | cut -d":" -f2 | cut -f 2 >> 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/tmp_avg_com_size.txt
    awk '{ total += $1; count++ } END { print total/count }' 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/tmp_avg_com_size.txt | tr , .
done >> 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/output_avg_com_size.txt

rm 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/tmp_avg_com_size.txt

# Obtaining optimal number of randomizations
python 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/optimize_num_randomizations.py > 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/optime_randomizations.txt

optimal_rands=$(cat 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/optime_randomizations.txt)

rm -f ls 2-HB-DEGs-on-Liver-Communities/2_Communities/Optimization/*clusters*

# Create definitive files with optimal randomizations
2-HB-DEGs-on-Liver-Communities/2_Communities/MolTi-DREAM-master/src/molti-console -p $optimal_rands -o 2-HB-DEGs-on-Liver-Communities/2_Communities/liver_ppi_clusters 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/liver_PPI.gr

