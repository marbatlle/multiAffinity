# Obtain liver and liver cancer PPI, gene interactions and obtain basic layer EDA
python 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/bin/obtain_PPI.py

for id in $(ls 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/*PPI.gr | sed "s:2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/::" | cut -d"." -f1)
do
    echo "Processing and exploring $id layer"
    cp 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/${id}.gr 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/tmp_PPI.gr
    python 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/bin/layer_EDA.py > 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/networks_EDA/${id}_EDA.txt

    # remove temp files
    rm 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/tmp_PPI.gr
done

# generate the metabolic reaction associations layer and obtain basic layer EDA
python3 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/bin/Recon3D_metabolites_graph.py > 2-HB-DEGs-on-Liver-Communities/1_Obtaining_Networks/networks/networks_EDA/Recon3D_metabolites_EDA.txt


    