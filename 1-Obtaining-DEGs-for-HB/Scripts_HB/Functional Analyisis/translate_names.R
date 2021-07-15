library('biomaRt')
library(readr)

mart <- useDataset("hsapiens_gene_ensembl", useMart("ensembl"))

# Upregulated
upregulated <- read_csv("Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/DEGs_HB/HB_db_DEG_Upregulated.csv", col_types = cols_only(Name = col_guess()))
upregulated <- upregulated$Name
upregulated <- getBM(filters= "hgnc_symbol", attributes= c("hgnc_symbol","ensembl_gene_id","entrezgene_id"),values=upregulated,mart= mart)

write.table(upregulated, file="Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/DEGs_HB/upregulated_translated.csv", sep="\t")

# Downregulated
downregulated <- read_csv("Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/DEGs_HB/HB_db_DEG_Downregulated.csv", col_types = cols_only(Name = col_guess()))
downregulated <- downregulated$Name
downregulated <- getBM(filters= "hgnc_symbol", attributes= c("hgnc_symbol","ensembl_gene_id","entrezgene_id"),values=downregulated,mart= mart)

write.table(downregulated, file="Documents/TFM/GitHub/HB_PublicData/1-Obtaining-DEGs-for-HB/DEGs_HB/downregulated_translated.csv", sep="\t")