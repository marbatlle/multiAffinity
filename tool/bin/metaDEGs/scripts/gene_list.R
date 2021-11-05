# load libraries
Load <- function(packages) {
  for(package_name in packages)
  {suppressMessages(suppressWarnings(library(package_name,character.only=TRUE, quietly = TRUE)));}
}
Load(c("tidyverse","dplyr","stringr","data.table"))

setwd("src/tmp/counts/")
file_list <- list.files()
for (file in file_list){

  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- fread(file, select = 1)
  }

  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <- fread(file, select = 1)
    dataset<- merge(dataset, temp_dataset, by=c("V1"))
    rm(temp_dataset)
  }
}
dataset %>% distinct()
write.table(dataset, file = "gene_list.txt", sep = ",", col.names = FALSE, row.names = FALSE)

