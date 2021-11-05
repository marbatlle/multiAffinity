Load <- function(packages) {
  for(package_name in packages)
  {suppressMessages(suppressWarnings(library(package_name,character.only=TRUE, quietly = TRUE)));}
}
Load(c("tidyverse","dplyr"))

# import table
cts_path<- "output/metaDEGs/metaDEGs.txt"
cts_data <- read.csv(cts_path)

# subset gene names
gene_names <-  cts_data[, c("Name")]
write.table(gene_names, file="output/metaDEGs/degs_names.txt",sep = ",", row.names = FALSE, col.names=FALSE)

# FOR UPREGULATED
# import table
cts_path<- "output/metaDEGs/MetaDEGs_up.txt"
cts_data <- read.csv(cts_path)

# subset gene names
gene_names <-  cts_data[, c("Name")]
write.table(gene_names, file="output/metaDEGs/degs_names_up.txt",sep = ",", row.names = FALSE, col.names=FALSE)

# FOR DOWNREGULATED
# import table
cts_path<- "output/metaDEGs/MetaDEGs_down.txt"
cts_data <- read.csv(cts_path)

# subset gene names
gene_names <-  cts_data[, c("Name")]
write.table(gene_names, file="output/metaDEGs/degs_names_down.txt",sep = ",", row.names = FALSE, col.names=FALSE)
