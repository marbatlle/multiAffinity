## FROM STEP 1.1. Run DESeq2 to obtain DEGs

Load <- function(packages) {
  for(package_name in packages)
  {suppressMessages(suppressWarnings(library(package_name,character.only=TRUE, quietly = TRUE)));}
}
Load(c("tidyverse","DESeq2","IHW","data.table"))

# Set Arguments
args <- commandArgs(trailingOnly = TRUE)

DESeq2_padj <- as.numeric(args[1])
DESeq2_LFC <- as.numeric(args[2])
sid <- as.character(args[3])

# Import data - Count matrix should not be normalized and should be uniquely using hgnc gene symbols.
## Import Raw counts matrix
cts_path <- file.path("src/tmp/counts", paste(sid,"_cts.txt", sep = ""))
cts <- read.csv(cts_path, row.names=1)

## Import Metadata
meta_path <- file.path("src/tmp/metadata", paste(sid,"_meta.txt", sep = ""))
coldata <- read.csv(meta_path, row.names=1)
coldata$tissue <- factor(coldata$tissue)

# Run DESeq2
## Create DSeq2 object
dds <- DESeqDataSetFromMatrix(countData = cts, colData = coldata, design = ~ tissue) 

## Filter out all genes with <5 reads total across all samples
dds <- dds[rowSums(counts(dds)) >= 5]
dds <- DESeq(dds)

## Specify Reference level
dds$tissue <- relevel(dds$tissue, ref = "control")

## Obtain deregulation values for all genes
res <- results(dds)
res <- as.data.frame(res)
res <- subset(res, res$padj < DESeq2_padj)

write.table(res,paste("output/dif_exp/",sid,".txt", sep = ""), sep = ",", row.names = TRUE, col.names=TRUE)

## Order all differentially expressed genes by effect size (the absolute value of log2FoldChange)
res <- res[order(-abs(res$log2FoldChange)),]
res <- subset(res, abs(res$log2FoldChange) > DESeq2_LFC)
res <- as.data.frame(res)
cols<-!(colnames(res) %in% c("baseMean","lfcSE","stat","pvalue","padj"))
res_subset <- subset(res,,cols)

# Extract data
## Extract genes upregulated
res_up <- res_subset %>% 
  filter(log2FoldChange > 0)
write.table(res_up,paste("src/tmp/degs/",sid,"_DEGs_up.txt", sep = ""), sep = ",", row.names = TRUE, col.names=TRUE)

## Extract genes downregulated
res_down <- res_subset %>% 
  filter(log2FoldChange < 0)
write.table(res_down,paste("src/tmp/degs/",sid,"_DEGs_down.txt", sep = ""), sep = ",", row.names = TRUE, col.names=TRUE)
cat('num. of upregulated DEGs: ', nrow(res_up),'\n')
cat('num. of downregulated DEGs:', nrow(res_down))

## Extract normalized matrices
### Median of ratios Normalization
normalized_counts <- estimateSizeFactors(dds)
normalized_counts <- counts(normalized_counts, normalized=TRUE)
### Transpose coldata
t_coldata <- transpose(coldata)
### Get row and colnames in order
colnames(t_coldata) <- rownames(coldata)
rownames(t_coldata) <- colnames(coldata)
### To list
levels.list <- as.list(as.data.frame(t(t_coldata)))
### Rename columns
colnames(normalized_counts) <- levels.list$tissue
### Save normalized counts table
write.table(normalized_counts,paste("output/normalized_counts/",sid,".txt", sep = ""), sep = ",", row.names = TRUE, col.names=TRUE)