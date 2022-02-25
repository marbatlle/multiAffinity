# Welcome to multiAffinity
This is the documentation for [multiAffinity](https://github.com/marbatlle/multiAffinity), which enables the study of how gene dysregulation propagates on a multilayer network on a disease of interest, uncovers the key genes. Following the approach detailed in this [video](https://www.youtube.com/watch?v=1tcwczu47aI).

![](img/multiAffinty-logo.png)

## Quick Start
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
        
### from the iPC-VRE
This approach can also be computed through the individualized Paediatric Cure - Virtual Research Environment as demonstrated in this this [video](https://www.youtube.com/watch?v=1tcwczu47aI&t).
<br>

-------------------------------------------------------------------------

![](img/logos-project.jpg)
