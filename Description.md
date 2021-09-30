--------------------------------------------------------------------------------
## Pipeline steps

Here you can find a general description of the main steps of the pipeline

### 1. Obtaining metaDEGs

**Screening for DEGs**
Once the input is defined, the first step that multiAffinity carries out is normalization and differential expression analysis of each study using the DESeq2 R package. 

**Integration of expression data**
To identify the most robust genes among the different studies, the Robust Rank Aggregation (RRA) R package is used. The result is filtered out and the integrated upregulated and downregulated metaDEGs lists are saved for subsequent analysis.

### 2. Affinity Correlation

**Computing an affinity matrix**
Using a network propagation formulation, as Random Walk with Restart (RWR), allows for the execution of a diffusion process over the chosen network. To obtain a more extensive study through the analysis of multi-layer networks, multiXrank is used. This Python package enables RWR exploration on single or multi-layer networks, calculated an affinity score of all nodes in the input layers, presented as an affinity matrix.

**Correlation between DEG genes and Diffusion**
to explore the involvement of the defined DEG genes on the diffussion process, we explored the correlation between the affinity scores and expression of DEG genes. Obtaining a ranked list revealing the envolvement of each gene.

### 3. Communities Definition

**Identifying Communities**
The MolTi-DREAM software is used to perform recursive clustering and therefore detect communities in the single-layer or multi-layer networks of study.

https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6107982/

--------------------------------------------------------------------------------

## Study Case

**Obtaining metaDEGs**
The GSE133039, GSE89775, GSE104766, GSE151347 and GSE81928 gene expression count matrix and metadata were obtained from the GREIN Interactive Navigator. Each dataset was independently normalized using the DESeq2 R package’s median of rations function.

| **Author(year)**               |  **GEO**  | **Platform** | **T** |  **NT** |
|--------------------------------|:---------:|:------------:|:-----:|:-------:|
| Carrillo-Reixach et al. (2020) | GSE133039 |   GPL16791   |   32  | matched |
| Ranganathan et al. (2016)      |  GSE89775 |   GPL16791   |   10  |    3    |
| Hooks et al. (2018)            | GSE104766 |   GPL16791   |   25  | matched |
| Wagner et al. (2020)           | GSE151347 |   GPL11154   |   11  | matched |
| Valanejad et al. (2018)        |  GSE81928 |   GPL16791   |   23  |    9    |

Differential expression analysis of each dataset was carried out defining an adj p-value < 0.05 and |log fold change (FC)| > 0.5 as the screening criteria. For the GSE81928 dataset, 217 DEGs were identified, 157 for the GSE89775, 1525 for the GSE104766,4699 for the GSE133039 and 2505 for the GSE151347.
After the independent studies were used in RRA analysis, a total of 249 upregulated genes and 179 downregulated genes were identified. The top 5 upregulated genes in tumor tissue were REG3A, SST, LHX1, SHISA6, PGC while SLITRK3, FGF14-IT1, CYP2A7, MYH4 and KRT16P3 where the most significant downregulated.

**Affinity Correlation**

**Communities Definition**


--------------------------------------------------------------------------------







## Authors

--------------------------------------------------------------------------------

## Citations
Baptista A, Gonzalez A, Baudot A. Universal Multilayer Network Exploration by Random Wal with Restart. arXiv:2107.04565v1.2021 Jul 9


Mahi NA, Najafabadi MF, Pilarczyk M, Kouril M, Medvedovic M. GREIN: An Interactive Web Platform for Re-analyzing GEO RNA-seq Data. Sci Rep. 2019 May 20;9(1):7580. doi: 10.1038/s41598-019-43935-8. PMID: 31110304; PMCID: PMC6527554.

Love MI, Huber W, Anders S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biol. 2014;15(12):550. doi: 10.1186/s13059-014-0550-8. PMID: 25516281; PMCID: PMC4302049.

Kolde R, Laur S, Adler P, Vilo J. Robust rank aggregation for gene list integration and meta-analysis. Bioinformatics. 2012 Feb 15;28(4):573-80. doi: 10.1093/bioinformatics/btr709. Epub 2012 Jan 12. PMID: 22247279; PMCID: PMC3278763.

Didier G, Valdeolivas A, Baudot A. Identifying communities from multiplex biological networks by randomized optimization of modularity. F1000Res. 2018 Jul 10;7:1042. doi: 10.12688/f1000research.15486.2. PMID: 30210790; PMCID: PMC6107982.