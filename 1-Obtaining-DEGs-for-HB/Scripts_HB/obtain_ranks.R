library(tidyverse)
library(dplyr)
library(stringr)
library(RobustRankAggreg)

# Read DEGs files 
filenames <- list.files(path="1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB",
                        pattern="*.csv")

## Create list of data frame names without the ".csv" part 
names <-substr(filenames,1,str_length(filenames)-4)

## Load all files
for(i in names){
  filepath <- file.path("1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB",paste(i,".csv",sep=""))
  assign(i, read.csv(filepath,colClasses=c("character","double","double"))) 
}

# Rank downregulated
## Rename columns
colnames(GSE133039_DEGs_down)[1] <- "genes"
colnames(GSE151347_DEGs_down)[1] <- "genes"
colnames(GSE104766_DEGs_down)[1] <- "genes"
colnames(GSE81928_DEGs_down)[1] <- "genes"
colnames(GSE89775_DEGs_down)[1] <- "genes"

## Lists
GSE133039_DEGs_down <- GSE133039_DEGs_down %>%
  pull(var=1) %>%
  as.matrix(nrow=1)
GSE151347_DEGs_down <- GSE151347_DEGs_down %>%
  pull(var=1) %>%
  as.matrix(nrow=1)
GSE104766_DEGs_down <- GSE104766_DEGs_down %>%
  pull(var=1) %>%
  as.matrix(nrow=1)
GSE81928_DEGs_down <- GSE81928_DEGs_down %>%
  pull(var=1) %>%
  as.matrix(nrow=1)
GSE89775_DEGs_down <- GSE89775_DEGs_down %>%
  pull(var=1) %>%
  as.matrix(nrow=1)

## Aggregate Ranks
glist_down <- list(GSE133039_DEGs_down, GSE151347_DEGs_down, GSE104766_DEGs_down)
r_down = rankMatrix(glist_down, full = TRUE)
agg_down <- aggregateRanks(rmat = r_down, method = "RRA")

# Rank upregulated
## Rename column
colnames(GSE133039_DEGs_up)[1] <- "genes"
colnames(GSE151347_DEGs_up)[1] <- "genes"
colnames(GSE104766_DEGs_up)[1] <- "genes"
colnames(GSE81928_DEGs_up)[1] <- "genes"
colnames(GSE89775_DEGs_up)[1] <- "genes"

## Lists
GSE133039_DEGs_up <- GSE133039_DEGs_up %>%
  pull(var=1) %>%
  as.matrix(nrow=1)
GSE151347_DEGs_up <- GSE151347_DEGs_up %>%
  pull(var=1) %>%
  as.matrix(nrow=1)
GSE104766_DEGs_up <- GSE104766_DEGs_up %>%
  pull(var=1) %>%
  as.matrix(nrow=1)
GSE81928_DEGs_up <- GSE81928_DEGs_up %>%
  pull(var=1) %>%
  as.matrix(nrow=1)
GSE89775_DEGs_up <- GSE89775_DEGs_up %>%
  pull(var=1) %>%
  as.matrix(nrow=1)

## Aggregate Ranks
glist_up <- list(GSE133039_DEGs_up, GSE151347_DEGs_up, GSE104766_DEGs_up)
r_up = rankMatrix(glist_up, full = TRUE)
agg_up <- aggregateRanks(rmat = r_up, method = "RRA")

# Combine both lists
genes_down <- list(agg_down$Name)
genes_up <- list(agg_up$Name)
combineListsAsOne <-function(list1, list2){
  n <- c()
  for(x in list1){
    n<-c(n, x)
  }
  for(y in list2){
    n<-c(n, y)
  }
  return(n)
}
genes <- combineListsAsOne(genes_down, genes_up)


# Convert results into csv files
write.csv(agg_down, file = "1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Aggregated_Downregulated.csv", row.names=FALSE)
write.csv(agg_up, file = "1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/Aggregated_Upregulated.csv", row.names=FALSE)
write.table(genes, file = "1-Obtaining-DEGs-for-HB/DEGs_HB/HB_db_DEG.csv",sep=",", row.names=FALSE, col.names=FALSE)
