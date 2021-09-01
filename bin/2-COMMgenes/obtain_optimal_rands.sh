# STEP 0
echo '0/3 - Preparing environment'

rm -r -f rands_temp ; mkdir rands_temp

# STEP 1
echo '1/3 - Obtaining communities for each randomization value'

mkdir rands_temp/clusters
networks=$(ls src/networks/*.gr)
echo 'Processing base randomizations'
networks=$(ls src/networks/*.gr)
src/MolTi-DREAM-master/src/molti-console -o rands_temp/clusters/communities00 ${networks} >& /dev/null
for (( COUNTER=0; COUNTER<=20; COUNTER+=1 )); do
    echo Processing ${COUNTER} randomizations
    src/MolTi-DREAM-master/src/molti-console -p ${COUNTER} -o rands_temp/clusters/communities${COUNTER} ${networks} >& /dev/null
done

# STEP 2
echo '2/3 - Processing the data'

# Procesing number of randomizations
echo '00' >> rands_temp/output_num_randomizations.txt
for (( COUNTER=0; COUNTER<=20; COUNTER+=1 )); do
    echo $COUNTER
done >> rands_temp/output_num_randomizations.txt
# Procesing number of communities
tail -1 rands_temp/clusters/communities00_effectif.csv | cut -d":" -f2 | cut -f 1 >> rands_temp/output_num_communities.txt
for (( COUNTER=0; COUNTER<=20; COUNTER+=1 )); do
    tail -1 rands_temp/clusters/communities${COUNTER}_effectif.csv | cut -d":" -f2 | cut -f 1
done >> rands_temp/output_num_communities.txt
# Procesing number of average size
cat rands_temp/clusters/communities00_effectif.csv | cut -d":" -f2 | cut -f 2 >> rands_temp/tmp_avg_com_size.txt; awk '{ total += $1; count++ } END { print total/count }' rands_temp/tmp_avg_com_size.txt | tr , . >> rands_temp/output_avg_com_size.txt; rm -f rands_temp/tmp_avg_com_size.txt
for (( COUNTER=0; COUNTER<=20; COUNTER+=1 )); do
    cat rands_temp/clusters/communities${COUNTER}_effectif.csv | cut -d":" -f2 | cut -f 2 >> rands_temp/tmp_avg_com_size.txt
    awk '{ total += $1; count++ } END { print total/count }' rands_temp/tmp_avg_com_size.txt | tr , .
    rm -f rands_temp/tmp_avg_com_size.txt
done >> rands_temp/output_avg_com_size.txt

# STEP 3
echo '3/3 - Obtaining optimal randomizations value'

rm -r -f output_rands; mkdir output_rands
python scripts/optimize_num_randomizations.py > output_rands/optimal_randomizations.txt
python scripts/optimization_figure.py ## Create optimal randomizations figure
rm -r -f rands_temp
cat output_rands/optimal_randomizations.txt # return results

echo 'Process COMPLETED!'
