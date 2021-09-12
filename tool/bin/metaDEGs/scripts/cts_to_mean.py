import os
import pandas as pd
import numpy as np

Study = pd.read_csv('output/normalized_counts/normalized.txt',sep=',')
Study = Study.set_index(['Unnamed: 0'])

Study_NT = Study.loc[:, ~Study.columns.str.startswith('T')]
Study_NT = Study.mean(axis=1)
Study_NT = pd.DataFrame(Study_NT, columns=['Expression'])
Study_NT.index.names = ['genes']
Study_NT.drop(Study_NT.loc[Study_NT['Expression']==0].index, inplace=True)
Study_NT.index = [x for x in range(1, len(Study_NT.values)+1)]


Study_NT.to_csv('output/means/mean.txt', sep=',', index=False)