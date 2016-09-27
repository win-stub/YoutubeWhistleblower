library("topicmodels")
library("tm")
library(hash)
library(ggplot2) 
library(cluster)  
library(fpc)

dfs <- paste(df$contents[1:length(df$id)])
myCorpus <- Corpus(VectorSource(dfs))
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
#dtm = DocumentTermMatrix( myCorpus,control = list( wordLengths=c(0,0)))#, 
dtm <- DocumentTermMatrix(myCorpus, control=list(minDocFreq=1, minWordLength=1))
dtm$dimnames
# inspect the corpus exemple
inspect(dtm[,5996:5996])
# calcul des frequences
findFreqTerms(dtm, 50)
# recherche une correlation avec 0.8
findAssocs(dtm, "compound:whistle_blower", 0.7)
inspect(removeSparseTerms(dtm, 0.4))
as.matrix(dtm)

as.matrix(removeSparseTerms(myTdm, .01))
as.matrix(removeSparseTerms(myTdm, .99))
as.matrix(removeSparseTerms(myTdm, .5))
as.matrix(removeSparseTerms(myTdm, .34))
# Explore your data
# order and extract freq
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)   
wf <- data.frame(word=names(freq), freq=freq)   
#head(wf) 
sink("/home/saber/DA_Stage/Stage/graph/data_new/freq_test.txt")
for(i in 1:length(wf$word))
{
  cat(as.character(wf$word[i]),'\t',as.character(wf$freq[i]),'\n')
}
sink()
#graphics histogram terms  
#p <- ggplot(subset(wf, freq>=5), aes(word, freq))    
#p <- p + geom_bar(stat="identity")   
#p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
#p   

# sparse terms
# This makes a matrix that is only p% empty space, maximum.
dtmss <- removeSparseTerms(dtm, 0.99)    
dtmss$dimnames
inspect(dtmss)  
#Hierarchal Clustering
dist.dtmss <- dist(t(dtmss),method="euclidian")
tree       <- hclust(dist.dtmss,method="ward.D2")
# "k=" defines the number of clusters you are using
dtmss$clusters <- cutree(tree, k = 50)
# draw dendogram with red borders around the 5 clusters    
#rect.hclust(fit, k=5, border="red") 
# les clusters
clusters = c(paste("",dtmss$clusters,sep=""))
vect_hash <- hash(clusters, c(NULL))
for(i in 1:length(dtmss$clusters))
{
  key_s <- paste("",dtmss$clusters[i],sep="")
  list_tmp =  c(vect_hash[[key_s]])
  list_ids <- union(list_tmp,c(paste(as.character(df$id[i]),as.character(df$title[i]),sep=" --> ")))
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

### K-means clustering
d <- dist(t(dtmss), method="euclidian")   
kc <- kmeans(d, 
             centers=5, 
             iter.max = 100, 
             algorithm = c("Hartigan-Wong", "Lloyd", "Forgy","MacQueen"), 
             trace=FALSE)
#clusplot(as.matrix(d), kfit$cluster, color=T, shade=T, labels=2, lines=0)  

clusters = c(paste("",kc$cluster,sep=""))
vect_hash <- hash(clusters, c(NULL))
for(i in 1:length(kc$cluster))
{
  key_s <- paste("",kc$cluster[i],sep="")
  list_tmp =  c(vect_hash[[key_s]])
  list_ids <- union(list_tmp,c(paste(as.character(df$id[i]),as.character(df$title[i]),sep=" --> ")))
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