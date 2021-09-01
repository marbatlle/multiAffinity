## GOTerms
sed -i '/^\(GOTERM\)/!d' output/DAVID_output/GO_up.txt
sed -i '/^\(GOTERM\)/!d' output/DAVID_output/GO_down.txt
python scripts/GO_figures.py

## KEGG Pathways 
sed -i '/^\(KEGG\)/!d' output/DAVID_output/KEGG_up.txt
sed -i '/^\(KEGG\)/!d' 1output/DAVID_output/KEGG_down.txt
python scripts/KEGG_figures.py