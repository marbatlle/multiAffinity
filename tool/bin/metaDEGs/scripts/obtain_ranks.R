## FROM STEP 1.3. Run RobustRankAggreg

Load <- function(packages) {
  for(package_name in packages)
  {suppressMessages(suppressWarnings(library(package_name,character.only=TRUE, quietly = TRUE)));}
}
Load(c("tidyverse","dplyr","stringr","RobustRankAggreg","data.table"))

# Set Arguments
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
glist_down <- Filter(function(x) is(x, "matrix"), mget(ls()))
r_down = rankMatrix(glist_down, full = TRUE)
agg_down <- aggregateRanks(rmat = r_down, method = "RRA")
agg_down <- subset(agg_down, agg_down$Score < RRA_Score)
agg_down <- as.data.frame(agg_down)

rm(list = ls(pattern="DEGs_down"))
rm(list = ls(pattern="r_down"))

# Upregulated
## ead DEGs files 
filenames <- list.files(path="src/tmp/degs", pattern="*up.txt")

## Create list of data frame names without the ".txt" part 
names <-substr(filenames,1,str_length(filenames)-4)

## Load all files
for(i in names){
  filepath <- file.path("src/tmp/degs",paste(i,".txt",sep=""))
  assign(i, as.matrix(fread(filepath, select = 1), byrow = TRUE))
}

## Aggregate Ranks
glist_up <- Filter(function(x) is(x, "matrix"), mget(ls()))
r_up = rankMatrix(glist_up, full = TRUE)
agg_up <- aggregateRanks(rmat = r_up, method = "RRA")
agg_up <- subset(agg_up, agg_up$Score < RRA_Score)
agg_up <- as.data.frame(agg_up)

## Remove duplicates
names_down  <- as.list(agg_down[['Name']])
names_up  <- as.list(agg_up[['Name']])
names_intersect <- intersect(names_up, names_down)
agg_down <- agg_down[ ! agg_down$Name %in% names_intersect, ]
agg_up <- agg_up[ ! agg_up$Name %in% names_intersect, ]

## if in both delete
rm(list = ls(pattern="DEGs_up"))
rm(list = ls(pattern="r_up"))

# Create unique DEGs list
genes <- rbind(agg_down,agg_up)
colnames(genes) <- c("Name","Score")
genes <- genes[order(genes$Score),]

# Save num. of DEGs for report
paste("num. of upregulated DEGs: ", collapse = '\n') %>% cat()
paste(nrow(agg_up), collapse = '\n') %>% cat()
paste("\n", collapse = '\n') %>% cat()
paste("num. of downregulated DEGs: ", collapse = '\n') %>% cat()
paste(nrow(agg_down), collapse = '\n') %>% cat()

# Convert results into csv files
write.table(genes, "output/metaDEGs/metaDEGs.txt", sep=",", row.names=FALSE)

# subset gene names
gene_names <-  genes[, c("Name")]

write.table(gene_names, file="output/metaDEGs/degs_names.txt",sep = ",", row.names = FALSE, col.names=FALSE)