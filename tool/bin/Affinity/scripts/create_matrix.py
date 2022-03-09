## FROM STEP 3.1. Creating RWR matrix with outputs

import pandas as pd
import numpy as np
import os

# Load dictionary
gene_dict = pd.read_csv('Affinity/tmp/gene_dict.txt',sep='\t')
matrix = gene_dict.set_index('ids')
gene_dict = gene_dict.set_index('ids')['Genes'].to_dict()

# Folder Path
glob_dir = os.getcwd()
folder = "/Affinity/output"
path = glob_dir + folder
 
# Change the directory
os.chdir(path)

# Read text File
def read_text_file(file_path):
    with open(file_path, 'r') as f:
        print(f.read())
  
# iterate through all file
for file in os.listdir():
    # Check whether file is in text format or not
    if file.endswith(".tsv"):
        file_path = f"{path}/{file}"
        sample = f"{file}"
        sample = sample.replace('.tsv', '')
  
        # call read text file function
        df = pd.read_csv(file_path, sep='\t', usecols=['node', 'score'])
        df.columns=['ids',f"{sample}"]
        df = df.set_index('ids')
        matrix = matrix.join(df, how='outer')


# drop ids column
matrix = matrix.set_index('Genes')

# column ids to names
column_ids = list(matrix)
df = pd.DataFrame(column_ids, columns=['Genes'])
df['Genes'] = df['Genes'].astype(str).astype(int)
df['Genes'] = df['Genes'].apply(lambda x: gene_dict.get(x, x))
column_names = df['Genes'].tolist()

# add names as matrix header
matrix.columns = column_names
matrix.index.name = None

matrix = pd.DataFrame(matrix)

#matrix=((matrix-matrix.mean())/matrix.std())

# Change the directory
os.chdir(glob_dir)

matrix.to_csv('Affinity/output/RWR_matrix.txt', sep='\t')