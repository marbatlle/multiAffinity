for id in $(ls 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/*_PPI.gr | sed "s:2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/::" | cut -d"_" -f1)
do
    echo "Creating RWR matrix"
    cp 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/${id}_PPI.gr 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/tmp_PPI.txt
    Rscript 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/script/dRWR_liver.R

    echo "Find correlation between node affinity and ranks"
    python 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/script/difussion_analysis.py > 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/${id}_Corr.txt

    # remove temp files
    rm -f 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/tmp_PPI.txt
    mv 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/PTmatrix_tmp_PPI.txt 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/PTmatrix_${id}_PPI.txt

done

rm -r -f 2-HB-DEGs-on-Liver-Communities/output/neighbours/*

echo "Calculating neighbour's affinity"

for id in $(ls 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/*_PPI.gr | sed "s:2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/::" | cut -d"_" -f1)
do
    mkdir -p 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/neighbours/temp

    echo "Creating RWR matrix for ${id}"
    Rscript 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/script/dRWR_liver_neighbours.R ${id}

    for genes in $(ls 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/neighbours/PTmatrix_${id}_*.txt | sed "s:2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/neighbours/PTmatrix_${id}_::" | cut -d"." -f1)
    do
        cp 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/neighbours/PTmatrix_${id}_${genes}.txt 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/neighbours/PTmatrix_tmp_PPI.txt

        echo "Find correlation between node affinity and ranks for ${genes}"
        python 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/script/difussion_analysis_neighbours.py ${genes} > 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/neighbours/temp/${id}_${genes}_Corr.txt
    done

    python 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/script/join_corr_neighbours.py
    cp 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/neighbours/temp/corr.txt 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/neighbours/corr_${id}.txt
    rm -r -f 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/neighbours/temp/
done

rm -r -f 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/neighbours/PTmatrix_tmp_PPI.txt

mkdir -p 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/neighbours/gene_matrices
mv 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/neighbours/PTmatrix_livercancer_*.txt 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/output/neighbours/gene_matrices/
