import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# Upregulated Genes

up_go_path = 'output/DAVID_output/GO_up.txt'

header_list = ["Category","Term","Count","%","PValue","Genes","List Total","Pop Hits","Pop Total","Fold Enrichment","Bonferroni","Benjamini","FDR"]
up_go = pd.read_csv(up_go_path, sep='\t', names=header_list)

up_go = up_go[['Category','Term','Count','Benjamini']]
up_go.columns = ['Class', 'Term', 'Count', 'Adj.p-val']
up_go['Class'] = up_go['Class'].replace(['GOTERM_BP_DIRECT'],'Biological Process')
up_go['Class'] = up_go['Class'].replace(['GOTERM_CC_DIRECT'],'Cellular Component')
up_go['Class'] = up_go['Class'].replace(['GOTERM_MF_DIRECT'],'Molecular Function')
up_go['Adj.p-val'] = pd.to_numeric(up_go['Adj.p-val'],errors='coerce')
up_go['Count'] = pd.to_numeric(up_go['Count'],errors='coerce')

# Filter by adj. p-value < 0.5
up_go_filtered = up_go[up_go['Adj.p-val'] < 0.05]

up_go_filtered = up_go_filtered.sort_values(by=['Count'])

up_go_filtered = up_go_filtered.head(10)

up_go_filtered = up_go_filtered.sort_values(by=['Adj.p-val'])


sns.set_theme(style="whitegrid")
plt.figure(figsize=(14,8))
sns.barplot(x='Count',y='Term',data=up_go_filtered, palette='Set1', hue='Class')
plt.title('GO Analysis of Upregulated DEGs')
plt.tight_layout()
plt.savefig('output/Figures/GO_up')


# Downregulated Genes

down_go_path = 'output/DAVID_output/GO_down.txt'

header_list = ["Category","Term","Count","%","PValue","Genes","List Total","Pop Hits","Pop Total","Fold Enrichment","Bonferroni","Benjamini","FDR"]
down_go = pd.read_csv(down_go_path, sep='\t', names=header_list)

down_go = down_go[['Category','Term','Count','Benjamini']]
down_go.columns = ['Class', 'Term', 'Count', 'Adj.p-val']
down_go['Class'] = down_go['Class'].replace(['GOTERM_BP_DIRECT'],'Biological Process')
down_go['Class'] = down_go['Class'].replace(['GOTERM_CC_DIRECT'],'Cellular Component')
down_go['Class'] = down_go['Class'].replace(['GOTERM_MF_DIRECT'],'Molecular Function')
down_go['Adj.p-val'] = pd.to_numeric(down_go['Adj.p-val'],errors='coerce')
down_go['Count'] = pd.to_numeric(down_go['Count'],errors='coerce')

# Filter by adj. p-value < 0.5
down_go_filtered = down_go[down_go['Adj.p-val'] < 0.05]

down_go_filtered = down_go_filtered.sort_values(by=['Count'])

down_go_filtered = down_go_filtered.head(10)

down_go_filtered = down_go_filtered.sort_values(by=['Adj.p-val'])

sns.set_theme(style="whitegrid")
plt.figure(figsize=(14,8))
sns.barplot(x='Count',y='Term',data=down_go_filtered, palette='Set1', hue='Class')
plt.title('GO Analysis of Downregulated DEGs')
plt.tight_layout()
plt.savefig('output/Figures/GO_down')
