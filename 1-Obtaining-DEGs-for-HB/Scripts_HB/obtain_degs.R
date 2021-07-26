library(tidyverse)
library(readr)
library(DESeq2)
library(apeglm)
library(RobustRankAggreg)
library(BiocParallel)
library(data.table)
library(IHW)
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


# Create DSeq2 object
dds <- DESeqDataSetFromMatrix(countData = cts, colData = coldata, design = ~ tissue) %>% DESeq

# Filter out all genes with <5 reads total across all samples
dds <- dds[rowSums(counts(dds)) >= 5]

# Specify Reference level
dds$tissue <- relevel(dds$tissue, ref = "Normal")
dds <- DESeq(dds)

# Find DEGs
res <- results(dds, alpha=0.05, filterFun=ihw)

# Set thresholds
res <- subset(res, res$padj < 0.05)

res <- subset(res, abs(res$log2FoldChange) > 1)



## Order all differentially expressed genes by effect size (the absolute value of log2FoldChange)
res <- res[order(-abs(res$log2FoldChange)),]
res <- as.data.frame(res)
cols<-!(colnames(res) %in% c("baseMean","lfcSE","stat","pvalue"))
res_subset <- subset(res,,cols)

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


# Obtain normalized matrices
# Median of ratios Normalization
normalized_counts <- estimateSizeFactors(dds)
normalized_counts <- counts(normalized_counts, normalized=TRUE)

# transpose coldata
t_coldata <- transpose(coldata)
## get row and colnames in order
colnames(t_coldata) <- rownames(coldata)
rownames(t_coldata) <- colnames(coldata)
# to list
levels.list <- as.list(as.data.frame(t(t_coldata)))

# rename columns
colnames(normalized_counts) <- levels.list$tissue

#save normalized counts table
write.table(normalized_counts, file="1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Tmp/normalized_counts.txt", sep="\t", quote=F, col.names=NA)

