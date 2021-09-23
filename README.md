<img src=".img/multiAffinty-logo.png" width="500">

**Study the community composition and node affinity of the DEGs obtained from one or multiple RNA-Seq studies.**

## Overview
This is a schema of the complete workflow
![Workflow](.img/multiAffinity_workflow.png)

## Input
Before running the tool, the input files need to be selected and added to your input file. These consist of:

### RNA-Seq data
This tool is designed to work seamlessly with the output created by [GREIN](http://www.ilincs.org/apps/grein/?gse=), to be more specific, the raw counts matrix and metadata table are required. 

![GREIN_tutorial](.img/tutorial_grein.png)

*If your dataset has not been already been processed by GREIN, please, request its processing and check its progress at the Processing Console*

On the other hand, if you want to use datasets not available at GEO, make sure that your files format match these requirements:

**Metadata:**
* The files should be named following: *sampleid*_metadata.csv
* Make sure metadata labels contain the word Normal

    Sample file
    "",tissue type
    GSM2177840,Normal
    GSM2177841,Normal
    GSM2177842,Tumor
    GSM2177843,Normal

**Counts Matrix:**
* The files should be named following: *sampleid*_data.csv
* Make sure counts matrix includes gene names.

    "",gene_symbol,GSM2177840,GSM2177841,GSM2177842,GSM2177843
    ENSG00000000003,TSPAN6,2076.6848,1326.8231,457.6652,598.4371
    ENSG00000000005,TNMD,0,0,0,0,0.9996
    ENSG00000000419,DPM1,321.7764,228.0737,56.0322,157.092
    ENSG00000000457,SCYL3,236.4527,176.2254,118.8114,131.656

An remember, counts matrix and metadata have to share the same identifier.


## Networks Layers
Add one network by file, with each row composed by two gene names representing an edge, as seen in the sample [data](https://github.com/marbatlle/COMMgenes/tree/main/sample_data/networks)




## Usage

Execute the run.sh script::

    bash run.sh

**Arguments**

## Pipeline steps
Here you can find a general description of the main steps of the pipeline

### 1. DEGs
Obtaining differentially expressed genes after integrating multiple GEO RNAseq datasets through a rank aggregation method.

### 2. Affinity

### 3. Communitites

## Case Study 

### Data

### Networks

* **Liver PPI layer**

    * Number of nodes: 18726
    * Number of edges: 960872

* **Metabolic layer**
    * Number of nodes: 1786
    * Number of edges: 52077




## Output Files

## Authors

## Citations
Mahi NA, Najafabadi MF, Pilarczyk M, Kouril M, Medvedovic M. GREIN: An Interactive Web Platform for Re-analyzing GEO RNA-seq Data. Sci Rep. 2019 May 20;9(1):7580. doi: 10.1038/s41598-019-43935-8. PMID: 31110304; PMCID: PMC6527554.

Love MI, Huber W, Anders S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biol. 2014;15(12):550. doi: 10.1186/s13059-014-0550-8. PMID: 25516281; PMCID: PMC4302049.

Kolde R, Laur S, Adler P, Vilo J. Robust rank aggregation for gene list integration and meta-analysis. Bioinformatics. 2012 Feb 15;28(4):573-80. doi: 10.1093/bioinformatics/btr709. Epub 2012 Jan 12. PMID: 22247279; PMCID: PMC3278763.

Didier G, Valdeolivas A, Baudot A. Identifying communities from multiplex biological networks by randomized optimization of modularity. F1000Res. 2018 Jul 10;7:1042. doi: 10.12688/f1000research.15486.2. PMID: 30210790; PMCID: PMC6107982.

![Logo](.img/logos-project.jpg)



docker run -ti --rm -v "/home/mar/Documents/TFM/GitHub/multiAffinity/input:/input" marbatlle/multiaffinity ./run.sh input