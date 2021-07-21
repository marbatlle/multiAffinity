**Goal:** Obtain and study deregulated genes for HB from public databases

# The input

The GSE133039, GSE89775, GSE104766, GSE151347 and  GSE81928 gene expression count matrix and metadata were downloaded from the GREIN Interactive Navigator and their formats were unified using the *Scripts_HB/clean_grein_data.R* script, if other studies need to be added in the future, the same format guidelines should be followed, and added to:

* Raw count matrix to *Matrices_HB/Originals_HB/*
* Filtered metadata to *Metadata_HB*


| Reference                      | GEO ID    | Platform | Patients |
|--------------------------------|-----------|----------|----------|
| Carrillo-Reixach et al. (2020) | GSE133039 | GPL16791 | 32       |
| Ranganathan et al. (2016)      | GSE89775  | GPL16791 | 10       |
| Hooks et al. (2018)            | GSE104766 | GPL16791 | 39       |
| Wagner et al. (2020)           | GSE151347 | GPL11154 | 11       |
| Valanejad et al. (2018)        | GSE81928  | GPL16791 | 23       |

# The scripts

To obtain the DEGs, it's only needed to run:
* *Scripts_HB/DEGs-pipeline.sh*

To better comprehend the workflow, take a look at the *Find_DEGs_Flowchart.png*

# The output

Once the script is run, the following outputs will be obtained:
* *DEGs_HB/degs_by_dataset.txt* - indicates the number of DEGs obtained in each individual GEO obtained study
* *DEGs_HB/HB_db_DEG_Downregulated.csv*
* *DEGs_HB/HB_db_DEG_Upregulated.csv*
* *DEGs_HB/HB_db_DEG.csv* - joint dataframe with up and downregulated genes

