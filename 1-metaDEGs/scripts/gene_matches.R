# load libraries
Load <- function(packages) {
  for(package_name in packages)
  {suppressMessages(suppressWarnings(library(package_name,character.only=TRUE, quietly = TRUE)));}
}
Load(c("tidyverse","dplyr","stringr","data.table"))


# read cts matrix
cts <- read.table("src/tmp/cts.txt", sep=",")

# read gene list
genes_df <- read.table("src/tmp/gene_list.txt")
genes_list <- c(genes_df$V1)

# subset matched genes
final_cts <- cts[row.names(cts) %in% genes_list, ]

# export final cts matrix
write.table(final_cts, file="src/tmp/cts.txt",sep = ",", row.names = TRUE, col.names=TRUE)
