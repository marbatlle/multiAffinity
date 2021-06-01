## set wd and prepare environment
library(GEOquery)
library(rio)
library(dplyr)
library(readr)
setwd("~/Documents/TFM/May/HB-PublicData/Task1_ObtainingDesregulatedGenes")

# GSE89775

## metadata
### download geo data
gse <- getGEO('GSE89775')
gse <- gse$GSE89775_series_matrix.txt.gz
### create metadata df
pd <- pData(gse)
metadata <- data.frame(pd$"title", pd$"tissue:ch1") %>% 
            mutate(series = 'GSE89775') %>%
            rename(
                   sample = pd.title,
                   type = pd..tissue.ch1.)
### export metadata
export(metadata,"HB_GSE89775_METADATA.tsv")


# GSE104766
## download geo data
gse.2 <- getGEO('GSE104766')
gse.2 <- gse.2$GSE104766_series_matrix.txt.gz
## create metadata df
pd.2<- pData(gse.2)
metadata.2 <- data.frame(pd.2$"title", pd.2$"tissue:ch1") %>% 
              mutate(series = 'GSE104766') %>%
              rename(
                      sample = pd.2.title,
                      type = pd.2..tissue.ch1.)
## export metadata
export(metadata.2,"HB_GSE104766_METADATA.tsv")


# GSE151347
## download geo data
gse.3 <- getGEO('GSE151347')
gse.3 <- gse.3$GSE151347_series_matrix.txt.gz
## create metadata df
pd.3<- pData(gse.3)
metadata.3 <- data.frame(pd.3$"title", pd.3$"tissue type:ch1") %>% 
              mutate(series = 'GSE151347') %>%
              rename(
                      sample = pd.3.title,
                      type = pd.3..tissue.type.ch1.)

## export metadata
export(metadata.3,"HB_GSE151347_METADATA.tsv")

# join all 3 metadata df
metadata.final <- rbind(metadata, metadata.2, metadata.3)
export(metadata.final,"HB_joint_METADATA.tsv")


