## FROM STEP 1.2. Run paired Wasserstein test

Load <- function(packages) {
  for(package_name in packages)
  {suppressMessages(suppressWarnings(library(package_name,character.only=TRUE, quietly = TRUE)));}
}
Load(c("waddR","dplyr"))

# Set Arguments
args <- commandArgs(trailingOnly = TRUE)

waddR_pval <- as.numeric(args[1])
study1=as.character(args[2])
study2 <- as.character(args[3])

# Import means
Study1_path <- file.path("output/means", paste(study1,"_mean.txt", sep = ""))
Study1_df <- read.csv(Study1_path)
Study2_path <- file.path("output/means", paste(study2,"_mean.txt", sep = ""))
Study2_df <- read.csv(Study2_path)

# Transform to arrays
Study1 <- unlist(Study1_df$Expression)
set.seed(64)
Study1 <- sample(Study1, 500, replace=TRUE)
Study2 <- unlist(Study2_df$Expression)
set.seed(64)
Study2 <- sample(Study2, 500, replace=TRUE)

# Test Wasserstein
spec.output<-c("pval")
res <- as.data.frame(wasserstein.test(Study1,Study2,method="SP",permnum=100)[spec.output])
res <- round(res,2)
paste(res, collapse = '\n') %>% cat()

print('check')

