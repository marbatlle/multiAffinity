# Load libraries
library(tidyverse)
library(readr)
library(DESeq2)
library(apeglm)
library(RobustRankAggreg)
library(BiocParallel)
register(MulticoreParam(2))


### This script cleans and prepares data downloaded from GREIN

# Import data matrices
## GSE104766
### Import Matrix
cts_GSE104766_path <- "~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/GSE104766_GeneLevel_Raw_data.csv"
cts_GSE104766 <- read.csv(cts_GSE104766_path)

### Clean Matrix
cts_GSE104766 <- aggregate(cts_GSE104766[,-1], list(cts_GSE104766$gene_symbol), mean)
rownames(cts_GSE104766) <- cts_GSE104766$Group.1
cts_GSE104766 <- subset(cts_GSE104766, select = -Group.1)
cts_GSE104766 <- subset(cts_GSE104766, select = -gene_symbol)
cts_GSE104766[,]<- lapply(lapply(cts_GSE104766[,-1],round),as.integer)

## GSE133039
### Import Matrix
cts_GSE133039_path <- "~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/GSE133039_GeneLevel_Raw_data.csv"
cts_GSE133039 <- read.csv(cts_GSE133039_path)

### Clean Matrix
cts_GSE133039 <- aggregate(cts_GSE133039[,-1], list(cts_GSE133039$gene_symbol), mean)
rownames(cts_GSE133039) <- cts_GSE133039$Group.1
cts_GSE133039 <- subset(cts_GSE133039, select = -Group.1 )
cts_GSE133039[,]<- lapply(lapply(cts_GSE133039[,-1],round),as.integer)

## GSE89775
### Import Data
cts_GSE89775_path <- "~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/GSE89775_GeneLevel_Raw_data.csv"
cts_GSE89775<- read.csv(cts_GSE89775_path)

### Clean Matrix
cts_GSE89775 <- aggregate(cts_GSE89775[,-1], list(cts_GSE89775$gene_symbol), mean)
rownames(cts_GSE89775) <- cts_GSE89775$Group.1
cts_GSE89775 <- subset(cts_GSE89775, select = -Group.1 )
cts_GSE89775[,]<- lapply(lapply(cts_GSE89775[,-1],round),as.integer)

## GSE151347
### Import Data
cts_GSE151347_path <- "~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/GSE151347_GeneLevel_Raw_data.csv"
cts_GSE151347 <- read.csv(cts_GSE151347_path)

### Clean Matrix
cts_GSE151347 <- aggregate(cts_GSE151347[,-1], list(cts_GSE151347$gene_symbol), mean)
rownames(cts_GSE151347) <- cts_GSE151347$Group.1
cts_GSE151347 <- subset(cts_GSE151347, select = -Group.1 )
cts_GSE151347[,]<- lapply(lapply(cts_GSE151347[,-1],round),as.integer)

## GSE81928
### Import Data
cts_GSE81928_path <- "~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/GSE81928_GeneLevel_Raw_data.csv"
cts_GSE81928 <- read.csv(cts_GSE81928_path)

all(rownames(coldata_GSE81928) %in% colnames(cts_GSE81928))
cts_GSE81928 <- cts_GSE81928[, rownames(coldata_GSE81928)]
all(rownames(coldata_GSE81928) == colnames(cts_GSE81928))


### Clean Matrix
cts_GSE81928 <- aggregate(cts_GSE81928[,-1], list(cts_GSE81928$gene_symbol), mean)
rownames(cts_GSE81928) <- cts_GSE81928$Group.1
cts_GSE81928 <- subset(cts_GSE81928, select = -Group.1 )
cts_GSE81928[,]<- lapply(lapply(cts_GSE81928[,-1],round),as.integer)

# Import metadata
## GSE104766
### Import Metadata
Meta_GSE104766_path <- '~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Metadata_HB/GSE104766_filtered_metadata.csv'
coldata_GSE104766 <- read.csv(Meta_GSE104766_path, row.names=1)
coldata_GSE104766$tissue <- factor(coldata_GSE104766$tissue)

all(rownames(coldata_GSE104766) %in% colnames(cts_GSE104766))
cts_GSE104766 <- cts_GSE104766[, rownames(coldata_GSE104766)]
all(rownames(coldata_GSE104766) == colnames(cts_GSE104766))

## GSE133039
### Import Metadata
Meta_GSE133039_path <- '~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Metadata_HB/GSE133039_filtered_metadata.csv'
coldata_GSE133039 <- read.csv(Meta_GSE133039_path, row.names=1)
coldata_GSE133039$tissue <- factor(coldata_GSE133039$tissue)

all(rownames(coldata_GSE133039) %in% colnames(cts_GSE133039))
cts_GSE133039 <- cts_GSE133039[, rownames(coldata_GSE133039)]
all(rownames(coldata_GSE133039) == colnames(cts_GSE133039))

## GSE89775
### Import Metadata
Meta_GSE89775_path <- '~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Metadata_HB/GSE89775_filtered_metadata.csv'
coldata_GSE89775 <- read.csv(Meta_GSE89775_path, row.names=1)
coldata_GSE89775$tissue <- factor(coldata_GSE89775$tissue)

all(rownames(coldata_GSE89775) %in% colnames(cts_GSE89775))
cts_GSE133039 <- cts_GSE89775[, rownames(coldata_GSE89775)]
all(rownames(coldata_GSE89775) == colnames(cts_GSE89775))

## GSE151347
### Import Metadata
Meta_GSE151347_path <- '~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Metadata_HB/GSE151347_filtered_metadata.csv'
coldata_GSE151347 <- read.csv(Meta_GSE151347_path, row.names=1)
coldata_GSE151347$tissue <- factor(coldata_GSE151347$tissue)

all(rownames(coldata_GSE151347) %in% colnames(cts_GSE151347))
cts_GSE151347 <- cts_GSE151347[, rownames(coldata_GSE151347)]
all(rownames(coldata_GSE151347) == colnames(cts_GSE151347))

## GSE81928
### Import Metadata
Meta_GSE81928_path <- '~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Metadata_HB/GSE81928_filtered_metadata.csv'
coldata_GSE81928 <- read.csv(Meta_GSE81928_path, row.names=1)
coldata_GSE81928$tissue <- factor(coldata_GSE81928$tissue)

# Matched genes

## Join tables
joined <- merge(cts_GSE104766, cts_GSE81928, by = "X")
joined <- merge(joined, cts_GSE89775, by = "X")
joined <- merge(joined, cts_GSE133039, by = "X")
joined <- merge(joined, cts_GSE151347, by = "X")

## Create genes list
matched_genes <- c(joined$X)  

## Subset
### GSE104766
cts_GSE104766 <- filter(cts_GSE104766, X %in% matched_genes)
### GSE81928
cts_GSE81928 <- filter(cts_GSE81928, X %in% matched_genes)
### GSE89775
cts_GSE89775 <- filter(cts_GSE89775, X %in% matched_genes)
### GSE133039
cts_GSE133039 <- filter(cts_GSE133039, X %in% matched_genes)
### GSE151347
cts_GSE151347 <- filter(cts_GSE151347, X %in% matched_genes)


# Exporting the data
## GSE104766
write.csv(cts_GSE104766, file="~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/GSE104766_raw_data.csv", sep="\t",row.names = TRUE, col.names=TRUE)
write.csv(coldata_GSE104766, file="~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Metadata_HB/GSE89775_metadata.csv", sep="\t",row.names = TRUE, col.names=TRUE)

## GSE133039
write.csv(cts_GSE133039, file="~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/GSE133039_raw_data.csv", sep="\t",row.names = TRUE, col.names=TRUE)
write.csv(coldata_GSE133039, file="~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Metadata_HB/GSE133039_metadata.csv", sep="\t",row.names = TRUE, col.names=TRUE)

## GSE89775
write.csv(cts_GSE89775, file="~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/GSE89775_raw_data.csv", sep="\t",row.names = TRUE, col.names=TRUE)
write.csv(coldata_GSE89775, file="~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Metadata_HB/GSE89775_metadata.csv", sep="\t",row.names = TRUE, col.names=TRUE)


## GSE151347
write.csv(cts_GSE151347, file="~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/GSE151347_raw_data.csv", sep="\t",row.names = TRUE, col.names=TRUE)
write.csv(coldata_GSE151347, file="~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Metadata_HB/GSE151347_metadata.csv", sep="\t",row.names = TRUE, col.names=TRUE)

## GSE81928
write.csv(cts_GSE81928, file="~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Matrices_HB/Originals_HB/GSE81928_raw_data.csv", sep="\t",row.names = TRUE, col.names=TRUE)
write.csv(coldata_GSE81928, file="~/Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/Metadata_HB/GSE81928_metadata.csv", sep="\t",row.names = TRUE, col.names=TRUE)
