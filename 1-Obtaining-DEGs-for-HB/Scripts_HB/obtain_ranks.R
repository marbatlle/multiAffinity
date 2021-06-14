library(tidyverse)
library(dplyr)
library(stringr)
library(RobustRankAggreg)

setwd("HB_PublicData/1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB/")
mydir = "Rank_HB"
myfiles = list.files(path=mydir, pattern="*.csv", full.names=TRUE)

# Read DEGs files 
filenames <- list.files(path="HB_PublicData/1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB",
                        pattern="*.csv")

## Create list of data frame names without the ".csv" part 
names <-substr(filenames,1,str_length(filenames)-4)

## Load all files
for(i in names){
  filepath <- file.path("HB_PublicData/1-Obtaining-DEGs-for-HB/DEGs_HB/Ranks_HB",paste(i,".csv",sep=""))
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

# Convert results into csv files
write.csv(agg_down, file = "Aggregated_Downregulated.csv")
write.csv(agg_up, file = "Aggregated_Upregulated.csv")
