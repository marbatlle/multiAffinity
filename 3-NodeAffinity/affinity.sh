for id in $(ls 2-COMMgenes/src/networks/*_PPI.gr | sed "s:2-COMMgenes/src/networks/::" | cut -d"_" -f1)
do
    echo "Creating RWR matrix"
    mkdir -p 3-NodeAffinity/output/tmp/ ; cp 2-COMMgenes/src/networks/${id}_PPI.gr 3-NodeAffinity/output/tmp/tmp_PPI.txt
    Rscript 3-NodeAffinity/scripts/dRWR_liver.R

    echo "Find correlation between node affinity and ranks"
    echo 'Genes    Corr    Adj. p-val' > 3-NodeAffinity/output/${id}_Corr.txt
    python 3-NodeAffinity/scripts/difussion_analysis.py >> 3-NodeAffinity/output/${id}_Corr.txt

    # remove temp files
    rm -f 3-NodeAffinity/output/tmp/tmp_PPI.txt
    mv 3-NodeAffinity/output/tmp/PTmatrix_tmp_PPI.txt 3-NodeAffinity/output/PTmatrix_${id}_PPI.txt
done


mkdir -p 3-NodeAffinity/output/tmp/ ; cp 2-COMMgenes/src/networks/liver_PPI.gr 3-NodeAffinity/output/tmp/tmp_PPI.txt