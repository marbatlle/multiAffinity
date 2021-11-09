Load <- function(packages) {
  for(package_name in packages)
  {suppressMessages(suppressWarnings(library(package_name,character.only=TRUE, quietly = TRUE)));}
}
Load(c("tidyverse","dplyr","stringr","RobustRankAggreg","data.table"))

# get the input passed from the shell script
args <- commandArgs(trailingOnly = TRUE)
RRA_Score=as.numeric(args[1])

# Downregulated
##Read DEGs files 
filenames <- list.files(path="src/tmp/degs", pattern="*down.txt")

## Create list of data frame names without the ".txt" part 
names <-substr(filenames,1,str_length(filenames)-4)

## Load all files
for(i in names){
  filepath <- file.path("src/tmp/degs",paste(i,".txt",sep=""))
  assign(i, as.matrix(fread(filepath, select = 1), byrow = TRUE))
}

## Aggregate Ranks
#set.seed(64)
glist_down <- Filter(function(x) is(x, "matrix"), mget(ls()))
r_down = rankMatrix(glist_down, full = TRUE)
agg_down <- aggregateRanks(rmat = r_down, method = "RRA")
agg_down <- subset(agg_down, agg_down$Score < RRA_Score)
agg_down <- as.data.frame(agg_down)

rm(list = ls(pattern="DEGs_down"))
rm(list = ls(pattern="r_down"))

# Upregulated
##Read DEGs files 
filenames <- list.files(path="src/tmp/degs", pattern="*up.txt")

## Create list of data frame names without the ".txt" part 
names <-substr(filenames,1,str_length(filenames)-4)

## Load all files
for(i in names){
  filepath <- file.path("src/tmp/degs",paste(i,".txt",sep=""))
  assign(i, as.matrix(fread(filepath, select = 1), byrow = TRUE))
}

## Aggregate Ranks
#set.seed(64)
glist_up <- Filter(function(x) is(x, "matrix"), mget(ls()))
r_up = rankMatrix(glist_up, full = TRUE)
agg_up <- aggregateRanks(rmat = r_up, method = "RRA")
agg_up <- subset(agg_up, agg_up$Score < RRA_Score)
agg_up <- as.data.frame(agg_up)

rm(list = ls(pattern="DEGs_up"))
rm(list = ls(pattern="r_up"))

# Create unique DEGs list
genes <- rbind(agg_down,agg_up)
colnames(genes) <- c("Name","Score")
genes <- genes[order(genes$Score),]

# Convert results into csv files
write.table(agg_down, "output/metaDEGs/MetaDEGs_down.txt",sep=",", row.names=FALSE)
write.table(agg_up, "output/metaDEGs/MetaDEGs_up.txt", sep=",",row.names=FALSE)
write.table(genes, "output/metaDEGs/metaDEGs.txt", sep=",", row.names=FALSE)

# import table
cts_path<- "output/metaDEGs/metaDEGs.txt"
cts_data <- read.csv(cts_path)

# subset gene names
gene_names <-  cts_data[, c("Name")]

write.table(gene_names, file="output/metaDEGs/degs_names.txt",sep = ",", row.names = FALSE, col.names=FALSE)