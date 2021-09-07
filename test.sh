echo 'STEP1 - Finding metaDEGs'
mkdir -p bin/metaDEGs/src; mkdir -p bin/metaDEGs/src/grein; cp input/data/* bin/metaDEGs/src/grein/
(cd bin/metaDEGs/; bash obtain_metaDEGs.sh)
[ "$(ls -A bin/metaDEGs/output/)" ] && : || (echo "metaDEGs processes NOT COMPLETED, please check the README.md to find a solution"; exit 1) #STEP1 check
mkdir -p output; rm -r -f output/*; mkdir -p output/metaDEGs; mv bin/metaDEGs/output/* output/metaDEGs; rm -r -f bin/metaDEGs/src; rm -r -f bin/metaDEGs/output

echo 'STEP2 - Perform affinity study'
cp -r output/metaDEGs bin/Affinity/src; cp -r input/layers/ bin/Affinity/src
(cd bin/; bash Affinity/Affinity.sh)
rm -r bin/Affinity/src/metaDEGs; rm -r bin/Affinity/src/layers; mkdir -p output/MultiAffinity; mv bin/Affinity/output/* output/MultiAffinity
