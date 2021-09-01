

echo 'STEP1 - Finding metaDEGs'
mkdir -p bin/1-metaDEGs/src; mkdir -p bin/1-metaDEGs/src/grein; cp input/data/* bin/1-metaDEGs/src/grein/
(cd bin/1-metaDEGs/; bash obtain_metaDEGs.sh)
[ "$(ls -A bin/1-metaDEGs/output/)" ] && : || (echo "metaDEGs processes NOT COMPLETED, please check the README.md to find a solution"; exit 1) #STEP1 check
rm -r output; mkdir -p output; mkdir -p output/1-metaDEGs; mv bin/1-metaDEGs/output/* output/1-metaDEGs; rm -r -f bin/1-metaDEGs/src; rm -r -f bin/1-metaDEGs/output


## Extra analysis steps
    ## 1a-Study Annotation (follow 1a-StudyAnnotation/annotation_info.md instructions to obtain plots)
    ## 1b-StudyVariability (follow 1b-StudyVariability/study_variability.sh instructions to obtain plots)


echo 'STEP2 - Analysing DEGs in network communities' #(if you you want to check optimal number randomizations, go to 2-COMMgenes/COMMgenes.md)
mkdir -p bin/2-COMMgenes/src/genes; mkdir -p bin/2-COMMgenes/src/networks; cp input/layers/*.gr bin/2-COMMgenes/src/networks; cp output/1-metaDEGs/metaDEGs/degs_names.txt bin/2-COMMgenes/src/genes/input_genes.txt
(cd bin/; bash 2-COMMgenes/obtain_COMMgenes.sh)
mkdir -p output/2-COMMgenes; mv bin/2-COMMgenes/output/* output/2-COMMgenes; rm -r bin/2-COMMgenes/src/genes; rm -r bin/2-COMMgenes/src/networks; rm -r bin/2-COMMgenes/output


echo 'STEP3 - Perform affinity study'
cp -r output/1-metaDEGs bin/3-MultiAffinity/src; cp -r input/layers/ bin/3-MultiAffinity/src
(cd bin/; bash 3-MultiAffinity/multiAffinity.sh)
rm -r bin/3-MultiAffinity/src/1-metaDEGs; rm -r bin/3-MultiAffinity/src/layers; mkdir -p output/3-MultiAffinity; mv bin/3-MultiAffinity/output/* output/3-MultiAffinity

find . -type d -empty -delete
echo 'SeqAffinity completed. Check out the output folder'