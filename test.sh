echo 'STEP1 - Finding metaDEGs'
mkdir -p bin/metaDEGs/src; mkdir -p bin/metaDEGs/src/grein; cp input/data/* bin/metaDEGs/src/grein/
(cd bin/metaDEGs/; bash obtain_metaDEGs.sh)