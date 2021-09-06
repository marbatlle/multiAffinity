# Communities
Discover the optimal number of randomizations for your networks when using MolTI-DREAM and find out the distribution of your desired genes(i.e. DEGs) in the resulting multilayer network communities!

## Networks

* **Liver PPI layer**

    * Number of nodes: 18726
    * Number of edges: 960872

* **Metabolic layer**
    * Number of nodes: 1786
    * Number of edges: 52077

As seen at the MOlTI Randomizations Benchmarking, as we are using two large layers with mrore than 8000 edges, https://github.com/marbatlle/Benchmark-MolTI-Rands/blob/main/outputs/plots/heatmap_randomizations.png, we will apply the MolTI program with zero randomizations. If you want to double check the optimal number, you can run:

    # Obtain optimal randomizations value for MolTI-DREAM
    ## Run 
    * cd Communities ; bash obtain_optimal_rands.sh
    ## Results
    * **Optimal randomizations and analysis:** output_rands/optimal_randomizations.txt
    * **Randomizations behaviour plot:** output_rands/optimal_rands_figure.png


## Obtain gene matches in multilayer network communities
### Run
* **With 0 randomizations:** cd cd Communities ;bash obtain_Communities.sh
* **With other number of randomizations:** cd cd Communities ; bash obtain_Communities.sh *number of randomizations* (i.e. bash obtain_Communities.sh 5)

### Results
* **MolTI-DREAM clusters report:** Communities/output/communities.txt
* **Gene matches:** Communities/output/Communities.txt
* **Top-20 gene matches:** Communities/output/Communities_topmatches.txt

## References
Didier G, Valdeolivas A, Baudot A. Identifying communities from multiplex biological networks by randomized optimization of modularity. F1000Res. 2018 Jul 10;7:1042. doi: 10.12688/f1000research.15486.2. PMID: 30210790; PMCID: PMC6107982.