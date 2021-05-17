**Goal:** Statistical approach to HB public databases

# Scripts
## Prep_Matrices.ipynb
*inputs: (at /Originals_HB)*
**Ranganathan (2016)**
* GSE89775_hepato_norm_counts.txt
* Group inputs with the same gene symbol to avoid duplicates
* Translate gene labels with month names to original symbols
**Hooks (2018)**
* GSE104766_counts_mapped2GR38.txt
* Translate ensembl id to gene symbols using mygene
**Wagner (2020)**
* GSE151347_Raw_gene_counts_matrix.xlsx

*outputs: (at /Matrices_HB*
* Each of these matrices
* One matrix with all three datasets merged

## Obtain_Stats.ipynb
Two approaches where taken to run the stats code:
*outputs: (at /Outputs_HB)*
* Run the code for each dataset and then merge the resulting outputs (*separate_data.statistics.csv*)
* Merge the three datasets (done in previous script) and run the code for all three of them (*join_data.statistics.csv*)
