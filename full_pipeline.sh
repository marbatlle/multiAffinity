echo 'STEP1 - Finding metaDEGs'
mkdir -p bin/1-metaDEGs/src; mkdir -p bin/1-metaDEGs/src/grein; cp input/data/* bin/1-metaDEGs/src/grein/
(cd bin/1-metaDEGs/; bash obtain_metaDEGs.sh)
[ "$(ls -A bin/1-metaDEGs/output/)" ] && : || (echo "metaDEGs processes NOT COMPLETED, please check the README.md to find a solution"; exit 1) #STEP1 check
mkdir -p output; mkdir -p output/1-metaDEGs; mv bin/1-metaDEGs/output/* output/1-metaDEGs; rm -r -f bin/1-metaDEGs/src; rm -r -f bin/1-metaDEGs/output

#echo 'STEP2 - Analysing DEGs in network communities'
#mkdir -p bin/2-COMMgenes/src/genes; mkdir -p bin/2-COMMgenes/src/networks; cp input/layers/* bin/2-COMMgenes/src/networks; cp 


# 2-COMMgenes (if you you want to check optimal number randomizations, go to 2-COMMgenes/COMMgenes.md)
#bash 2-COMMgenes/obtain_COMMgenes.sh



# 1-metaDEGs (read 1-metaDEGs/metaDEGs_info.md to fullfill input requriements - GREIN raw data)


## Extra analysis steps
    ## 1a-Study Annotation (follow 1a-StudyAnnotation/annotation_info.md instructions to obtain plots)
    ## 1b-StudyVariability (follow 1b-StudyVariability/study_variability.sh instructions to obtain plots)



# 3-Node Affinity
#bash 3-MultiAffinity/multiAffinity.sh
