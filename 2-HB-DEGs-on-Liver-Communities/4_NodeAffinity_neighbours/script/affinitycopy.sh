for id in $(ls 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/*_PPI.gr | sed "s:2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/::" | cut -d"_" -f1)
do
    echo "Creating RWR matrix"
    Rscript 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity_neighbours/script/dRWR_liver.R ${id}

    for genes in $(ls 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity_neighbours/output/PTmatrix_${id}_*.txt | sed "s:2-HB-DEGs-on-Liver-Communities/4_NodeAffinity_neighbours/output/PTmatrix_${id}_::" | cut -d"." -f1)

        cp 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity_neighbours/output/PTmatrix_${id}_${genes}.txt 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity_neighbours/PTmatrix_tmp_PPI.txt


        echo "Find correlation between node affinity and ranks"
        python 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity_neighbours/script/difussion_analysis.py > 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity_neighbours/output/${id}_C${genes}_orr.txt

done
