echo 'STEP1 - Finding metaDEGs'
mkdir -p bin/metaDEGs/src; mkdir -p bin/metaDEGs/src/grein; cp input/data/* bin/metaDEGs/src/grein/
(cd bin/metaDEGs/; bash obtain_metaDEGs.sh)
[ "$(ls -A bin/metaDEGs/output/)" ] && : || (echo "metaDEGs processes NOT COMPLETED, please check the README.md to find a solution"; exit 1) #STEP1 check
mkdir -p output; rm -r output/*; mkdir -p output/metaDEGs; mv bin/metaDEGs/output/* output/metaDEGs; rm -r -f bin/metaDEGs/src; rm -r -f bin/metaDEGs/output

echo 'STEP2 - Perform affinity study'
cp -r output/metaDEGs bin/MultiAffinity/src; cp -r input/layers/ bin/MultiAffinity/src
(cd bin/; bash MultiAffinity/multiAffinity.sh)
rm -r bin/MultiAffinity/src/metaDEGs; rm -r bin/MultiAffinity/src/layers; mkdir -p output/MultiAffinity; mv bin/MultiAffinity/output/* output/MultiAffinity

echo 'STEP3 - Analysing DEGs in network communities' #(if you you want to check optimal number randomizations, go to COMMgenes/COMMgenes.md)
mkdir -p bin/COMMgenes/src/genes; mkdir -p bin/COMMgenes/src/networks; cp input/layers/*.gr bin/COMMgenes/src/networks; cp output/metaDEGs/metaDEGs/degs_names.txt bin/COMMgenes/src/genes/input_genes.txt
(cd bin/; bash COMMgenes/obtain_COMMgenes.sh)
mkdir -p output/COMMgenes; mv bin/COMMgenes/output/* output/COMMgenes; rm -r bin/COMMgenes/src/genes; rm -r bin/COMMgenes/src/networks; rm -r bin/COMMgenes/output

find . -type d -empty -delete
echo 'SeqAffinity completed. Check out the output folder'