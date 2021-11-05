Load <- function(packages) {
  for(package_name in packages)
  {suppressMessages(suppressWarnings(library(package_name,character.only=TRUE, quietly = TRUE)));}
}
Load(c("waddR"))

# get the input passed from the shell script
args <- commandArgs(trailingOnly = TRUE)

waddR_pval=as.numeric(args[1])
waddR_permnum=as.numeric(100)

# import means
Study1_df <- read.csv('output/means/Study1_mean.txt')
Study2_df <- read.csv('output/means/Study2_mean.txt')

# transform to arrays
Study1 <- unlist(Study1_df$Expression)
set.seed(64)
Study1 <- sample(Study1, 500, replace=TRUE)
Study2 <- unlist(Study2_df$Expression)
set.seed(64)
Study2 <- sample(Study2, 500, replace=TRUE)

# Test Wasserstein
spec.output<-c("pval")
res <- wasserstein.test(Study1,Study2,method="SP",permnum=waddR_permnum)[spec.output]
print(res < waddR_pval)
print(res)

