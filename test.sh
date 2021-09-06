echo 'STEP2 - Perform affinity study'
cp -r output/metaDEGs bin/Affinity/src; cp -r input/layers/ bin/Affinity/src
(cd bin/; bash Affinity/Affinity.sh)
rm -r bin/Affinity/src/metaDEGs; rm -r bin/Affinity/src/layers; mkdir -p output/MultiAffinity; mv bin/Affinity/output/* output/MultiAffinity
