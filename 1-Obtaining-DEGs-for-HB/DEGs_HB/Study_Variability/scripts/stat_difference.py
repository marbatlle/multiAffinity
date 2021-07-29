

LFC = pd.melt(LFC.reset_index(), id_vars=['index'], value_vars=['A', 'B', 'C', 'D'])

print(LFC)
