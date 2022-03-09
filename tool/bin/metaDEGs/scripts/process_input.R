## FROM STEP 1.1. Process and adjust the inputs formats

# Load libraries
Load <- function(packages) {
  for(package_name in packages)
  {suppressMessages(suppressWarnings(library(package_name,character.only=TRUE, quietly = TRUE)));}
}
Load(c("tidyverse","readr","data.table","stringr","dplyr"))

exit <- function() { invokeRestart("abort") }

# Define arguments
args = commandArgs(trailingOnly=TRUE)
control_id <- tolower(as.character(args[1]))
sid <- as.character(args[2])

# Import counts matrix
cts_path <- file.path("src/data/counts", paste(sid,".txt", sep = ""))
cts_data <- read.csv(cts_path)

# Clean counts
cts_data <- aggregate(cts_data[,-1], list(cts_data$gene_symbol), mean)
rownames(cts_data) <- cts_data$Group.1
cts_data <- subset(cts_data, select = -c(Group.1,gene_symbol))
cts_data[,]<- lapply(lapply(cts_data[,-1],round),as.integer)

# Import metadata
meta_path  <- file.path("src/data/metadata", paste(sid,".txt", sep = ""))
meta_data <- read.csv(meta_path, row.names=1)

# Clean metadata
filtered_meta <- meta_data

# Remove column if no normal values
no_normals <- c()
for(i in 1:ncol(filtered_meta)) { 
  meta_list <- tolower(filtered_meta[[i]])
  if (any(grepl(control_id, meta_list)) == FALSE) {
    no_normals <- c(no_normals, i)}}

if (length(no_normals) != 0) {
  filtered_meta <- filtered_meta %>% select(!all_of(no_normals))}

# If more than one columns, subset only first one
if (ncol(filtered_meta) > 1) {
  filtered_meta <- filtered_meta[1]}

# Rename column to "tissue"
names(filtered_meta)[1] <- "tissue"
filtered_meta[1] <- tolower(filtered_meta[[1]])

# Transform levels to sample and control
if (ncol(filtered_meta) == 1) {
  filtered_meta <- filtered_meta[grepl('tissue', colnames(filtered_meta))] %>% 
    filter(!str_detect(tissue, 'line')) %>% 
    filter(!str_detect(tissue, 'celline'))
  if (any(filtered_meta$tissue %like% control_id) == TRUE) {
    filtered_meta[filtered_meta$tissue %like% control_id,] <- 'control'
    filtered_meta[filtered_meta$tissue != 'control',] <- 'sample'
    filtered_meta$tissue <- factor(filtered_meta$tissue)} 
  else {
    print("ERROR. It seems like we can't identify the labels. Please, change the control samples' metadata labels argument")
    exit()}} 

# Error Check
if (ncol(filtered_meta) == 0) {
  print("ERROR. It seems like we can't identify the labels. Please, change the control samples' metadata labels argument")
  exit()
}

# Match samples between cts and meta
cts_data <- cts_data[, rownames(filtered_meta)]

# check if df has observations
if (dim(cts_data)[1] == 0) {stop()}

# read gene list
genes_df <- read.table("src/tmp/gene_list.txt")
genes_list <- c(genes_df$V1)

# subset matched genes
cts_data <- cts_data[row.names(cts_data) %in% genes_list, ]

# check if df has observations
if (dim(cts_data)[1] == 0) {stop()}

# exporting data
write.table(cts_data, paste("src/tmp/counts/",sid,"_cts.txt", sep = ""),sep = ",", row.names = TRUE, col.names=TRUE)
write.table(filtered_meta,paste("src/tmp/metadata/",sid,"_meta.txt", sep = ""), sep = ",", row.names = TRUE, col.names=TRUE)