import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.signal import find_peaks

num_rands = pd.read_csv('rands_temp/output_num_randomizations.txt',header=None, names=["num_rands"])
num_com = pd.read_csv('rands_temp/output_num_communities.txt',header=None, names=["num_communities"])
avg_size = pd.read_csv('rands_temp/output_avg_com_size.txt',header=None, names=["avg_community_size"])

data = num_rands.merge(num_com, left_index=True, right_index=True)
data = data.merge(avg_size, left_index=True, right_index=True)
data_subset = data[['num_communities','avg_community_size']]

# Plot
sns.set_style("whitegrid")
g = sns.relplot(x="num_communities", y='avg_community_size', kind="line", data=data_subset)
g.fig.suptitle('Community numbers vs Average Size')
g.fig.autofmt_xdate()

plt.savefig('output_rands/optimal_rands_figure.png', bbox_inches='tight')