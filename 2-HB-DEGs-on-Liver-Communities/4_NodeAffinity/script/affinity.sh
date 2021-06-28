for id in $(ls 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/*_PPI.gr | sed "s:2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/::" | cut -d"_" -f1)
do
   
    echo "Creating RWR matrix"
    cp 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/${id}_PPI.gr 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/tmp_PPI.txt
    Rscript 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/script/dRWR_liver.R
    mv 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/PTmatrix_tmp_PPI.txt 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/PTmatrix_${id}_PPI.txt

    # remove temp files
    rm 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/tmp_PPI.txt

    #echo "Find correlation between node affinity and ranks"
    #python HB-DEGs-on-Liver-Communities/1_PPI_Networks/scripts/Difussion_Analysis.py > 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/${id}_Difussion_Correlation.txt

done



