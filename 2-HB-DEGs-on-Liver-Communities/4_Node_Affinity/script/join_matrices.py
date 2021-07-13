import os
import numpy as np
import pandas as pd
from pandas.core.groupby import groupby

# load all table files
path_to_files = '1-Obtaining-DEGs-for-HB/Matrices_HB/Normalized_HB/'
lst_expmat = []
for filen in [x for x in os.listdir(path_to_files) if '.txt' in x]:
    lst_expmat.append(pd.read_csv(path_to_files+filen, delimiter= "\t"))
expression_mats = pd.concat(lst_expmat, ignore_index=True)
expression_mats = expression_mats.groupby(['Unnamed: 0']).mean().reset_index()