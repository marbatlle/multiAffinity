echo 'STEP3 - Perform affinity study'
cp -r output/1-metaDEGs bin/3-MultiAffinity/src; cp -r input/layers/ bin/3-MultiAffinity/src
(cd bin/; bash 3-MultiAffinity/multiAffinity.sh)
rm -r bin/3-MultiAffinity/src/1-metaDEGs; rm -r bin/3-MultiAffinity/src/layers
mkdir -p output/3-MultiAffinity; mv bin/3-MultiAffinity/output/* output/3-MultiAffinity; 