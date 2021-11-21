import pandas as pd
import seaborn as sns
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt

def multimetrics(data):
        max_value = data.nlargest(1,'Overlap Degree')['Overlap Degree'].values[0]
        # plot
        sns.set_context("talk", font_scale=1)
        plt.figure(figsize=(10,7))
        fig = sns.scatterplot(data=df, y='Overlap Degree', x='Participation Coefficient', size='Corr', sizes =(20,500), alpha = 0.5, color='#345488')
        fig.legend(loc='upper left', frameon=False)
        #define structure
        fig.set_xlim([-0.05, 1.05])
        fig.set_ylim([-1.5, max_value+max_value/10])
        plt.ylabel(r'z($o_i$)')
        plt.xlabel(r'$P_i$')
        left, width = .16, .35
        bottom, height = -1.5, max_value
        right_limit = 1.11
        center = left + width
        right = left + width + width
        top = height + max_value/4.8
        mid_low = -0.7
        mid_high = height/2 + 0.2
        # define labels
        fig.text(left, top, 'FOCUSED',
                horizontalalignment='center',
                verticalalignment='center',
                rotation=25)
        fig.text(center, top, 'MIXED',
                horizontalalignment='center',
                verticalalignment='center',
                rotation=25)
        fig.text(right, top, 'MULTIPLEX',
                horizontalalignment='center',
                verticalalignment='center',
                rotation=25)
        fig.text(right_limit, mid_high, 'HUBS',
                horizontalalignment='center',
                verticalalignment='center',
                rotation=25)
        fig.text(right_limit+0.01, mid_low, 'LEAVES',
                horizontalalignment='center',
                verticalalignment='center',
                rotation=25)
        # draw axis lines
        plt.axvline(x=0.33, color = 'black', linewidth = 1, linestyle = 'dashed')
        plt.axvline(x=0.66, color = 'black', linewidth = 1, linestyle = 'dashed')
        plt.axhline(y=0, color = 'black', linewidth = 1, linestyle = 'dashed')
        # export plot
        fig.figure.savefig("output/Affinity/participation_plot.png")

# import dataframe
df = pd.read_csv('output/multiAffinity_report.csv', index_col=0)
df['Overlap Degree'] = stats.zscore(df['Overlap Degree']) #transform to z score
df = df.rename(columns={'DifExp-Aff Corr': 'Corr'})
df.apply(pd.to_numeric)
df['Corr'] = df['Corr'].abs()
multimetrics(df)