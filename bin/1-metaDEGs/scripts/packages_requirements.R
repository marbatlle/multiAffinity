#!/bin/bash

# BioConductor Packages
Install_Bio <- function(packages) {
  k <- packages[!(packages %in% installed.packages()[,"Package"])];
  if(length(k))
  {BiocManager::install(k);}
}
Install_Bio(c("DESeq2","RobustRankAggreg","IHW"))

# Cran Packages
Install_cran<- function(packages) {
  k <- packages[!(packages %in% installed.packages()[,"Package"])];
  if(length(k))
  {install.packages(k, repos='https://cran.rstudio.com/');}
}
Install_cran(c("tidyverse","data.table","dplyr","stringr"))

