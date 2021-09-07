echo 'STEP1 - Finding metaDEGs'
mkdir -p bin/metaDEGs/src; mkdir -p bin/metaDEGs/src/grein; cp input/data/* bin/metaDEGs/src/grein/
(cd bin/metaDEGs/; bash obtain_metaDEGs.sh)
[ "$(ls -A bin/metaDEGs/output/)" ] && : || (echo "metaDEGs processes NOT COMPLETED, please check the README.md to find a solution"; exit 1) #STEP1 check
mkdir -p output; rm -r -f output/*; mkdir -p output/metaDEGs; mv bin/metaDEGs/output/* output/metaDEGs; rm -r -f bin/metaDEGs/src; rm -r -f bin/metaDEGs/output