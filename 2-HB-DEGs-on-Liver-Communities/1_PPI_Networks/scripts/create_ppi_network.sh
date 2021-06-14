## download human_annotated_PPIs.txt
wget -P 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/ http://iid.ophid.utoronto.ca/static/download/human_annotated_PPIs.txt.gz
gzip -d 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/human_annotated_PPIs.txt.gz

## obtain liver interactions
python 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/scripts/obtain_PPI.py

## remove human annotated PPIs file
rm 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/human_annotated_PPIs.txt

for id in $(ls 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/*.txt | sed "s:2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/::" | cut -d"_" -f1)
do
    echo "Processing and exploring $id network"
    cp 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/${id}_PPI.txt 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/tmp_PPI.txt
    python 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/scripts/network_EDA.py > 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/${id}_PPI_EDA.txt

    echo "Creating RWR matrix"
    Rscript 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/scripts/dRWR_liver.R
    cp 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/PTmatrix_tmp_PPI.txt 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/PTmatrix_${id}_PPI.txt

    # remove temp files
    rm 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/tmp_PPI.txt
    rm 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/PTmatrix_tmp_PPI.txt

    echo "Find correlation between node affinity and ranks"
    #python HB-DEGs-on-Liver-Communities/1_PPI_Networks/scripts/Difussion_Analysis.py > 2-HB-DEGs-on-Liver-Communities/1_PPI_Networks/${id}_Difussion_Correlation.txt

done



