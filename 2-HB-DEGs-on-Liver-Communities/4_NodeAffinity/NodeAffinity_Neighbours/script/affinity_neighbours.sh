rm -r -f 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity_Neighbours/output/*


for id in $(ls 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/*_PPI.gr | sed "s:2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/::" | cut -d"_" -f1)
do
    mkdir -p 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/NodeAffinity_Neighbours/output/temp

    echo "Creating RWR matrix for ${id}"
    Rscript 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/NodeAffinity_Neighbours/script/dRWR_liver.R ${id}

    for genes in $(ls 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/PTmatrix_${id}_*.txt | sed "s:2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/PTmatrix_${id}_::" | cut -d"." -f1)
    do
        cp 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/NodeAffinity_Neighbours/output/PTmatrix_${id}_${genes}.txt 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/NodeAffinity_Neighbours/PTmatrix_tmp_PPI.txt

        echo "Find correlation between node affinity and ranks for ${genes}"
        python 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/NodeAffinity_Neighbours/script/difussion_analysis.py ${genes} > 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/NodeAffinity_Neighbours/output/temp/${id}_${genes}_Corr.txt
    done

    python 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/NodeAffinity_Neighbours/script/join_corr.py
    cp 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/NodeAffinity_Neighbours/output/temp/corr.txt 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/NodeAffinity_Neighbours/output/corr_${id}.txt
    rm -r -f 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/NodeAffinity_Neighbours/output/temp/
done

rm -r -f 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/NodeAffinity_Neighbours/PTmatrix_tmp_PPI.txt
