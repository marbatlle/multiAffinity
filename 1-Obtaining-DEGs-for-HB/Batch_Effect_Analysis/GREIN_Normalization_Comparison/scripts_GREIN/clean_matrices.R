setwd("~/Documents/TFM/GitHub/HB_PublicData")

# Load packages
library(readr)
library(tidyr)

# Load data

## Study A
### Import Matrix
StudyA_data <- read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE81928.csv")

### Clean Matrix
StudyA_data <- aggregate(StudyA_data[,-1], list(StudyA_data$gene_symbol), mean)
rownames(StudyA_data) <- StudyA_data$Group.1
StudyA_data <- subset(StudyA_data, select = -Group.1 )

### Import Metadata
StudyA_meta <- read.csv('1-Obtaining-DEGs-for-HB/Metadata_HB/GSE81928_metadata.csv', row.names=1)

all(rownames(StudyA_meta) %in% colnames(StudyA_data))
StudyA_data <- StudyA_data[, rownames(StudyA_meta)]
all(rownames(StudyA_meta) == colnames(StudyA_data))

### Transform groups
for (i in colnames(StudyA_data)){
  names(StudyA_data)[names(StudyA_data) == i] <- StudyA_meta[i,]
}


## Study B
### Import Matrix
StudyB_data <- read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE89775.csv")

### Clean Matrix
StudyB_data <- aggregate(StudyB_data[,-1], list(StudyB_data$gene_symbol), mean)
rownames(StudyB_data) <-StudyB_data$Group.1
StudyB_data <- subset(StudyB_data, select = -Group.1 )

### Import Metadata
StudyB_meta <- read.csv('1-Obtaining-DEGs-for-HB/Metadata_HB/GSE89775_metadata.csv', row.names=1)

all(rownames(StudyB_meta) %in% colnames(StudyB_data))
StudyB_data <- StudyB_data[, rownames(StudyB_meta)]
all(rownames(StudyB_meta) == colnames(StudyB_data))

### Transform groups
for (i in colnames(StudyB_data)){
  names(StudyB_data)[names(StudyB_data) == i] <- StudyB_meta[i,]
}

## Study C
### Import Matrix
StudyC_data <- read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE104766.csv")

### Clean Matrix
StudyC_data <- aggregate(StudyC_data[,-1], list(StudyC_data$gene_symbol), mean)
rownames(StudyC_data) <-StudyC_data$Group.1
StudyC_data <- subset(StudyC_data, select = -Group.1 )

### Import Metadata
StudyC_meta <- read.csv('1-Obtaining-DEGs-for-HB/Metadata_HB/GSE104766_metadata.csv', row.names=1)

all(rownames(StudyC_meta) %in% colnames(StudyC_data))
StudyC_data <- StudyC_data[, rownames(StudyC_meta)]
all(rownames(StudyC_meta) == colnames(StudyC_data))

### Transform groups
for (i in colnames(StudyC_data)){
  names(StudyC_data)[names(StudyC_data) == i] <- StudyC_meta[i,]
}

## Study D
### Import Matrix
StudyD_data <- read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE133039.csv")

### Clean Matrix
StudyD_data <- aggregate(StudyD_data[,-1], list(StudyD_data$gene_symbol), mean)
rownames(StudyD_data) <-StudyD_data$Group.1
StudyD_data <- subset(StudyD_data, select = -Group.1 )

### Import Metadata
StudyD_meta <- read.csv('1-Obtaining-DEGs-for-HB/Metadata_HB/GSE133039_metadata.csv', row.names=1)

all(rownames(StudyD_meta) %in% colnames(StudyD_data))
StudyD_data <- StudyD_data[, rownames(StudyD_meta)]
all(rownames(StudyD_meta) == colnames(StudyD_data))

### Transform groups
for (i in colnames(StudyD_data)){
  names(StudyD_data)[names(StudyD_data) == i] <- StudyD_meta[i,]
}

## Study E
### Import Matrix
StudyE_data <- read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/norm_matrices/norm_GREIN_GSE151347.csv")

### Clean Matrix
StudyE_data <- aggregate(StudyE_data[,-1], list(StudyE_data$gene_symbol), mean)
rownames(StudyE_data) <-StudyE_data$Group.1
StudyE_data <- subset(StudyE_data, select = -Group.1 )

### Import Metadata
StudyE_meta <- read.csv('1-Obtaining-DEGs-for-HB/Metadata_HB/GSE151347_metadata.csv', row.names=1)

all(rownames(StudyE_meta) %in% colnames(StudyE_data))
StudyE_data <- StudyE_data[, rownames(StudyE_meta)]
all(rownames(StudyE_meta) == colnames(StudyE_data))

### Transform groups
for (i in colnames(StudyE_data)){
  names(StudyE_data)[names(StudyE_data) == i] <- StudyE_meta[i,]
}

# Obtain mean expression data
## Study A
StudyA_means <- as.data.frame( # sapply returns a list here, so we convert it to a data.frame
  sapply(unique(names(StudyA_data)), # for each unique column name
         function(col) rowMeans(StudyA_data[names(StudyA_data) == col]) # calculate row means
  )
)
StudyA_NT <- StudyA_means['Normal']
StudyA_NT['Study'] = 'Study A'
colnames(StudyA_NT) <- c("Expression", 'Study')
write.csv(StudyA_NT,"1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyA_NT.csv", row.names = FALSE)

StudyA_T <- StudyA_means['Hepatoblastoma']
StudyA_T['Study'] = 'Study A'
colnames(StudyA_T) <- c("Expression", 'Study')
write.csv(StudyA_T,"1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyA_T.csv", row.names = FALSE)

## Study B
StudyB_means <- as.data.frame( # sapply returns a list here, so we convert it to a data.frame
  sapply(unique(names(StudyB_data)), # for each unique column name
         function(col) rowMeans(StudyB_data[names(StudyB_data) == col]) # calculate row means
  )
)
StudyB_NT <- StudyB_means['Normal']
StudyB_NT['Study'] = 'Study B'
colnames(StudyB_NT) <- c("Expression", 'Study')
write.csv(StudyB_NT,"1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyB_NT.csv", row.names = FALSE)

StudyB_T <- StudyB_means['Hepatoblastoma']
StudyB_T['Study'] = 'Study B'
colnames(StudyB_T) <- c("Expression", 'Study')
write.csv(StudyB_T,"1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyB_T.csv", row.names = FALSE)


## Study C
StudyC_means <- as.data.frame( # sapply returns a list here, so we convert it to a data.frame
  sapply(unique(names(StudyC_data)), # for each unique column name
         function(col) rowMeans(StudyC_data[names(StudyC_data) == col]) # calculate row means
  )
)
StudyC_NT <- StudyC_means['Normal']
StudyC_NT['Study'] = 'Study C'
colnames(StudyC_NT) <- c("Expression", 'Study')
write.csv(StudyC_NT,"1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyC_NT.csv", row.names = FALSE)

StudyC_T <- StudyC_means['Hepatoblastoma']
StudyC_T['Study'] = 'Study C'
colnames(StudyC_T) <- c("Expression", 'Study')
write.csv(StudyC_T,"1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyC_T.csv", row.names = FALSE)


## Study D
StudyD_means <- as.data.frame( # sapply returns a list here, so we convert it to a data.frame
  sapply(unique(names(StudyD_data)), # for each unique column name
         function(col) rowMeans(StudyD_data[names(StudyD_data) == col]) # calculate row means
  )
)
StudyD_NT <- StudyD_means['Normal']
StudyD_NT['Study'] = 'Study D'
colnames(StudyD_NT) <- c("Expression", 'Study')
write.csv(StudyD_NT,"1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyD_NT.csv", row.names = FALSE)

StudyD_T <- StudyD_means['Hepatoblastoma']
StudyD_T['Study'] = 'Study D'
colnames(StudyD_T) <- c("Expression", 'Study')
write.csv(StudyD_T,"1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyD_T.csv", row.names = FALSE)


## Study E
StudyE_means <- as.data.frame( # sapply returns a list here, so we convert it to a data.frame
  sapply(unique(names(StudyE_data)), # for each unique column name
         function(col) rowMeans(StudyE_data[names(StudyE_data) == col]) # calculate row means
  )
)
StudyE_NT <- StudyE_means['Normal']
StudyE_NT['Study'] = 'Study E'
colnames(StudyE_NT) <- c("Expression", 'Study')
write.csv(StudyE_NT,"1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyE_NT.csv", row.names = FALSE)

StudyE_T <- StudyE_means['Hepatoblastoma']
StudyE_T['Study'] = 'Study E'
colnames(StudyE_T) <- c("Expression", 'Study')
write.csv(StudyE_T,"1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyE_T.csv", row.names = FALSE)




