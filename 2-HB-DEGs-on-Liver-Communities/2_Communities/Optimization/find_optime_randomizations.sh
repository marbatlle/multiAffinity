for (( COUNTER=0; COUNTER<=100; COUNTER+=5 )); do
    echo $COUNTER
    /home/mar/TFM/MolTi-DREAM-master/src/molti-console -p $COUNTER -o liver_ppi_clusters_$COUNTER 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/liver_PPI.gr
done
#