import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

up_kegg_path = 'output/DAVID_output/KEGG_up.txt'
header_list = ["Category","Term","Count","%","PValue","Genes","List Total","Pop Hits","Pop Total","Fold Enrichment","Bonferroni","Benjamini","FDR"]
up_kegg = pd.read_csv(up_kegg_path, sep='\t', names=header_list)

# subset only KEGG_pathway
up_kegg = up_kegg[up_kegg['Category'] == 'KEGG_PATHWAY']
up_kegg = up_kegg[['Term','Count','Benjamini']]
up_kegg.columns = ['Term', 'Count', 'Adj.p-val']
up_kegg['Adj.p-val'] = pd.to_numeric(up_kegg['Adj.p-val'],errors='coerce')
up_kegg['Count'] = pd.to_numeric(up_kegg['Count'],errors='coerce')
# filter
# Filter by adj. p-value < 0.5
up_kegg_filtered = up_kegg[up_kegg['Adj.p-val'] < 0.05]
up_kegg_filtered = up_kegg_filtered.sort_values(by=['Count'])
up_kegg_filtered = up_kegg_filtered.head(10)
up_kegg_filtered = up_kegg_filtered.sort_values(by=['Adj.p-val'])

print(up_kegg_filtered.head())

#sns.set_theme(style="whitegrid")
#plt.figure(figsize=(14,8))
#sns.barplot(x='Count',y='Term',data=up_kegg_filtered, palette='Set1')
#plt.title('Kegg Analysis of Upregulated DEGs')
#plt.tight_layout()
#plt.savefig('output/Figures/KEGG_up.png')




down_kegg_path = 'output/DAVID_output/KEGG_down.txt'
header_list = ["Category","Term","Count","%","PValue","Genes","List Total","Pop Hits","Pop Total","Fold Enrichment","Bonferroni","Benjamini","FDR"]

down_kegg = pd.read_csv(down_kegg_path, sep='\t', names=header_list)
# subset only KEGG_pathway
down_kegg = down_kegg[down_kegg['Category'] == 'KEGG_PATHWAY']
down_kegg = down_kegg[['Term','Count','Benjamini']]
down_kegg.columns = ['Term', 'Count', 'Adj.p-val']
down_kegg['Adj.p-val'] = pd.to_numeric(down_kegg['Adj.p-val'],errors='coerce')
down_kegg['Count'] = pd.to_numeric(down_kegg['Count'],errors='coerce')

# filter
# Filter by adj. p-value < 0.5
down_kegg_filtered = down_kegg[down_kegg['Adj.p-val'] < 0.05]
down_kegg_filtered = down_kegg_filtered.sort_values(by=['Count'])
down_kegg_filtered = down_kegg_filtered.head(10)
down_kegg_filtered = down_kegg_filtered.sort_values(by=['Adj.p-val'])

sns.set_theme(style="whitegrid")
plt.figure(figsize=(14,8))
sns.barplot(x='Count',y='Term',data=down_kegg_filtered, palette='Set1')
plt.title('Kegg Analysis of Downregulated DEGs')
plt.tight_layout()
plt.savefig('output/Figures/KEGG_down.png')

