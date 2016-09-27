library("FactoMineR")
library(hash)

# space of work
Chemin = "/home/saber/DA_Stage/Stage/graph/data/"
RawData <- read.csv(paste(Chemin, "data.matrix.rel.vaccine.10.200000.txt" , sep= '') , sep = ';');

# affichage des data
is.data.frame(RawData)
RawData
ncol(RawData)
nrow(RawData)
rownames(RawData)
as.character(RawData$title[3])
#
#
res.pca <- PCA(RawData[,3:ncol(RawData)], graph=FALSE)
hc <- HCPC(res.pca, nb.clust=-1)
# les clusters
clusters = c(paste("",hc$data.clust[["clust"]],sep=""))
vect_hash <- hash(clusters, c(NULL))
for(i in 1:length(hc$data.clust[["clust"]]))
{
  key_s <- paste("",hc$data.clust[["clust"]][i],sep="")
  list_tmp =  c(vect_hash[[key_s]])
  list_ids <- union(list_tmp,c(paste(as.character(RawData$id[i]),as.character(RawData$title[i]),sep=" --> ")))
  #print(list_ids)
  vect_hash[[key_s]] <- list_ids
}
# afficher les clusters avec les titles
for(i in 1:length(vect_hash))
{
  key_s       <- paste("",i,sep="")
  list_titles <- c(vect_hash[[key_s]])
  cat('********************************** CLUSTER N : ',i,' Taille  : ',length(list_titles),'\n')
  for (j in 1:length(list_titles))
    cat(as.character(list_titles[j]),'\n')
}
