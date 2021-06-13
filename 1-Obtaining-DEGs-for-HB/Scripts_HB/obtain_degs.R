
library(tidyverse)
library(readr)
library(DESeq2)
library(apeglm)
library(RobustRankAggreg)
library(BiocParallel)
register(MulticoreParam(2))

# Import data
Count matrix should not be normalized and should be uniquely using hgnc gene symbols.

## Import Raw counts matrix
cts_path <- "~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Temp/raw_data.csv"
cts <- read.csv(cts_path, row.names=1)

## Import Metadata
meta_path <- '~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Temp/metadata.csv'
coldata <- read.csv(meta_path, row.names=1)
coldata$tissue <- factor(coldata$tissue)

# Find DEGs
## Run differential expression analysis
dds <- DESeq(dds, parallel=TRUE)
res <- results(dds, lfcThreshold = 1, parallel=TRUE)

## Extract all differentially expressed genes
res <- res[order(res$padj),]
res <- subset(res, res$padj < 0.05)

## Order all differentially expressed genes by effect size (the absolute value of log2FoldChange)
res <- res[order(-abs(res$log2FoldChange)),]
res <- as.data.frame(res)
cols<-!(colnames(res) %in% c("baseMean","lfcSE","stat","pvalue"))
res_subset <-subset(res,,cols)

# Extract data
## Extract genes upregulated
res_up <- res_subset %>% 
  filter(log2FoldChange > 0)
write.table(res_up, file="~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Temp/Temp_up", sep="\t", quote=F, col.names=TRUE)

## Extract genes downregulated
res_down <- res_subset %>% 
  filter(log2FoldChange < 0)
write.table(res_down, file="~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Temp/Temp_down", sep="\t", quote=F, col.names=TRUE)
```