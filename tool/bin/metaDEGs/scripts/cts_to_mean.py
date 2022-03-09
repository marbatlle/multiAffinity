## FROM STEP 1.1. Obtain mean values for NT samples for each study

import os
import pandas as pd
import numpy as np
import argparse

# Parse arguments
parser = argparse.ArgumentParser()
parser.add_argument('sid', type=str)
args = parser.parse_args()
path_input = ["output/normalized_counts/", args.sid,".txt"]
path_input = "".join(path_input)
 
# Run script
Study = pd.read_csv(path_input,sep=',')
if 'Unnamed: 0' in Study.columns:
    Study = Study.set_index(['Unnamed: 0'])
Study_NT = Study.loc[:, ~Study.columns.str.startswith('T')]
Study_NT = Study.mean(axis=1)
Study_NT = pd.DataFrame(Study_NT, columns=['Expression'])
Study_NT.index.names = ['genes']
Study_NT.drop(Study_NT.loc[Study_NT['Expression']==0].index, inplace=True)
Study_NT.index = [x for x in range(1, len(Study_NT.values)+1)]
path_output = ["output/means/", args.sid,"_mean.txt"]
path_output = "".join(path_output)

# Export means for each study
Study_NT.to_csv(path_output, sep=',', index=False)