# Prepare Environmnet
mv 1-metaDEGs/output/metaDEGs/degs_names_up.txt 1a-StudyAnnotation/src/degs_names_up.txt
mv 1-metaDEGs/output/metaDEGs/degs_names_down.txt 1a-StudyAnnotation/src/degs_names_down.txt
cd 1a-StudyAnnotation/

# translate gene symbols to id (to add to David)
Rscript scripts/translate_names.R

#Upload files to https://david.abcc.ncifcrf.gov/summary.jsp -> Functional Annotation Tool