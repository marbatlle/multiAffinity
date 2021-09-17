![Logo](.img/multiAffinty-logo.png)






## Introduction
From GEO counts matrix to node affinity and communities analysis


## Workflow overview
This is a schema of the complete workflow
![Workflow](.img/multiAffinity_workflow.png)

## Authors

## Input Files

### Data
Consists of the resulting raw RNA-seq outputs from the desired studies. For this tool, the counts matrix and metadata table is required. If using public available datasets from GEO, we recommend the use of [GREIN](http://www.ilincs.org/apps/grein/) to easily match our format. Otherwise, check the [sample_data](tool/input/sample_data). 

Make sure that:
* both files, counts matrix and metadata share the same identifier.
* Metadata labels contain the word Normal
* Counts matrix includes gene names.

**Counts Matrix:**

**Metadata:**

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

## Citations
Mahi NA, Najafabadi MF, Pilarczyk M, Kouril M, Medvedovic M. GREIN: An Interactive Web Platform for Re-analyzing GEO RNA-seq Data. Sci Rep. 2019 May 20;9(1):7580. doi: 10.1038/s41598-019-43935-8. PMID: 31110304; PMCID: PMC6527554.

Love MI, Huber W, Anders S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biol. 2014;15(12):550. doi: 10.1186/s13059-014-0550-8. PMID: 25516281; PMCID: PMC4302049.

Kolde R, Laur S, Adler P, Vilo J. Robust rank aggregation for gene list integration and meta-analysis. Bioinformatics. 2012 Feb 15;28(4):573-80. doi: 10.1093/bioinformatics/btr709. Epub 2012 Jan 12. PMID: 22247279; PMCID: PMC3278763.

Didier G, Valdeolivas A, Baudot A. Identifying communities from multiplex biological networks by randomized optimization of modularity. F1000Res. 2018 Jul 10;7:1042. doi: 10.12688/f1000research.15486.2. PMID: 30210790; PMCID: PMC6107982.

![Logo](.img/logos-project.jpg)



docker run -t -i '/home/mar/Documents/TFM/GitHub/multiAffinity/input:/input' marbatlle/multiaffinity ./run.sh /input

docker run --ti -v "/home/mar/Documents/TFM/GitHub/multiAffinity/input:/input" run marbatlle/multiaffinity ./run.sh /input


docker run --mount source=/home/mar/Documents/TFM/GitHub/multiAffinity/input,destination=/input marbatlle/multiaffinity ./run.sh /input


docker run -it --mount source=/home/mar/Documents/TFM/GitHub/multiAffinity/input,destination=/input ubuntu


docker run -ti -v "/home/mar/Documents/TFM/GitHub/multiAffinity/input:/input" marbatlle/multiaffinity /bin/bash

docker run -ti --rm -v "/home/mar/Documents/TFM/GitHub/multiAffinity/input:/input" marbatlle/multiaffinity /bin/bash

good:

docker run -ti --rm -v "/home/mar/Documents/TFM/GitHub/multiAffinity/input:/input" marbatlle/multiaffinity /bin/bash