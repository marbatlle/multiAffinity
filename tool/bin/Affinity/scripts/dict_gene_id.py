## FROM STEP 3.0. Create dictionary and translate gene names to numbers ids

import pandas as pd
import numpy as np
import os

# Create dictionary Gene <-> ID
## Create empty genes list
genes = []

## Folder Path
glob_dir = os.getcwd()
folder = "/Affinity/tmp"
path = glob_dir + folder
 
## Change the directory
os.chdir(path)

## Read text File
def read_text_file(file_path):
    with open(file_path, 'r') as f:
        print(f.read())
  
## iterate through all file
for file in os.listdir():
    
    ## Check whether file is in text format or not
    if file.endswith(".tsv"):
        file_path = f"{path}/{file}"
  
        ## call read text file function
        df = pd.read_csv(file_path,sep=' ', usecols=[0,1], header=None)
        genes.extend(df[0].unique())
        genes.extend(df[1].unique())

genes = set(genes)
print(len(genes)) # for output purposes

## create dataframe 
numbers = [i for i in range(len(genes)+1)]
gene_dict = pd.DataFrame(list(zip(genes, numbers)), columns =['Genes', 'ids'])

## Change the directory
os.chdir(glob_dir)

gene_dict.to_csv('Affinity/tmp/gene_dict.txt', sep='\t',index=False)


# Transform Genes to IDs - LAYERS
gene_dict = gene_dict.set_index('Genes')['ids'].to_dict()

## Folder Path
glob_dir = os.getcwd()
folder = "/Affinity/tmp"
path = glob_dir + folder
 
## Change the directory
os.chdir(path)

## Read text File
def read_text_file(file_path):
    with open(file_path, 'r') as f:
        print(f.read())
  
## iterate through all file
for file in os.listdir():
    
    ## Check whether file is in text format or not
    if file.endswith(".tsv"):
        file_path = f"{path}/{file}"
  
        ## call read text file function
        df = pd.read_csv(file_path,sep=' ', usecols=[0,1], header=None)
        for column in df:
            df[column] = df[column].apply(lambda x: gene_dict.get(x, x))
            df.to_csv(file_path, sep='\t',index=False, header=None)

## Change the directory
os.chdir(glob_dir)

# Transform Genes to IDs - DEGs

df = pd.read_csv('Affinity/tmp/degs_names.txt', header=None)
df[0] = df[0].apply(lambda x: gene_dict.get(x, x))
df = df[pd.to_numeric(df[0], errors='coerce').notnull()]

df.to_csv('Affinity/tmp/degs_ids.txt', sep='\t',index=False, header=None)
