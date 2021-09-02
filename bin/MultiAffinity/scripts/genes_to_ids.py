import pandas as pd
import numpy as np
import os

# Load dictionary
gene_dict = pd.read_csv('MultiAffinity/tmp/gene_dict.txt',sep='\t')
gene_dict = gene_dict.set_index('Genes')['ids'].to_dict()


# Folder Path
glob_dir = os.getcwd()
folder = "/MultiAffinity/tmp"
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
  
        # call read text file function
        df = pd.read_csv(file_path,sep=' ', usecols=[0,1], header=None)
        for column in df:
            df[column] = df[column].apply(lambda x: gene_dict.get(x, x))
            df.to_csv(file_path, sep='\t',index=False, header=None)
