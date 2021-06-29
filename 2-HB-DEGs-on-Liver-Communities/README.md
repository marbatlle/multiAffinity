**Goal:** How many of the DEGs fall in the same communities? And further analysis...


# Folders

## > 1_LiverNetwork
Obtain human annotated PPIs from http://iid.ophid.utoronto.ca/ and subset interactions related to liver tissues.

* *command: bash 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/generate_layers.sh*

## > 2_FindMolTiCommunities
Using the MolTi-DREAM software (*https://github.com/gilles-didier/MolTi-DREAM*), download to correspondend folder, obtain communities/clusters from the liver and liver cancer PPIs (+ metabolic).

This step includes the verification of the best number of randomizations to use in each case, as can be seen in *2-HB-DEGs-on-Liver-Communities/2_Communities/output*.

* *command bash 2-HB-DEGs-on-Liver-Communities/2_Communities/scripts/find_optimal_randomizations.sh (or find_optimal_randomizations_metabs.sh)*

## > 3_HB_DEG_in_liver_clusters
In this last step, the scripts are able to find matches between the DEGs found in Public HB databases for each of the communities detected in the previous step

* *command bash 2-HB-DEGs-on-Liver-Communities/3_HB_DEG_in_Communities/diff_communities_gene_list.sh*
* *output: /output/DEG_in_clusters.txt*

## > 4_NodeAffinity
Obtain correlation values between RWR matrix of liver and liver cancer networks and DEGs score values.

* *command: bash 2-HB-DEGs-on-Liver-Communities/4_NodeAffinity/script/affinity.sh*
