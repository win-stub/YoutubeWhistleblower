library(ade4)
library(FactoClass)
library(hash)
library(data.table)

Chemin = '/home/saber/DA_Stage/Stage/graph/data_new/' ;
#RawData <- read.csv(paste(Chemin, "data.matrix.ner.10000.10.txt" , sep= '') , sep = ';');
#RawData <- read.big.matrix(paste(Chemin, "data.matrix.ner.10000.10.txt" , sep= '') , sep = ';',type="char")
RawData <- fread(paste(Chemin, "en.data.matrix.meta_REL.10000.10.txt" , sep= '') , sep = ';')
# data sans les id et les titres
#data.train <- subset(RawData, select= -title)
#data.train <- subset(data.train, select= -id)
# 
# les diastances binaires
#for (i in 1:10) 
#{
#  d <- dist.binary(myDF, method = i)
#  cat(attr(d, "method"), is.euclid(d), "\n")
#}
# filtrage des colonnes
tables()
col_name <- c("id","title")
length(colnames(RawData))
for(i in 3:length(colnames(RawData)))
{
  colsums.sum <- sum(RawData[,i,with=FALSE])
  #col_name    <- paste("",colnames(RawData)[i],sep="")
  #if(colsums.sum >=11 & colsums.sum<=20)
  if(colsums.sum >=21)
  {
    col_name    <- c(col_name,colnames(RawData)[i])
  }
  #cat(colsums.sum,';',colnames(RawData)[i],'\n')
  #RawData <- subset(RawData,select= c(col_name))
} 
# selection des colonnes
data.train  <- subset(RawData,select= c(col_name))
# filtrage des lignes
row_name <- c(NULL)
for(i in 1:length(rownames(data.train)))
{
  rowsums.sum <- sum(data.train[i,3:length(colnames(data.train)),with=FALSE])
  #col_name    <- paste("",colnames(RawData)[i],sep="")
  if(rowsums.sum ==0)
  {
    row_name    <- c(row_name,i)
  }
  #cat(rowsums.sum,';',i,'\n')
  #RawData <- subset(RawData,select= c(col_name))
} 
# suppression des lignes
length(row_name)
data.train <- data.train[-row_name,]
# save data filtred
write.table(data.train, 
            file = paste(Chemin, "data.matrix.ner.filter.20.n.txt" , sep= ''), 
            sep = ";", 
            col.names = TRUE  ,
            row.names = FALSE ,
            qmethod = "double")
#
# selection des colonnes
#data.train  <- subset(RawData,select= c(col_name))
#data.train  <- RawData
# clustering
Chemin = '/home/saber/DA_Stage/Stage/graph/data_new/' ;
data.train <- fread(paste(Chemin, "data.matrix.ner.filter.10.20.txt" , sep= '') , sep = ';')
#
data.title  <- subset(data.train,select= c("id","title"))
data.train <- subset(data.train, select= -title)
data.train <- subset(data.train, select= -id)
tables()
RawData     <- NULL
tables()
#
summary(data.train)
is.na(data.train) 
all(!is.na(data.train))
lapply(data.train,function(x) which(is.na(x)))
m <- as.matrix(data.train)
#
dist.data.train <- dist.binary(data.train,method = 1)
cah.ward <- hclust(dist.data.train,method="ward.D2")

dist.data.train <- dist(data.train)
cah.ward <- hclust(dist.data.train,method="ward.D2")

cah.ward <- hclust(dist.data.train,method="ward.D")
cah.ward <- hclust(dist.data.train,method="single")
cah.ward <- hclust(dist.data.train,method="complete")
cah.ward <- hclust(dist.data.train,method="average")
cah.ward <- hclust(dist.data.train,method="mcquitty")
cah.ward <- hclust(dist.data.train,method="median")
cah.ward <- hclust(dist.data.train,method="centroid")
plot(cah.ward)
# dendrogramme avec materialisation des groupes
nb_cluster <- 100
rect.hclust(cah.ward,k=nb_cluster)
# decoupage en 4 groupes
data.train$clusters <-cutree(cah.ward,k=nb_cluster)
# liste des groupes
print(sort(data.train$clusters))
# les clusters
clusters = c(paste("",data.train$clusters,sep=""))
vect_hash <- hash(clusters, c(NULL))
for(i in 1:length(data.train$clusters))
{
  key_s <- paste("",data.train$clusters[i],sep="")
  list_tmp =  c(vect_hash[[key_s]])
  #list_ids <- union(list_tmp,c(paste(as.character(data.title$id[i]),as.character(data.title$title[i]),sep=" --> ")))
  list_ids <- union(list_tmp,c(paste(as.character(data.title$id[i]),as.character(data.title$title[i]),sep=" --> ")))
  #print(list_ids)
  vect_hash[[key_s]] <- list_ids
}
# afficher les clusters avec les titles
zz <- file(paste(Chemin, paste("cluster.ner.single.5.10_",nb_cluster,sep='') , sep= ''), open = "wt")
sink(zz)
for(i in 1:length(vect_hash))
{
  key_s       <- paste("",i,sep="")
  list_titles <- c(vect_hash[[key_s]])
  sink(zz, type = cat('********************************** CLUSTER N : ',i,' Taille  : ',length(list_titles),'\n'))
  for (j in 1:length(list_titles))
    #cat(as.character(list_titles[j]),'\n')
    sink(zz, type = cat(as.character(list_titles[j]),'\n'))
}
sink()