## FROM STEP 1.1. Obtain list with unique list of genes in RNA-Seq studies

# Load libraries
Load <- function(packages) {
  for(package_name in packages)
  {suppressMessages(suppressWarnings(library(package_name,character.only=TRUE, quietly = TRUE)));}
}
Load(c("tidyverse","dplyr","stringr","data.table"))
startwd <- getwd()
setwd("src/data/counts/")
file_list <- list.files()
for (file in file_list){

  # If the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- fread(file, select = c("gene_symbol"))
  }

  # If the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <- fread(file, select = c("gene_symbol"))
    dataset<- merge(dataset, temp_dataset, by=c("gene_symbol"))
    dataset <- dataset %>% distinct()
    rm(temp_dataset)
  }
}
setwd(startwd)

# Export gene list
write.table(dataset, file = "src/tmp/gene_list.txt", sep = ",", col.names = FALSE, row.names = FALSE)

