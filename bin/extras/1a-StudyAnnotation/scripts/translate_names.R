library('biomaRt')
library(readr)

mart=useMart("ensembl")
mart=useDataset("hsapiens_gene_ensembl", mart = mart)

# Import Upregulated Genes
genes_symbol <- read.table("src/degs_names_down.txt",sep =',', header = FALSE)
genes_translated <- getBM(filters= "hgnc_symbol", attributes= c("entrezgene_id"),values=genes_symbol ,mart= mart)

write.table(genes_translated,file="src/degs_up_translated.txt", sep=",",row.names=FALSE, col.names=FALSE)

# Import Downregulated Genes
genes_symbol <- read.table("src/degs_names_up.txt",sep =',', header = FALSE)
genes_translated <- getBM(filters= "hgnc_symbol", attributes= c("entrezgene_id"),values=genes_symbol ,mart= mart)

write.table(genes_translated,file="src/degs_down_translated.txt", sep=",",row.names=FALSE, col.names=FALSE)
