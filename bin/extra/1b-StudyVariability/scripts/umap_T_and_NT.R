# Define Functions
library(umap)
library(scales)

plot.HB = function(x, labels,
         main="A UMAP visualization of the HB datasets",
         colors=c("#E64B35B2", "#4DBBD5B2", "#0A087B2", "#3C5488B2", "#F39B7FB2", "#8491B4B2", "#91D1C2B2", "#DC0000B2", "#7E6148B2"),
         pad=0.1, cex=0.6, pch=19, add=FALSE, legend.suffix="",
         cex.main=1, cex.legend=0.85) {
  
  layout = x
  if (is(x, "umap")) {
    layout = x$layout
  } 
  
  xylim = range(layout)
  xylim = xylim + ((xylim[2]-xylim[1])*pad)*c(-0.5, 0.5)
  if (!add) {
    par(mar=c(0.2,0.7,1.2,0.7), ps=10)
    plot(xylim, xylim, type="n", axes=F, frame=F)
    rect(xylim[1], xylim[1], xylim[2], xylim[2], border="#aaaaaa", lwd=0.25)  
  }
  points(layout[,1], layout[,2], col= alpha(colors[as.integer(labels)], 0.1),cex=cex, pch=pch)
  mtext(side=3, main, cex=cex.main)

  labels.u = unique(labels)
  legend.pos = "topleft"
  legend.text = as.character(labels.u)
  if (add) {
    legend.pos = "bottomleft"
    legend.text = paste(as.character(labels.u), legend.suffix)
  }

  legend(legend.pos, legend=legend.text, inset=0.03,
         col=colors[as.integer(labels.u)],
         bty="n", pch=pch, cex=cex.legend)
}

set.seed(264)

## ALL DATA
## Import data
setwd("~/Documents/TFM/HB-multilayer-approach")
library(readr)
df<- as.data.frame(read.csv("1b-StudyVariability/src/T_and_NT.csv", stringsAsFactors=TRUE))

df.data= as.matrix(df[, grep("NT|T", colnames(df))])
df.labels = df[, "Study"]

### Creating a projection
library(umap)
df.umap = umap(df.data)

## These coordinates can be used to visualize the dataset. 
setwd("~/Documents/TFM/HB-multilayer-approach")
png("1b-StudyVariability/output/UMAP_T_and_NT.png", width=3.5, height=3.5, units="in", res=200)
plot.HB(df.umap, df.labels)
dev.off()


# Only DEGs
## Import data
setwd("~/Documents/TFM/HB-multilayer-approach")
df<- as.data.frame(read.csv("1b-StudyVariability/src/T_and_NT_DEGs.csv", stringsAsFactors=TRUE))
df.data= as.matrix(df[, grep("NT|T", colnames(df))])
df.labels = df[, "Study"]

### Creating a projection
df.umap = umap(df.data)
## These coordinates can be used to visualize the dataset. 
setwd("~/Documents/TFM/HB-multilayer-approach")
png("1b-StudyVariability/output/UMAP_T_and_NT_degs.png", width=3.5, height=3.5, units="in", res=200)
plot.HB(df.umap, df.labels)
dev.off()