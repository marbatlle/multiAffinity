import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

up_go_path = '1-Obtaining-DEGs-for-HB/DEGs_HB/upregulated_GO.txt'
up_go = pd.read_csv(up_go_path, sep='\t')
up_go = up_go[['Category','Term','Count','Benjamini']]
up_go.columns = ['Class', 'Term', 'Count', 'Adj.p-val']
up_go['Class'] = up_go['Class'].replace(['GOTERM_BP_DIRECT'],'Biological Process')
up_go['Class'] = up_go['Class'].replace(['GOTERM_CC_DIRECT'],'Cellular Component')
up_go['Class'] = up_go['Class'].replace(['GOTERM_MF_DIRECT'],'Molecular Function')

# Filter by adj. p-value < 0.5
up_go_filtered = up_go[up_go['Adj.p-val'] > 0.05]

up_go_filtered = up_go_filtered.head(10)

sns.set_theme(style="whitegrid")
plt.figure(figsize=(14,8))
sns.barplot(x='Count',y='Term',data=up_go_filtered, palette='Set1', hue='Class')
plt.title('GO Analysis of Upregulated DEGs')
plt.tight_layout()
plt.savefig('1-Obtaining-DEGs-for-HB/DEGs_HB/upregulated_GO')

down_go_path = '1-Obtaining-DEGs-for-HB/DEGs_HB/downregulated_GO.txt'
down_go = pd.read_csv(down_go_path, sep='\t')
down_go = down_go[['Category','Term','Count','Benjamini']]
down_go.columns = ['Class', 'Term', 'Count', 'Adj.p-val']
down_go['Class'] = down_go['Class'].replace(['GOTERM_BP_DIRECT'],'Biological Process')
down_go['Class'] = down_go['Class'].replace(['GOTERM_CC_DIRECT'],'Cellular Component')
down_go['Class'] = down_go['Class'].replace(['GOTERM_MF_DIRECT'],'Molecular Function')

# Filter by adj. p-value < 0.5
down_go_filtered = down_go[down_go['Adj.p-val'] > 0.05]
down_go_filtered = down_go_filtered.head(10)

sns.set_theme(style="whitegrid")
plt.figure(figsize=(14,8))
sns.barplot(x='Count',y='Term',data=down_go_filtered, palette='Set1', hue='Class')
plt.tight_layout()
plt.title('GO Analysis of Downregulated DEGs')
plt.savefig('1-Obtaining-DEGs-for-HB/DEGs_HB/downregulated_GO')