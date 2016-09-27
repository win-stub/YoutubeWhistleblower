library(ade4)
library(FactoClass)
library(hash)
library(data.table)

str(iris)
myDF <- subset(iris, select= -Species)
str(myDF)

Chemin = '/home/saber/DA_Stage/Stage/graph/data_new/' ;
RawData <- read.csv(paste(Chemin, "data.matrix.ner.10000.10.txt" , sep= '') , sep = ';');
#afficher les 6 premieres lignes
print(head(RawData))
#stat. descriptives
print(summary(RawData))
#graphique 
pairs(RawData[,5:6])

myDF <- subset(RawData, select= -title)
myDF <- subset(myDF, select= -id)
AFC <- dudi.coa(df=myDF, scannf=FALSE, nf=ncol(myDF))
plot.dudi(AFC)

dist.myDF <- dist.binary(myDF,method = 1)
cah.ward <- hclust(dist.myDF,method="ward.D2")
#affichage dendrogramme
plot(cah.ward)
# 
for (i in 1:10) 
{
  d <- dist.binary(myDF, method = i)
  cat(attr(d, "method"), is.euclid(d), "\n")
}


distMat <- dist.dudi(AFC, amongrow=TRUE)
CAH <- ward.cluster(distMat, peso = apply(X=myDF, MARGIN=1, FUN=sum) , plots = TRUE, h.clust = 1)
#CAH <- ward.cluster(distMat, plots = TRUE, h.clust = 1)

par(mfrow=c(1,2))
barplot(sort(CAH$height / sum(CAH$height), decreasing = TRUE)[1:15] * 100,
        xlab = "Noeuds", ylab = "Part de l'inertie totale (%)",
        names.arg=1:15, main="Inertie selon le partitionnement")

barplot(cumsum(sort(CAH$height / sum(CAH$height), decreasing = TRUE))[1:15] * 100,
        xlab = "Nombre de classes", ylab = "Part de l'inertie totale (%)",
        names.arg=1:15, main="Inertie expliquee")

par(mfrow=c(1,1))
plot(as.dendrogram(CAH), leaflab = "none")

myDF$clusters <- cutree(tree = CAH, k = 5)

# les clusters
clusters = c(paste("",myDF$clusters,sep=""))
vect_hash <- hash(clusters, c(NULL))
for(i in 1:length(myDF$clusters))
{
  key_s <- paste("",myDF$clusters[i],sep="")
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




s.class(cstar=1,addaxes=TRUE, grid=TRUE, axesell=TRUE,
        dfxy=AFC$li, fac=as.factor(myDF$clusters), col=1:3,
        label=c(1:3), csub=1.2, possub="bottomright")

plot.dudi(AFC, Tcol = TRUE, Trow = FALSE)

s.class(cstar=1,addaxes=TRUE, grid=FALSE, axesell=TRUE,
        dfxy=AFC$li, fac=as.factor(myDF$clusters), col=1:3,
        label=c(1:3), csub=1.2, possub="bottomright", add=TRUE)

# On charge des fonctions crees par Romain Francois - http://blog.r-enthusiasts.com/
source("http://addictedtor.free.fr/packages/A2R/lastVersion/R/code.R")
ordreClasses <- unique(myDF$cluster[CAH$order])
A2Rplot(x = CAH, k = 3, boxes = FALSE,  col.up = "gray50", col.down = c(1:3)[ordreClasses], show.labels = FALSE, main = "Dendrogramme")