import pandas as pd
import numpy as np
import seaborn as sns

up_go_path = '1-Obtaining-DEGs-for-HB/DEGs_HB/downregulated_GO.txt'
up_go = pd.read_csv(up_go_path, sep='\t')
up_go = up_go[['Category','Term','Count','Benjamini']]
up_go.columns = ['Class', 'Term', 'Count', 'Adj.p-val']
up_go['Class'] = up_go['Class'].replace(['GOTERM_BP_DIRECT'],'Biological Process')
up_go['Class'] = up_go['Class'].replace(['GOTERM_CC_DIRECT'],'Cellular Component')
up_go['Class'] = up_go['Class'].replace(['GOTERM_MF_DIRECT'],'Molecular Function')
print(len(up_go.index))

# Filter by adj. p-value < 0.5
up_go_filtered = up_go[up_go['Adj.p-val'] > 0.05]

sns.barplot(x='Term',y='Count',data=up_go_filtered, palette='rainbow')

print(len(up_go_filtered))
print(up_go.head())