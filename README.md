<br>

<img src="docs/img/multiAffinty-logo.png" alt="drawing" width="400"/>

<br>

MultiAffinity enables the study of how gene dysregulation propagates on a multilayer network on a disease of interest, uncovering key genes. Find the detailed documentation for the tool [here](https://marbatlle.github.io/multiAffinity//).

## Quick start 

### from Docker

    - Pull image
        docker pull marbatlle/multiAffinity
        
    - Run tool
        docker run -ti -v "$(pwd)/sample_data:/tool/sample_data" -v "$(pwd)/output:/tool/output" marbatlle/multiaffinity multiaffinity <FILES> <OPTIONS>
        
    - Files e.g.
        -o result -c sample_data/sample1_data.csv,sample_data/sample2_data.csv -m sample_data/sample1_metadata.csv,sample_data/sample2_metadata.csv
        
-------------------------------------------------------------------------

<br>

<img src="docs/img/logos-project.jpg" alt="drawing" width="800"/>

