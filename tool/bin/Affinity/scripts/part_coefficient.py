from __future__ import division
import pandas as pd
import csv, os
from joblib import Parallel, delayed
import multiprocessing
from itertools import combinations

path, dirs, files = next(os.walk("Affinity/src/multiplex"))
layers_count = len(files)

def genes(edgelist_file):
    df = pd.read_csv(edgelist_file, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,'attribute':str})
    return set(df.gene1).union(set(df.gene2))

if layers_count == 1:

    #----# layers processing
    net1 = 'Affinity/src/multiplex/layer1.tsv'

    l = [genes(net1)]
    all_genes = list(frozenset().union(*l))

    df_net1 = pd.read_csv(net1, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})

    el_net1 = [ tuple(sorted(i)) for i in zip(df_net1.gene1,df_net1.gene2) ]

    k = el_net1
    k_uniq = [x for x in set(tuple(x) for x in k)]

    #----# generate multilayer file

    el_net1 = set(el_net1)

    def check_layers(edge):
        l = [ edge in x for x in [el_net1] ]
        return [int(i) for i in l]

    inputs = []
    for idx,edge in enumerate(k_uniq):
        inputs.append(check_layers(edge))

    with open('Affinity/tmp/multilayer.tsv', 'w') as f:
        writer = csv.writer(f, delimiter='\t')
        writer.writerow(["gene1", "gene2", "net1"])
        writer.writerows([list(k_uniq[i])+x for i,x in enumerate(inputs)])

    #----# compute participation coefficients

    df = pd.read_csv("Affinity/tmp/multilayer.tsv", sep='\s+', header=0)

    M = len(df.columns) - 2 # number of layers
    def part_coef(gene_index):
        i = df[df.gene1.isin([all_genes[gene_index]])|df.gene2.isin([all_genes[gene_index]])]
        k_ia = i.iloc[:,2:len(df.columns)].sum() # in-layer degree of node i
        o_i = k_ia.sum() # overlapping degree of node i
        return 0.0, o_i

elif layers_count == 2:

    #----# layers processing

    net1 = 'Affinity/src/multiplex/layer1.tsv'
    net2 = 'Affinity/src/multiplex/layer2.tsv'

    l = [genes(net1),genes(net2)]
    all_genes = list(frozenset().union(*l))

    df_net1 = pd.read_csv(net1, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})
    df_net2 = pd.read_csv(net2, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})

    el_net1 = [ tuple(sorted(i)) for i in zip(df_net1.gene1,df_net1.gene2) ]
    el_net2 = [ tuple(sorted(i)) for i in zip(df_net2.gene1,df_net2.gene2) ]

    k = el_net1 + el_net2
    k_uniq = [x for x in set(tuple(x) for x in k)]

    #----# generate multilayer file

    el_net1 = set(el_net1)
    el_net2 = set(el_net2)

    def check_layers(edge):
        l = [ edge in x for x in [el_net1, el_net2] ]
        return [int(i) for i in l]

    inputs = []
    for idx,edge in enumerate(k_uniq):
        inputs.append(check_layers(edge))

    with open('Affinity/tmp/multilayer.tsv', 'w') as f:
        writer = csv.writer(f, delimiter='\t')
        writer.writerow(["gene1", "gene2", "net1", "net2"])
        writer.writerows([list(k_uniq[i])+x for i,x in enumerate(inputs)])

    #----# compute participation coefficients

    df = pd.read_csv("Affinity/tmp/multilayer.tsv", sep='\s+', header=0)

    M = len(df.columns) - 2 # number of layers
  
    def part_coef(gene_index):
        i = df[df.gene1.isin([all_genes[gene_index]])|df.gene2.isin([all_genes[gene_index]])]
        k_ia = i.iloc[:,2:len(df.columns)].sum() # in-layer degree of node i
        o_i = k_ia.sum() # overlapping degree of node i
        return (M/(M-1)) * (1 - ((k_ia / o_i)**2).sum()), o_i

elif layers_count == 3:

    #----# layers processing

    net1 = 'Affinity/src/multiplex/layer1.tsv'
    net2 = 'Affinity/src/multiplex/layer2.tsv'
    net3 = 'Affinity/src/multiplex/layer3.tsv'

    l = [genes(net1),genes(net2),genes(net3)]
    all_genes = list(frozenset().union(*l))

    df_net1 = pd.read_csv(net1, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})
    df_net2 = pd.read_csv(net2, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})
    df_net3 = pd.read_csv(net3, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})

    el_net1 = [ tuple(sorted(i)) for i in zip(df_net1.gene1,df_net1.gene2) ]
    el_net2 = [ tuple(sorted(i)) for i in zip(df_net2.gene1,df_net2.gene2) ]
    el_net3 = [ tuple(sorted(i)) for i in zip(df_net3.gene1,df_net3.gene2) ]

    k = el_net1 + el_net2 + el_net3
    k_uniq = [x for x in set(tuple(x) for x in k)]

    #----# generate multilayer file

    el_net1 = set(el_net1)
    el_net2 = set(el_net2)
    el_net3 = set(el_net3)

    def check_layers(edge):
        l = [ edge in x for x in [el_net1, el_net2, el_net3] ]
        return [int(i) for i in l]

    inputs = []
    for idx,edge in enumerate(k_uniq):
        inputs.append(check_layers(edge))

    with open('Affinity/tmp/multilayer.tsv', 'w') as f:
        writer = csv.writer(f, delimiter='\t')
        writer.writerow(["gene1", "gene2", "net1", "net2", "net3"])
        writer.writerows([list(k_uniq[i])+x for i,x in enumerate(inputs)])

    #----# compute participation coefficients

    df = pd.read_csv("Affinity/tmp/multilayer.tsv", sep='\s+', header=0)

    M = len(df.columns) - 2 # number of layers
    def part_coef(gene_index):
        i = df[df.gene1.isin([all_genes[gene_index]])|df.gene2.isin([all_genes[gene_index]])]
        k_ia = i.iloc[:,2:len(df.columns)].sum() # in-layer degree of node i
        o_i = k_ia.sum() # overlapping degree of node i
        return (M/(M-1)) * (1 - ((k_ia / o_i)**2).sum()), o_i

elif layers_count == 4:
    
    #----# layers processing

    net1 = 'Affinity/src/multiplex/layer1.tsv'
    net2 = 'Affinity/src/multiplex/layer2.tsv'
    net3 = 'Affinity/src/multiplex/layer3.tsv'
    net4 = 'Affinity/src/multiplex/layer4.tsv'

    l = [genes(net1),genes(net2),genes(net3),genes(net4)]
    all_genes = list(frozenset().union(*l))

    df_net1 = pd.read_csv(net1, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})
    df_net2 = pd.read_csv(net2, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})
    df_net3 = pd.read_csv(net3, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})
    df_net4 = pd.read_csv(net4, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})

    el_net1 = [ tuple(sorted(i)) for i in zip(df_net1.gene1,df_net1.gene2) ]
    el_net2 = [ tuple(sorted(i)) for i in zip(df_net2.gene1,df_net2.gene2) ]
    el_net3 = [ tuple(sorted(i)) for i in zip(df_net3.gene1,df_net3.gene2) ]
    el_net4 = [ tuple(sorted(i)) for i in zip(df_net4.gene1,df_net4.gene2) ]

    k = el_net1 + el_net2 + el_net3 + el_net4
    k_uniq = [x for x in set(tuple(x) for x in k)]

    #----# generate multilayer file

    el_net1 = set(el_net1)
    el_net2 = set(el_net2)
    el_net3 = set(el_net3)
    el_net4 = set(el_net4)

    def check_layers(edge):
        l = [ edge in x for x in [el_net1, el_net2, el_net3, el_net4] ]
        return [int(i) for i in l]

    inputs = []
    for idx,edge in enumerate(k_uniq):
        inputs.append(check_layers(edge))

    with open('Affinity/tmp/multilayer.tsv', 'w') as f:
        writer = csv.writer(f, delimiter='\t')
        writer.writerow(["gene1", "gene2", "net1", "net2", "net3", "net4"])
        writer.writerows([list(k_uniq[i])+x for i,x in enumerate(inputs)])

    #----# compute participation coefficients

    df = pd.read_csv("Affinity/tmp/multilayer.tsv", sep='\s+', header=0)

    M = len(df.columns) - 2 # number of layers
    def part_coef(gene_index):
        i = df[df.gene1.isin([all_genes[gene_index]])|df.gene2.isin([all_genes[gene_index]])]
        k_ia = i.iloc[:,2:len(df.columns)].sum() # in-layer degree of node i
        o_i = k_ia.sum() # overlapping degree of node i
        return (M/(M-1)) * (1 - ((k_ia / o_i)**2).sum()), o_i

elif layers_count == 5:
        
    #----# layers processing

    net1 = 'Affinity/src/multiplex/layer1.tsv'
    net2 = 'Affinity/src/multiplex/layer2.tsv'
    net3 = 'Affinity/src/multiplex/layer3.tsv'
    net4 = 'Affinity/src/multiplex/layer4.tsv'
    net5 = 'Affinity/src/multiplex/layer5.tsv'

    l = [genes(net1),genes(net2),genes(net3),genes(net4)]
    all_genes = list(frozenset().union(*l))

    df_net1 = pd.read_csv(net1, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})
    df_net2 = pd.read_csv(net2, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})
    df_net3 = pd.read_csv(net3, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})
    df_net4 = pd.read_csv(net4, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})
    df_net5 = pd.read_csv(net5, sep='\s+', header=None, names=['gene1', 'gene2', 'attribute'], dtype={'gene1':int, 'gene2':int,
    'attribute':str})

    el_net1 = [ tuple(sorted(i)) for i in zip(df_net1.gene1,df_net1.gene2) ]
    el_net2 = [ tuple(sorted(i)) for i in zip(df_net2.gene1,df_net2.gene2) ]
    el_net3 = [ tuple(sorted(i)) for i in zip(df_net3.gene1,df_net3.gene2) ]
    el_net4 = [ tuple(sorted(i)) for i in zip(df_net4.gene1,df_net4.gene2) ]
    el_net5 = [ tuple(sorted(i)) for i in zip(df_net5.gene1,df_net4.gene2) ]

    k = el_net1 + el_net2 + el_net3 + el_net4 + el_net5
    k_uniq = [x for x in set(tuple(x) for x in k)]

    #----# generate multilayer file

    el_net1 = set(el_net1)
    el_net2 = set(el_net2)
    el_net3 = set(el_net3)
    el_net4 = set(el_net4)
    el_net5 = set(el_net5)

    def check_layers(edge):
        l = [ edge in x for x in [el_net1, el_net2, el_net3, el_net4, el_net5] ]
        return [int(i) for i in l]

    inputs = []
    for idx,edge in enumerate(k_uniq):
        inputs.append(check_layers(edge))

    with open('Affinity/tmp/multilayer.tsv', 'w') as f:
        writer = csv.writer(f, delimiter='\t')
        writer.writerow(["gene1", "gene2", "net1", "net2", "net3", "net4", "net5"])
        writer.writerows([list(k_uniq[i])+x for i,x in enumerate(inputs)])

    #----# compute participation coefficients

    df = pd.read_csv("Affinity/tmp/multilayer.tsv", sep='\s+', header=0)

    M = len(df.columns) - 2 # number of layers
    def part_coef(gene_index):
        i = df[df.gene1.isin([all_genes[gene_index]])|df.gene2.isin([all_genes[gene_index]])]
        k_ia = i.iloc[:,2:len(df.columns)].sum() # in-layer degree of node i
        o_i = k_ia.sum() # overlapping degree of node i
        return (M/(M-1)) * (1 - ((k_ia / o_i)**2).sum()), o_i

else:
    print("Add 1 to 5 layers")

inputs = range(len(all_genes))
num_cores = multiprocessing.cpu_count()
results = Parallel(n_jobs=num_cores)(delayed(part_coef)(i) for i in inputs)

with open('Affinity/tmp/part_coef.tsv', 'w') as f:
    writer = csv.writer(f, delimiter='\t')
    writer.writerow(["Genes", "part_coef", "overlap_degree"])
    writer.writerows(zip(all_genes,[i[0] for i in results],[i[1] for i in results]))
#----# translate participation coefficients to gene symbols ids
gene_dict = pd.read_csv('Affinity/tmp/gene_dict.txt',sep='\t')
matrix = gene_dict.set_index('ids')
gene_dict = gene_dict.set_index('ids')['Genes'].to_dict()
df = pd.read_csv('Affinity/tmp/part_coef.tsv',sep='\s+')
df['Genes'] = df['Genes'].apply(lambda x: gene_dict.get(x, x))
df = df.rename({'Genes': 'metaDEGs'}, axis=1)
df.to_csv('Affinity/output/part_coef.txt', sep=',',index=False)

