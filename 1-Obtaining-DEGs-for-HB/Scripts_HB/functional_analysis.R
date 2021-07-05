
pacman::p_load(httr,jsonlite,dplyr)

# Get the data
#https://david.abcc.ncifcrf.gov/content.jsp?file=DAVID_API.html
url = paste0("http://david.abcc.ncifcrf.gov/api.jsp?type=ENTREZ_GENE_ID&ids=2919,6347,6348,6364&tool=annotationReport&annot=GOTERM_BP_FAT,GOTERM_CC_FAT,GOTERM_MF_FAT")
raw_result <- httr::GET(url)

# Parse the results
my_content <- httr::content(raw_result)
my_content_from_json <- jsonlite::fromJSON(my_content, flatten = TRUE)
glimpse(my_content)
