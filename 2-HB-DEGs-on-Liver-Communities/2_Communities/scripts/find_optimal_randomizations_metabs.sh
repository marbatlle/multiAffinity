for layer in $(ls 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/*PPI.gr | sed "s:2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/::" | cut -d"_" -f1)
do    
    echo ** Processing ${layer}**
    for (( COUNTER=0; COUNTER<=100; COUNTER+=5 )); do
        echo Processing ${COUNTER} randomizations
        2-HB-DEGs-on-Liver-Communities/2_Communities/MolTi-DREAM-master/src/molti-console -p ${COUNTER} -o 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/${layer}_clusters_${COUNTER}_metab 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/${layer}_PPI.gr 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/Recon3D_metabolites.gr
    done

    # Procesing number of randomizations
    rm -f 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/output_num_randomizations.txt
    for (( COUNTER=0; COUNTER<=100; COUNTER+=5 )); do
        echo $COUNTER
    done >> 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/output_num_randomizations.txt

    # Procesing number of communities
    rm -f 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/output_num_communities.txt
    for (( COUNTER=0; COUNTER<=100; COUNTER+=5 )); do
        tail -1 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/${layer}_clusters_${COUNTER}_metab_effectif.csv | cut -d":" -f2 | cut -f 1
    done >> 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/output_num_communities.txt

    # Procesing number of average size
    rm -f 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/output_avg_com_size.txt
    for (( COUNTER=0; COUNTER<=100; COUNTER+=5 )); do
        cat 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/${layer}_clusters_${COUNTER}_metab_effectif.csv | cut -d":" -f2 | cut -f 2 >> 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/tmp_avg_com_size.txt
        awk '{ total += $1; count++ } END { print total/count }' 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/tmp_avg_com_size.txt | tr , .
    done >> 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/output_avg_com_size.txt

    rm 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/tmp_avg_com_size.txt

    # Obtaining optimal number of randomizations
    python 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/optimize_num_randomizations.py > 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/optime_randomizations.txt

    optimal_rands=$(cat 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/optime_randomizations.txt)

    ## Create optimal randomizations figure
    python 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/optimization_figure.py
    mv 2-HB-DEGs-on-Liver-Communities/2_Communities/output/optimization_figure.png 2-HB-DEGs-on-Liver-Communities/2_Communities/output/optimization_figure_${layer}_metab.png

    # Create definitive files with optimal randomizations
    2-HB-DEGs-on-Liver-Communities/2_Communities/MolTi-DREAM-master/src/molti-console -p $optimal_rands -o 2-HB-DEGs-on-Liver-Communities/2_Communities/${layer}_clusters_metab 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/${layer}_PPI.gr 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/${layer}_PPI.gr 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/Recon3D_metabolites.gr

    ## Creating overview file
    echo optimal number of randomizations for ${layer}: ${optimal_rands} >> 2-HB-DEGs-on-Liver-Communities/2_Communities/output/optimal_rands_overview_metab.doc # number of randomizations

    echo number of communities: >> 2-HB-DEGs-on-Liver-Communities/2_Communities/output/optimal_rands_overview_metab.doc
    tail -1 2-HB-DEGs-on-Liver-Communities/2_Communities/${layer}_clusters_metab_effectif.csv | cut -d":" -f2 | cut -f 1 >> 2-HB-DEGs-on-Liver-Communities/2_Communities/output/optimal_rands_overview_metab.doc # number of communities

    echo average size of communities: >> 2-HB-DEGs-on-Liver-Communities/2_Communities/output/optimal_rands_overview_metab.doc
    cat 2-HB-DEGs-on-Liver-Communities/2_Communities/${layer}_clusters_metab_effectif.csv | cut -d":" -f2 | cut -f 2 >> 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/tmp_avg_com_size.txt
    awk '{ total += $1; count++ } END { print total/count }' 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/tmp_avg_com_size.txt | tr , . >> 2-HB-DEGs-on-Liver-Communities/2_Communities/output/optimal_rands_overview_metab.doc # average size of communities


    # Clean
    rm 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/*.txt
    rm -f ls 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/*clusters*

done

mv 2-HB-DEGs-on-Liver-Communities/2_Communities/output/optimal_rands_overview_metab.doc 2-HB-DEGs-on-Liver-Communities/2_Communities/output/optimal_rands_overview_metab.txt
