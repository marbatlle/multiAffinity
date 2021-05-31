**Goal:** Obtain and study deregulated genes for HB from public databases

# Folders

## > Matrices_HB

*Prep_Matrices.ipynb*
*inputs: (at /Originals_HB)*

*output: (at /Matrices_HB)*
One matrix with all three datasets merged

### >> Originals_HB

**Ranganathan (2016)**

* GSE89775_hepato_norm_counts.txt
* Group inputs with the same gene symbol to avoid duplicates
* Translate gene labels with month names to original symbols

**Hooks (2018)**

* GSE104766_counts_mapped2GR38.txt
* Translate ensembl id to gene symbols using mygene

**Wagner (2020)**

* GSE151347_Raw_gene_counts_matrix.xlsx

## > Metadata_HB

**GEO_metadata.R**
Obtain metadata from desired matrices *(at /Metadata_HB)*

*output: (at /Metadata_HB) -> HB_joint_METADATA.tsv*

## > DEGs_HB

**Obtain_DEG.py**
Once we have the matrix and its metadata, when running this script we will obtain:

* Statistics of all genes: t-statistic, adj. p-value and Cohen's effect size
* Filter DEG by adj p-value < 0.05 and Cohens effect size d > 0.8 (large) - num. of DEG: 227

*output: (at /DEGs_HB) : HB_db_DEG.csv*

### >> Transcript_Types

**DEGs_TranscriptType.Rmd**
*output: DEGs_non_coding.csv*

### >> ES_Visualitzation

**ES_Visualization.ipynb**

## > Distributions_HB

**distributions_test.ipynb**

* Studies EDA
* Independence t-test