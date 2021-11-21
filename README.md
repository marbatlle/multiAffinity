<img src=.img/multiAffinty-logo.png width=400>

<br>

## Study how gene desregulation propagates on a multilayer network
<br>

# Overview

This is the framework of the complete workflow:
<br>

![Workflow](.img/multiAffinity_workflow.png)

<br>
<br>

# Quick start 

## from Docker

    - Pull image
        docker pull marbatlle/multiAffinity
        
    - Run tool
        docker run -ti --rm -v "$(pwd)/sample_data:/tool/sample_data" marbatlle/multiaffinity  multiAffinity <ARGUMENTS>

    - Arguments e.g.
        -o output -c sample_data/sample1_data.csv,sample_data/sample2_data.csv -m sample_data/sample1_metadata.csv,sample_data/sample2_metadata.csv -n sample_data/sample_layers.csv
## from Github Packages

    - Pull image
        docker pull marbatlle/multiAffinity
        
    - Run tool
        docker run -ti --rm -v "$(pwd)/sample_data:/tool/sample_data" marbatlle/multiaffinity  multiAffinity <ARGUMENTS>

    - Arguments e.g.
        -o output -c sample_data/sample1_data.csv,sample_data/sample2_data.csv -m sample_data/sample1_metadata.csv,sample_data/sample2_metadata.csv -n sample_data/sample_layers.csv
    
<br>
<br>

# Usage
<br>

## Input
Before running the multiAffinity, the input files need to be curated to fit the tool's template. These consist of: **counts matrix**, **metadata** and **network layers**.

Respect the first two file types, the is designed to work seamlessly with the output created by [GREIN](http://www.ilincs.org/apps/grein/?gse=). This is how:

![GREIN_tutorial](.img/tutorial_grein.png)

If your desired dataset/s have not been processed by GREIN, please, request its processing and check its progress at the Processing Console. On the other hand, if you want to use datasets not available at GEO, make sure that your files format match the following requirements:

### -- Metadata
* The files should be named following -- *sampleid*_metadata.csv
* Make sure metadata labels contain the word Normal

Sample file:

    ,tissue type
    GSM2177840,Normal
    GSM2177841,Normal
    GSM2177842,Tumor
    GSM2177843,Normal

### -- Counts Matrix
* The files should be named following -- *sampleid*_data.csv
* Make sure counts matrix includes gene symbols.
* The series accession identifiers (GSM) should match the ones on the metadata file.

Sample file:

    ,gene_symbol,GSM2177840,GSM2177841,GSM2177842,GSM2177843
    ENSG00000000003,TSPAN6,2076,1326,457,598
    ENSG00000000005,TNMD,0,0,0,0,1
    ENSG00000000419,DPM1,321,228,56,157
    ENSG00000000457,SCYL3,236,176,118,131

Remember, counts matrix and metadata have to share the same *sampleid* identifier.

### -- Network Layers

The last input required is a gene-gene network consisting of one or multiple layers in which nodes represent genes and edges represent different types of associations. Note that each layer should be added as a separate file.

Sample file:

    CNBP,HNRNPAB
    CNBP,RPL10A
    CNBP,CENPN
    CNBP,RSL24D1
    CNBP,SMAP
    CNBP,FTSJ3
    CNBP,TRA2B
<br>

## Run the script

Execute the script:

    usage: multiAffinity [-h] [-a approach] -o OUTPUT_PATH  -c COUNTS_PATH 
                        -m METADATA_PATH -n NETWORK_PATH [-b padj] [-d LFC] 
                        [-e control_id] [-f multiXrank_r] [-g multiXrank_selfloops]
                        [-i Molti_modularity] [-j Molti_Louvain]

    arguments:
        -h                          show this help message and exit
        -a approach                 opt - use all genes (full) or use community structure (communities)(default)
        -o output_path              name output directory
        -c counts_path              path to counts matrix, use sep ',' (-c counts_path1,counts_path2)
        -m metadata_path            path to metadata, use sep ',' (-c metadata_path1,metadata_path2)
        -n network_path             path to network, use sep ',' (-c network_path1,network_path2)
        -b padj                     opt - sets significance value for DESeq2, RRA, Spearman's Corr (default is 0.05)
        -d LFC                      opt - defines log2FC Cutoff value for DESeq2 (default value is 1)
        -e control_id               define metadata label for the control samples (default is Normal)
        -f multiXrank_r             opt - global restart probability for multiXrank, given by float between 0 and 1 (default is 0.5)
        -g multiXrank_selfloops     opt - defines whether self loops are removed or not, takes values 0 or 1 (default is 0)
        -i Molti_modularity         opt - sets Newman modularity resolution parameter on molTI-DREAM (default is 1)
        -j Molti_Louvain            opt - switches to randomized Louvain on molTI-DREAM and sets num. of randomizations (default is 0)
<br>

## Output Files

All output files obtained in this computational study are available in the folder /output. Since there is multiple output files, for convenience, we also provide a spreadsheet file including the key results retrieved from the output files.

**Output Report:** found at *multiAffinity_report.csv*

!!UPDATE TABLE

| metaDEGs | RRA Score | Affinity Corr | Communities |
|----------|-----------|---------------|-------------|
| DHODH    | 0.0437    | 0.19237       | 493         |
| GSTZ1    | 0.02018   | 0.17259       | 1274        |
| ACADL    | 0.0027    | 0.16697       | 414         |
| OXCT1    | 0.03088   | 0.16214       | 439         |
| ACSL1    | 0.04938   | 0.11963       | 85          |
| ALAS1    | 0.01359   | 0.1159        | 1276        |
| ALDOB    | 0.00115   | 0.09933       | 71          |
| FABP2    | 0.04615   | 0.08055       | 974         |
| SLC22A12 | 0.00555   | 0.07548       | 12-47       |
| GNMT     | 0.00527   | 0.07031       | 537         |

**Multilayer Metrics Plot:** found at *output/multilayer_metrics_plot.png*

!!ADD PLOT

#### Additional results folder

**metaDEGs/**
- *degs_report.txt*: displays the number of upregulated and downregulated DEGs obtained individually from each study.
- *metaDEGs.txt*: describes all the obtained metaDEGs and the corresponding RRA Score.
- *wasserstein.txt*: remarks every pair of studies that show a significant difference between their distributions.

**Affinity**

- *Affinity_Corr.txt*: presents the Spearman's correlation value and the corresponding p-value.

**Communities**

- *communities.txt*: lays out the different communities defined by Molti-DREAM.
- *degs_communities.txt*: presents the metaDEGs obtained in the current study and the corresponding matches in the communities.

<br>

-------------------------------------------------------------------------

<br>
<img src=.img/logos-project.jpg width=500>
