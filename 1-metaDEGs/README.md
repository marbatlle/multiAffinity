## part 1. metaDEGs

**Goal:** Obtaining differentially expressed genes after integrating multiple GEO RNAseq datasets for HB.

### Data Source

The GSE133039, GSE89775, GSE104766, GSE151347 and  GSE81928 gene expression count matrix and metadata were downloaded from the GREIN Interactive Navigator and added to the *src/grein/* folder:

| Reference                      | GEO ID    | Platform | Patients |
|--------------------------------|-----------|----------|----------|
| Carrillo-Reixach et al. (2020) | GSE133039 | GPL16791 | 32       |
| Ranganathan et al. (2016)      | GSE89775  | GPL16791 | 10       |
| Hooks et al. (2018)            | GSE104766 | GPL16791 | 39       |
| Wagner et al. (2020)           | GSE151347 | GPL11154 | 11       |
| Valanejad et al. (2018)        | GSE81928  | GPL16791 | 23       |

    To study additional GEO datasets, download the raw data from [GREIN](http://www.ilincs.org/apps/grein) [1], for each study, following:

    GREIN > Explore Dataset > Selected study: *your GEO series accession* 

    * **Metadata** > Download metadata
    * **Counts table** > Show counts table > Download data *(Raw and Gene level)*

    Once these have been downloaded at your terminal, add them to the folder; [src/grein](https://github.com/marbatlle/metaDEGs/tree/main/src/grein)

    *If your dataset has not been already been processed by GREIN, please, request its processing and check its progress at the Processing Console*

### Run

To obtain the DEGs, it's only needed to run:

    *bash 1-metaDEGs/obtain_metaDEGs.sh*

### Output

Once the scripts have been run, you will obtain:

* **output/metaDEGs**: files describing the genes that are found deregulated constistently in the different studies
* **output/normalized_counts**: extra files showing the normalized matrices for each study

### Citations

Mahi NA, Najafabadi MF, Pilarczyk M, Kouril M, Medvedovic M. GREIN: An Interactive Web Platform for Re-analyzing GEO RNA-seq Data. Sci Rep. 2019 May 20;9(1):7580. doi: 10.1038/s41598-019-43935-8. PMID: 31110304; PMCID: PMC6527554.

Love MI, Huber W, Anders S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biol. 2014;15(12):550. doi: 10.1186/s13059-014-0550-8. PMID: 25516281; PMCID: PMC4302049.

Kolde R, Laur S, Adler P, Vilo J. Robust rank aggregation for gene list integration and meta-analysis. Bioinformatics. 2012 Feb 15;28(4):573-80. doi: 10.1093/bioinformatics/btr709. Epub 2012 Jan 12. PMID: 22247279; PMCID: PMC3278763.
