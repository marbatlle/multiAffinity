<img src=".img/multiAffinty-logo.png" width="400">

Analyse how gene desregulation propagates on a network through the study of communities and affinity correlation.
-------------------------------------------------------------------------------------------
# Overview


This is a schema of the complete workflow:
![Workflow](.img/multiAffinity_workflow.png)

-------------------------------------------------------------------------------------------

# Quick start from Github Packages

    - Pull image
        docker pull marbatlle/multiAffinity
        
    - Run tool
        docker run -ti --rm -v "$(pwd)/sample_data:/tool/sample_data" marbatlle/multiaffinity  ./multiAffinity <ARGUMENTS>

    - Arguments example
        -c sample_data/sample1_data.csv,sample_data/sample2_data.csv -m sample_data/sample1_metadata.csv,sample_data/sample2_metadata.csv -n sample_data/sample_layers.csv
    
-------------------------------------------------------------------------------------------

# Usage
### Input
Before running the tool, the input files need to be selected and added to your input file. These consist of:

This tool is designed to work seamlessly with the output created by [GREIN](http://www.ilincs.org/apps/grein/?gse=), to be more specific, the raw counts matrix and metadata table are required. 

![GREIN_tutorial](.img/tutorial_grein.png)

If your dataset has not been already been processed by GREIN, please, request its processing and check its progress at the Processing Console. On the other hand, if you want to use datasets not available at GEO, make sure that your files format match these requirements:

**> Metadata**
* The files should be named following: *sampleid*_metadata.csv
* Make sure metadata labels contain the word Normal

Sample file:

    "",tissue type
    GSM2177840,Normal
    GSM2177841,Normal
    GSM2177842,Tumor
    GSM2177843,Normal

**> Counts Matrix**
* The files should be named following: *sampleid*_data.csv
* Make sure counts matrix includes gene symbols.
* The series accession identifiers (GSM) should match the ones on the metadata file.

Sample file:

    "",gene_symbol,GSM2177840,GSM2177841,GSM2177842,GSM2177843
    ENSG00000000003,TSPAN6,2076,1326,457,598
    ENSG00000000005,TNMD,0,0,0,0,1
    ENSG00000000419,DPM1,321,228,56,157
    ENSG00000000457,SCYL3,236,176,118,131

And remember, counts matrix and metadata have to share the same identifier.

**> Network Layers**

The last input required is a gene-gene network consisting of one or multiple layers in which nodes represent genes and edges represent different types of associations. Note that each layer should be added as a separate file.

Sample file:

    CNBP HNRNPAB
    CNBP RPL10A
    CNBP CENPN
    CNBP RSL24D1
    CNBP SMAP
    CNBP FTSJ3
    CNBP TRA2B

### Run the script

Execute the script:

    ./multiAffinity [-h] -c COUNTS_PATH -m METADATA_PATH -n NETWORK_PATH
                    [-a DESeq2_padj] [-b DESeq2_LFC] [-d RRA_Score]
                    [-e waddR_pvaladj] [-f waddR_permnum] [-g multiXrank_r]
                    [-h multiXrank_selfloops] [-i multiXrank_delta]
                    [-j Molti_modularity] [-k Molti_Louvain]

Arguments:

    -h                          show this help message and exit
    -c COUNTS_PATH              path to counts matrix, single or multiple (-c COUNTS_PATH1,COUNTS_PATH2)
    -m METADATA_PATH            path to metadata, single or multiple (-c METADATA_PATH1,METADATA_PATH2)
    -n NETWORK_PATH             path to network, single or multiple (-c NETWORK_PATH1,NETWORK_PATH2)
    -a DESeq2_padj              optional - default value is 0.05
    -b DESeq2_LFC               optional - default value is 1
    -d RRA_Score                optional - default value is 0.05
    -e waddR_pvaladj            optional - default value is 0.001
    -f waddR_permnum            optional - default value is 100
    -g multiXrank_r             optional - default value is 0.5
    -h multiXrank_selfloops     optional - default value is 0
    -i multiXrank_delta         optional - default value is 0.05
    -j Molti_modularity         optional - default value is 1
    -k Molti_Louvain            optional - default value is 0

### Output Files

All output files obtained in this computational study are available in the folder /output. Since there is multiple output files, for convenience, we also provide a spreadsheet file including the key results retrieved from the output files.

**Output Report** can be found at *multiAffinity_report.csv*

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

#### Additional results folder

**metaDEGs/**
- *degs_report.txt*: displays the number of upregulated and downregulated DEGs obtained individually from each study.

        sample1
        num. of upregulated DEGs:  3094 
        num. of downregulated DEGs: 1781
        sample2
        num. of upregulated DEGs:  1400 
        num. of downregulated DEGs: 1197

- *metaDEGs.txt*: describes all the obtained metaDEGs and the corresponding RRA Score.

        "Name","Score"
        "REG3A",2.55102040816327e-05
        "SLITRK3",3.48964865519409e-05
        "SHISA6",4.09492025142811e-05
        "HS3ST4",6.53061224489795e-05
        "FGF14-IT1",7.6293497933928e-05
        "CST1",8.26530612244898e-05
        "PLSCR5",0.000110521061888034
        "LHX1",0.000146938775510204
        "FGF3",0.000172448979591837

- *wasserstein.txt*: remarks every pair of studies that show a significant difference between their distributions.

        Adj. p-val of the Wasserstein test shows a significant difference in the distributions between:
        Sample1 and Sample2

**Affinity**

- *Affinity_Corr.txt*: presents the Spearman's correlation value and the corresponding p-value.

        Genes,Corr,Adj. p-val
        XDH,-0.06684784898829361,0.005615617381127997
        PNLIPRP2,-0.050928801645525254,0.03495124365060305
        CNDP1,0.07003043487726657,0.003712767455761538
        HAO2,0.09297995096560957,0.00011521699255637543
        CYP2C8,0.0667415844192762,0.005692142448837308
        CYP3A4,0.0501046150267246,0.038009655106220744

**Communities**

- *communities.txt*: lays out the different communities defined by Molti-DREAM.

        #ClustnSee analysis export
        ClusterID:1||
        CYP11B2
        CYP11B1
        CYP21A2
        CH25H
        SRD5A3

        ClusterID:2||
        ALDH1A2

- *degs_communities.txt*: presents the metaDEGs obtained in the current study and the corresponding matches in the communities.

        "REG3A";
        "SLITRK3";
        "HS3ST4";211
        "FGF14-IT1";
        "CST1";1112


-------------------------------------------------------------------------------------------

## Authors

        - Run tool
            docker run -ti --rm -v "$(pwd)/sample_data:/tool/sample_data" marbatlle/multiaffinity  ./multiAffinity c sample_data/sample1_data.csv,sample_data/sample2_data.csv -m sample_data/sample1_metadata.csv,sample_data/sample2_metadata.csv -n sample_data/sample_layers.csv

        docker run -ti --rm -v "$(pwd)/input:/tool/input" marbatlle/multiaffinity ./multiAffinity -c input/GSE81928_GeneLevel_Raw_data.csv,input/GSE89775_GeneLevel_Raw_data.csv,input/GSE104766_GeneLevel_Raw_data.csv,input/GSE133039_GeneLevel_Raw_data.csv,input/GSE151347_GeneLevel_Raw_data.csv -m input/GSE81928_filtered_metadata.csv,input/GSE89775_filtered_metadata.csv,input/GSE104766_filtered_metadata.csv,input/GSE133039_filtered_metadata.csv,input/GSE151347_filtered_metadata.csv -n input/metabs_layers.csv,input/PPI_layers.csv

        # Temp

        ## docker hub
        -- create image
        docker build -t marbatlle/multiaffinity .
        -- push image
        docker push marbatlle/multiaffinity
        -- docker create container run image
        docker run -ti -d --rm marbatlle/multiaffinity ./multiAffinity -h

        ## github packages
        -- login
        docker login docker.pkg.github.com -u marbatlle -p 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
        -- create image
        docker build -t docker.pkg.github.com/marbatlle/multiaffinity/multiaffinity .
        -- tag image
        docker tag docker.pkg.github.com/marbatlle/multiaffinity/multiaffinity docker.pkg.github.com/marbatlle/multiaffinity/multiaffinity:0.0
        -- push image
        docker push docker.pkg.github.com/marbatlle/multiaffinity/multiaffinity
        -- find repository
        https://github.com/marbatlle/multiAffinity/packages



<img src=".img/logos-project.jpg" width="500">
