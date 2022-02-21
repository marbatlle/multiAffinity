<br>

![Logo](img/multiaffinity-logo.png)

<br>

Study how gene dysregulation propagates on a (multilayer) network, following the approach detailed in this this [video](https://www.youtube.com/watch?v=1tcwczu47aI&t). This is the simplified framework of this bioinformatics analysis:
<br>

![Workflow](img/multiAffinity_workflow.png)

<br>

# 1. Quick start 

### from Docker

    - Pull image
        docker pull marbatlle/multiAffinity
        
    - Run tool
        docker run -ti -v "$(pwd)/sample_data:/tool/sample_data" -v "$(pwd)/output:/tool/output" marbatlle/multiaffinity multiaffinity <FILES> <OPTIONS>
        
    - Files e.g.
        -o result -c sample_data/sample1_data.csv,sample_data/sample2_data.csv -m sample_data/sample1_metadata.csv,sample_data/sample2_metadata.csv
        
### from Github

    - Clone repository
        git clone https://github.com/marbatlle/multiAffinity
        
    - Activate environment
        conda env create --name multiaffinity --file environment.yaml
        conda activate multiaffinity
    
    - Run tool 
        bash tool/multiaffinity <FILES> <OPTIONS>
    
    - Files e.g.
        -o result -c sample_data/sample1_data.csv,sample_data/sample2_data.csv -m sample_data/sample1_metadata.csv,sample_data/sample2_metadata.csv
<br>

# 2. Usage
## 2.1. Input
Before running the multiAffinity, the input files need to be curated to fit the tool's template, consist of: **counts matrix** and **metadata**. These files can be obtained from [GREIN](http://www.ilincs.org/apps/grein/?gse=) or from other sources.

### Obtain inputs from GREIN
This workflow is designed to work seamlessly with the output created by [GREIN](http://www.ilincs.org/apps/grein/?gse=). This is how:

![GREIN_tutorial](img/tutorial_grein.png)

### Obtain inputs from other sources
If your desired dataset/s have not been processed by GREIN, please, request its processing and check its progress at the Processing Console. On the other hand, if you want to use datasets not available at GEO, make sure that your files format match the following requirements, and remember, counts matrix and metadata have to share the same *sampleid* identifier.

    *Counts Matrices*
        - The files must be named following -- sampleid_data.csv
        - Make sure counts matrix include the gene symbols.
        - The series accession identifiers (GSM) must match the ones on the metadata file.

            Sample file:
                ,gene_symbol,GSM2177840,GSM2177841,GSM2177842,GSM2177843
                ENSG00000000003,TSPAN6,2076,1326,457,598
                ENSG00000000005,TNMD,0,0,0,0,1
                ENSG00000000419,DPM1,321,228,56,157
                ENSG00000000457,SCYL3,236,176,118,131
                
    *Metadata Files*
        - The files must be named following -- sampleid_metadata.csv
        - The metadata labels should be 'Tumor' vs 'Normal', as shown in the example.

            Sample file:
                ,tissue type
                GSM2177840,Normal
                GSM2177841,Normal
                GSM2177842,Tumor
                GSM2177843,Normal



## 2.2. Run the script

Execute the script:

    usage: multiaffinity [<files>] [<arguments>]
    
    files:
        -o Output Path              defines name for output directory
        -c Counts Path              path to counts matrix, use sep ','
        -m Metadata Path            path to metadata, use sep ','

    optional arguments:
        -h                          show this help message and exit
        -n Network Path             path to network, use sep ','
        -a Approach                 default is local
        -b Adjusted p-value         default is 0.05
        -d DESeq2 - LFC cutoff      default is 1
        -i MolTI-DREAM - Modularity default is 1
        -j MolTI-DREAM - Louvain    default is 5
        -f multiXrank - R value     default is 0.15
        -g multiXrank - Selfloops   default is 1

## 2.3. Output Files

All output files obtained in this computational study are available in the folder /output. Since there is multiple output files, for convenience, we also provide a spreadsheet file including the key results retrieved from the output files.

**Output Report:** found at *multiAffinity_report.csv*

|metaDEGs|AS-DE Corr|Community Size|Community ID|log2FC |Participation Coefficient|Overlap Degree|
|--------|----------|--------------|------------|-------|-------------------------|--------------|
|ADH1C   |-0.6715   |11            |11          |-4.7742|0.1038                   |75            |

**Multilayer Metrics Plot:** found at *output/multilayer_metrics_plot.png*, if output consists of more than one result

**Additional results folder**

    metaDEGs/
    - degs_report.txt: displays the number of upregulated and downregulated DEGs obtained individually from each study.
    - metaDEGs.txt: describes all the obtained metaDEGs and the corresponding RRA Score.
    - wasserstein.txt: remarks every pair of studies that show a significant difference between their distributions.

    Affinity/
    - RWR_matrix.txt: output of random walks

    Communities/
    - molti_output.txt: lays out the different communities defined by Molti-DREAM.
    - size_communities.txt: presents the secondary output obtained by Molti-DREAM, indicating the sizes of each community by layer

## 2.4. iPC-VRE
This approach can also be computed through the individualized Paediatric Cure - Virtual Research Environment as demonstrated in this this [video](https://www.youtube.com/watch?v=1tcwczu47aI&t=10s).

## 2.5. Advanced User Arguments
#### Network Layers
Instead of using a general biological data multilayer, the user can use gene-gene network from a different source, this input should consist of one or multiple layers in which nodes represent genes and edges represent different types of associations. Note that each layer has to be added as a different comma-separated  *csv* file.

    Sample Argument:
        -n sample_data/sample1_layer.csv,sample_data/sample2_layer.csv  
    Sample file:
        CNBP,HNRNPAB
        CNBP,RPL10A
        CNBP,CENPN
        CNBP,RSL24D1
        CNBP,SMAP
        CNBP,FTSJ3
        CNBP,TRA2B

#### Study Significance
The user can modify the adjusted p-value and LFC threshold set throughout the workflow

    -b Adjusted p-value         sets significance value for DESeq2, RRA, and Spearman's Corr *(default is 0.05)*
    -d DESeq2 - LFC cutoff      defines whether self loops are removed or not, takes values 0 or 1 *(default is 1)*


#### Analysis Approach 
The study follows a local approach to compute the study the spread of dysregulation within the nodes that fall in the same commnities, nonetheless, the user can choose to pursue a global approach, and study the propagation towards all the genes in the multilayer network of study.

    -a Approach                 computes correlation on each community or respect all genes, local or global approach *(default is local)*[opt]

#### MolTI-DREAM Arguments 
We implemented the use of the [MolTI-DREAM](https://github.com/gilles-didier/MolTi-DREAM/tree/master/src) tool into our workflow to define communities within our multilayer network, to optimize the results, the user can define an alternative **Modularity resolution parameter** and **number of Louvain randomizations**.

    -i MolTI-DREAM - Modularity sets Newman modularity resolution parameter on molTI-DREAM *(default is 1)* [opt]
    -j MolTI-DREAM - Louvain    switches to randomized Louvain on molTI-DREAM and sets num. of randomizations *(default is 5)* [opt]

If you are unsure of which Modularity value to set for your chosen network layers of study, you may be able to find the optimal value by using https://github.com/marbatlle/Optimize-Mod-Resolution.

#### MultiXrank Arguments 
For this pipeline, we also implemented [multiXrank](https://github.com/anthbapt/multixrank), in this case, to perform a RWR computation, to optimize your values, you can modify parameters such as the **R value** and **Selfloops**. You can find more information at https://multixrank-doc.readthedocs.io/en/latest/.

        -f multiXrank - R value     global restart probability for multiXrank, given by float between 0 and 1 *(default is 0.15)* [opt]
        -g multiXrank - Selfloops   defines whether self loops are removed or not, takes values 0 or 1 *(default is 1)* [opt]

<br>

-------------------------------------------------------------------------

<br>

![Other-logos](img/logos-project.jpg)
