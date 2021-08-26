# load libraries
Load <- function(packages) {
  for(package_name in packages)
  {suppressMessages(suppressWarnings(library(package_name,character.only=TRUE, quietly = TRUE)));}
}
Load(c("tidyverse","readr","data.table","stringr"))

exit <- function() { invokeRestart("abort") }

### This script cleans and prepares data downloaded from GREIN

# import counts matrix
cts_path<- "src/tmp/grein_cts.txt"
cts_data <- read.csv(cts_path)

## clean counts
cts_data <- aggregate(cts_data[,-1], list(cts_data$gene_symbol), mean)
rownames(cts_data) <- cts_data$Group.1
cts_data <- subset(cts_data, select = -c(Group.1,gene_symbol))
cts_data[,]<- lapply(lapply(cts_data[,-1],round),as.integer)

# import metadata
meta_path <- "src/tmp/grein_meta.txt"
meta_data <- read.csv(meta_path, row.names=1)

## clean metadata
filtered_meta <- meta_data

### remove column if no normal values
no_normals <- c()
for(i in 1:ncol(filtered_meta)) { 
  meta_list <- filtered_meta[[i]]
  if (any(grepl('ormal', meta_list)) == FALSE) {
    no_normals <- c(no_normals, i)}}

if (length(no_normals) != 0) {
  filtered_meta <- filtered_meta %>% select(!all_of(no_normals))}

### if more than one columns, subset only first one
if (ncol(filtered_meta) > 1) {
  filtered_meta <- filtered_meta[1]}

### Rename column to "tissue"
names(filtered_meta)[1] <- "tissue"

### Transform levels to T and NT
if (ncol(filtered_meta) == 1) {
  filtered_meta <- filtered_meta[grepl('tissue', colnames(filtered_meta))] %>% 
    filter(!str_detect(tissue, 'line')) %>% 
    filter(!str_detect(tissue, 'celline'))
  if (any(filtered_meta$tissue %like% 'ormal') == TRUE) {
    filtered_meta[filtered_meta$tissue %like% 'ormal',] <- 'NT'
    filtered_meta[filtered_meta$tissue %like% 'ackground',] <- 'NT'
    filtered_meta[filtered_meta$tissue != 'NT',] <- 'T'
    filtered_meta$tissue <- factor(filtered_meta$tissue)} 
  else {
    print("Please, change the non-tumour samples' metadata labels to say Normal")
    exit()}} 

# Last check
if (ncol(filtered_meta) == 0) {
  print("ERROR. It seems like we can't identify the labels. Please, change the non-tumour samples' metadata labels to say Normal")
  exit()
}

# match samples between cts and meta
cts_data <- cts_data[, rownames(filtered_meta)]

# exporting data
write.table(cts_data, file="src/tmp/clean_cts.txt",sep = ",", row.names = TRUE, col.names=TRUE)
write.table(filtered_meta, file="src/tmp/clean_meta.txt", sep = ",", row.names = TRUE, col.names=TRUE)