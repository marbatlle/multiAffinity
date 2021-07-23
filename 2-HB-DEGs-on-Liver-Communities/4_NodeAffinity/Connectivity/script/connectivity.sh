#rm -r -f 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/Connectivity/output/*

for id in $(ls 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/*_PPI.gr | sed "s:2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/::" | cut -d"_" -f1)
do
    #Rscript 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/Connectivity/script/connectivity.R ${id} > 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/Connectivity/output/connectivity_${id}.txt
done
