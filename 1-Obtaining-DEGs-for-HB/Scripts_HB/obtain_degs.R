
library(tidyverse)
library(readr)
library(DESeq2)
library(apeglm)
library(RobustRankAggreg)
library(BiocParallel)
register(MulticoreParam(2))

# Import data
### Count matrix should not be normalized and should be uniquely using hgnc gene symbols.

## Import Raw counts matrix
cts_path <- "1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/raw_data.csv"
cts <- read.csv(cts_path, row.names=1)

## Import Metadata
meta_path <- '1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/metadata.csv'
coldata <- read.csv(meta_path, row.names=1)
coldata$tissue <- factor(coldata$tissue)


# Normalized
## Create DSeq2 object
dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata,
                              design = ~ tissue)

## Filter out all genes with <10 reads total across all samples
dds <- dds[rowSums(counts(dds)) >= 10,]

# Factor Level
dds$tissue <- relevel(dds$tissue, ref = "Normal")

# Median of ratios Normalization
dds <- estimateSizeFactors(dds)
#normalized_counts <- counts(dds, normalized=TRUE)
#write.table(normalized_counts, file="Matrices_HB/normalized_counts.txt", sep="\t", quote=F, col.names=NA)


# Find DEGs
## Run differential expression analysis
dds <- DESeq(dds, parallel=TRUE)
res <- results(dds, lfcThreshold = 0.5, parallel=TRUE)

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
write.csv(res_up, "1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/Tmp_up.csv")

## Extract genes downregulated
res_down <- res_subset %>% 
  filter(log2FoldChange < 0)
write.csv(res_down, "1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/Tmp_down.csv")

print('num. of upregulated DEGs:')
print(nrow(res_up))
print('num. of downregulated DEGs:')
print(nrow(res_down))

