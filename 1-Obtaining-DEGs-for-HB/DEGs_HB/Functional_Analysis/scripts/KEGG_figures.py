import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

up_kegg_path = '1-Obtaining-DEGs-for-HB/DEGs_HB/Functional_Analysis/output/upregulated_KEGG.txt'
up_kegg = pd.read_csv(up_kegg_path, sep='\t')
# subset only KEGG_pathway
up_kegg = up_kegg[up_kegg['Category'] == 'KEGG_PATHWAY']
up_kegg = up_kegg[['Term','Count','Benjamini']]
up_kegg.columns = ['Term', 'Count', 'Adj.p-val']

# filter
# Filter by adj. p-value < 0.5
up_kegg_filtered = up_kegg[up_kegg['Adj.p-val'] < 0.05]
up_kegg_filtered = up_kegg_filtered.sort_values(by=['Count'])
up_kegg_filtered = up_kegg_filtered.head(10)
up_kegg_filtered = up_kegg_filtered.sort_values(by=['Adj.p-val'])

up_kegg_filtered

#sns.set_theme(style="whitegrid")
#plt.figure(figsize=(14,8))
#sns.barplot(x='Count',y='Term',data=up_kegg_filtered, palette='Set1')
#plt.title('Kegg Analysis of Upregulated DEGs')
#plt.tight_layout()
#plt.savefig('1-Obtaining-DEGs-for-HB/DEGs_HB/Functional_Analysis/output/upregulated_Kegg')

down_kegg_path = '1-Obtaining-DEGs-for-HB/DEGs_HB/Functional_Analysis/output/downregulated_KEGG.txt'
down_kegg = pd.read_csv(down_kegg_path, sep='\t')
# subset only KEGG_pathway
down_kegg = down_kegg[down_kegg['Category'] == 'KEGG_PATHWAY']
down_kegg = down_kegg[['Term','Count','Benjamini']]
down_kegg.columns = ['Term', 'Count', 'Adj.p-val']

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
plt.savefig('1-Obtaining-DEGs-for-HB/DEGs_HB/Functional_Analysis/output/downregulated_Kegg')

