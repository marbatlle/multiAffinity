Load <- function(packages) {
  for(package_name in packages)
  {suppressMessages(suppressWarnings(library(package_name,character.only=TRUE, quietly = TRUE)));}
}
Load(c("tidyverse","DESeq2","IHW","data.table"))


# get the input passed from the shell script
args <- commandArgs(trailingOnly = TRUE)

DESeq2_padj=as.numeric(args[1])
DESeq2_LFC=as.numeric(args[2])

# Import data
### Count matrix should not be normalized and should be uniquely using hgnc gene symbols.

## Import Raw counts matrix
cts_path <- "src/tmp/raw_data.csv"
cts <- read.csv(cts_path, row.names=1)

## Import Metadata
meta_path <- 'src/tmp/metadata.csv'
coldata <- read.csv(meta_path, row.names=1)
coldata$tissue <- factor(coldata$tissue)

# Create DSeq2 object
dds <- DESeqDataSetFromMatrix(countData = cts, colData = coldata, design = ~ tissue) 

# Filter out all genes with <5 reads total across all samples
dds <- dds[rowSums(counts(dds)) >= 5]

dds <- DESeq(dds)

# Specify Reference level
dds$tissue <- relevel(dds$tissue, ref = "control")

# Obtain deregulation values for all genes
res <- results(dds, alpha=DESeq2_padj, cooksCutoff=FALSE)
res <- subset(res, res$padj < DESeq2_padj)

## Order all differentially expressed genes by effect size (the absolute value of log2FoldChange)
res <- res[order(-abs(res$log2FoldChange)),]
res <- subset(res, abs(res$log2FoldChange) > DESeq2_LFC)
write.csv(res, "src/tmp/sample_difexp.txt")
res <- as.data.frame(res)


cols<-!(colnames(res) %in% c("baseMean","lfcSE","stat","pvalue","padj"))
res_subset <- subset(res,,cols)

# Extract data
## Extract genes upregulated
res_up <- res_subset %>% 
  filter(log2FoldChange > 0)
write.csv(res_up, "src/tmp/tmp_up.txt")

## Extract genes downregulated
res_down <- res_subset %>% 
  filter(log2FoldChange < 0)
write.csv(res_down, "src/tmp/tmp_down.txt")

cat('num. of upregulated DEGs: ', nrow(res_up),'\n')
cat('num. of downregulated DEGs:', nrow(res_down))

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
write.csv(normalized_counts, "src/tmp/normalized_counts.txt")