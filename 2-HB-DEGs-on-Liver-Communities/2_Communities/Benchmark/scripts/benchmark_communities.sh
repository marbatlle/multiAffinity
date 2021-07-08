mkdir -p 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/N1/
mkdir -p 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/N2/

for (( COUNTER=0; COUNTER<=10000; COUNTER+=500 )); do
    if [ $COUNTER != 0 ]; then
        echo ${COUNTER}
        Rscript 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/scripts/synthetic_model.R ${COUNTER}
        mv 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/edges_tmp 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/N1/${COUNTER}.gr
    fi
done

for (( COUNTER=0; COUNTER<=10000; COUNTER+=500 )); do
    if [ $COUNTER != 0 ]; then
        echo ${COUNTER}
        Rscript 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/scripts/synthetic_model.R ${COUNTER}
        mv 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/edges_tmp 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/N2/${COUNTER}.gr
    fi
done

echo N1 N2 optimal_rands num_comm avg_size_comm| { tr -d '\n'; echo; } >> 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/optimal_rands_overview.doc

for layer1 in $(ls 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/N1 | cut -d"." -f1); do
    for layer2 in $(ls 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/N2 | cut -d"." -f1); do

        echo ************************************************Processing ${layer1} and ${layer2}************************************************

        mkdir -p 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/

        for (( COUNTER=0; COUNTER<=100; COUNTER+=5 )); do
            echo Processing ${COUNTER} randomizations
            2-HB-DEGs-on-Liver-Communities/2_Communities/MolTi-DREAM-master/src/molti-console -p ${COUNTER} -o 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/${layer1}_${layer2}_clusters_${COUNTER} 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/N1/${layer1}.gr 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/N2/${layer2}.gr 
        done

        # Processing number of randomizations
        rm -f 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/output_num_randomizations.txt
        for (( COUNTER=0; COUNTER<=100; COUNTER+=5 )); do
            echo $COUNTER
        done >> 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/output_num_randomizations.txt

        # Processing number of communities
        rm -f 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/output_num_communities.txt
        for (( COUNTER=0; COUNTER<=100; COUNTER+=5 )); do
            tail -1 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/${layer1}_${layer2}_clusters_${COUNTER}_effectif.csv | cut -d":" -f2 | cut -f 1
        done >> 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/output_num_communities.txt

        # Processing number of average size
        rm -f 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/output_avg_com_size.txt
        for (( COUNTER=0; COUNTER<=100; COUNTER+=5 )); do
            cat 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/${layer1}_${layer2}_clusters_${COUNTER}_effectif.csv | cut -d":" -f2 | cut -f 2 >> 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/tmp_avg_com_size.txt
            awk '{ total += $1; count++ } END { print total/count }' 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/tmp_avg_com_size.txt | tr , .
        done >> 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/output_avg_com_size.txt

        rm -f 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/tmp_avg_com_size.txt

        # Obtaining optimal number of randomizations
        python 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/scripts/optimize_num_randomizations.py > 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/optime_randomizations.txt

        optimal_rands=$(cat 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/optime_randomizations.txt)

        # Create definitive files with optimal randomizations
        2-HB-DEGs-on-Liver-Communities/2_Communities/MolTi-DREAM-master/src/molti-console -p $optimal_rands -o 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/${layer1}_${layer2}_clusters 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/N1/${layer1}.gr 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/N2/${layer2}.gr 

        ## Creating overview file

        num_comm=$(tail -1 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/${layer1}_${layer2}_clusters_effectif.csv | cut -d":" -f2 | cut -f 1)

        cat 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/${layer1}_${layer2}_clusters_effectif.csv  | cut -d":" -f2 | cut -f 2 >> 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/tmp_avg_com_size.txt
        avg_size_comm=$(awk '{ total += $1; count++ } END { print total/count }' 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/tmp_avg_com_size.txt | tr , . )

        ## Creating new overview file
        echo ${layer1} ${layer2} ${optimal_rands} ${num_comm} ${avg_size_comm}| { tr -d '\n'; echo; } >> 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/optimal_rands_overview.doc

        rm 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/tmp_avg_com_size.txt

        rm -r 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/temp/
    done
done

# Clean intermediate files
rm 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/*_clusters
rm 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/*_effectif.csv

rm -r 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/N*