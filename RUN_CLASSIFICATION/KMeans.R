library(datasets)
library(ggplot2)
library(hash)
# space of work
Chemin = '/home/saber/DA_Stage/Stage/graph/data/' ;
RawData <- read.csv(paste(Chemin, "data.matrix.all.rel.vaccine.10.500.txt" , sep= '') , sep = ';');
#RawData <- read.table("data.rel.vaccine.10.10.txt",sep = ",",header=FALSE)
#print(RawData[1])
#print(length(RawData[,1]))
kc <- kmeans(RawData[,3:length(RawData)], 100)
#plot(RawData[c("V1")], col=kc$cluster)
#
centers <- kc$centers[kc$cluster, ]
distances <- sqrt(rowSums((RawData[,3:length(RawData)] - centers)^2))
outliers <- order(distances, decreasing=T)[1:5]
for(out in outliers)
{
  print(as.character(RawData$id[out]))
}
#
#log(200000/40)
#log(200000/20)*20
plot(RawData[,3:4], pch="o",col=kc$cluster, cex=0.3)
points(kc$centers[,3:4], col=1:3,pch=8, cex=1.5)
points(RawData[outliers, 3:4], pch="+", col=4, cex=1.5)
#RawData$title[5]
# recuperation des clusters
# les clusters
clusters = c(paste("",kc$cluster,sep=""))
vect_hash <- hash(clusters, c(NULL))
for(i in 1:length(kc$cluster))
{
  key_s <- paste("",kc$cluster[i],sep="")
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