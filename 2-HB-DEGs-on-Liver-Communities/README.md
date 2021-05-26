**Goal:** How many of the DEGs fall in the same communities?

# Steps

## 1. Obtain gene interactions in liver tissues *(at /1_ObtainLiverGeneNetworks)*
Obtain human annotated PPIs from http://iid.ophid.utoronto.ca/ and subset interactions related to liver tissues.

* *script: obtain-liver-interactions.ipynb*
* *output: liver_PPI.txt*

## 2. Describe Communities formed by these interactions *(at /2_FindMolTiCommunities)*
Using the MolTi-DREAM software (*https://github.com/gilles-didier/MolTi-DREAM*), obtained communities/clusters from the liver PPIs.


*./molti-console -o liver_ppi_clusters /home/mar/Documents/TFM/GitHub/HB_PublicData/2-HB-DEGs-on-Liver-Communities/1_ObtainLiverGeneNetworks/liver_PPI.txt*

To determine the amount of Louvain randomizations, we try 1, 5, 10, 15 ... 100 and determine which works better

*./molti-console -p 1 -o liver_ppi_clusters_1 /home/mar/Documents/TFM/GitHub/HB_PublicData/2-HB-DEGs-on-Liver-Communities/1_ObtainLiverGeneNetworks/liver_PPI.txt*

## 3. Detect DEGs in these communities *(at /3_HB_DEG_in_liver_clusters)*
In this last step, the scripts are able to find matches between the DEGs found in Public HB databases for each of the communities detected in the previous step

* *command bash 3_HB_DEG_in_liver_clusters/diff_communities_gene_list.sh *
* *output: /output/DEG_in_clusters.txt*
