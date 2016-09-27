library(knitr)
library(class)
library(lsa)
library("topicmodels")
library("tm")
library(hash)
library(ggplot2) 
library(cluster)  
library(fpc)
library("stringr")
library(ade4)
library(FactoClass)
library(data.table)
library(igraph)
library(RWeka)
library(dtw)
# Recuperation des donnees datasets DF1 = ALL et DF2 = VACCINE
load("/home/saber/DA_Stage/Stage/graph/train_data/DF1.Rdata")
load("/home/saber/DA_Stage/Stage/graph/train_data/DF2.Rdata")
load("/home/saber/DA_Stage/Stage/graph/train_data/DF.TEST1.Rdata")
load("/home/saber/DA_Stage/Stage/graph/train_data/DF.TEST2.Rdata")
# CONSTRUCT OF CORPUS 1 ALL CLUSTERS
Corpus1 <- Corpus(VectorSource(df1$contents[1:length(df1$id)]))
Corpus1 <- tm_map(Corpus1, content_transformer(tolower))
Corpus1 <- tm_map(Corpus1, removeWords, c("/jj","/nn","/np","/nns","/jjs","/in","/jjr","/nps"))
# CONSTRUCT OF CORPUS 2 PRIVED
Corpus2 <- Corpus(VectorSource(df2$contents[1:length(df2$id)]))
Corpus2 <- tm_map(Corpus2, content_transformer(tolower))
Corpus2 <- tm_map(Corpus2, removeWords, c("/jj","/nn","/np","/nns","/jjs","/in","/jjr","/nps","person","organization","location"))
# tokenizer
tab_tokenizer <- function(x)
{
  list_tokens <- strsplit(as.character(x), "\t+")
  list_tokens_new <- c(NULL)
  for(i in list_tokens)
  {
    tok <- str_trim(i)
    list_tokens_new <- c(list_tokens_new,tok)
  }
  unlist(list_tokens_new)
}
#wordLengths=c(10, Inf),
dtm1  <- DocumentTermMatrix(Corpus1, control=list(bounds = list(global = c(10,Inf)),tokenize =tab_tokenizer))
dtm2  <- DocumentTermMatrix(Corpus2, control=list(tokenize =tab_tokenizer))
#wordLengths=c(10, Inf),bounds = list(global = c(40,Inf)),
dtm1$dimnames$Terms
dtm2$dimnames$Terms
# CONSTRUCT A MATRIX FOR DTM1
dtm1.new.matrix <- as.matrix(dtm1)
dim(dtm1.new.matrix)
#dtm1.new.matrix[dtm1.new.matrix>=1] <- 1
# CONSTRUCT A MATRIX FOR DTM2
dtm2.new.matrix <- as.matrix(dtm2)
dim(dtm2.new.matrix)
#dtm2.new.matrix[dtm2.new.matrix>=1] <- 1
# CONSTRUCT A COSINE MATRIX 1
m.euclidean1 <- dist(dtm1.new.matrix, method="euclidean")
m.euclidean1 <- as.matrix(m.euclidean1)
m.euclidean1[is.nan(m.euclidean1)] <- 0
# CONSTRUCT A COSINE MATRIX 2
m.euclidean2 <- dist(dtm2.new.matrix, method="euclidean")
m.euclidean2 <- as.matrix(m.euclidean2)
m.euclidean2[is.nan(m.euclidean2)] <- 0
# la somme des deux matrix
m.euclidean <- m.euclidean1+m.euclidean2
# inspect matrix cosine
dim(m.euclidean1)
dim(m.euclidean2)
# preparation des donnees et KNN
###
myCorpus_Test1 <- Corpus(VectorSource(df.test1$contents[1:length(df.test1$id)]))
myCorpus_Test1 <- tm_map(myCorpus_Test1, content_transformer(tolower))
myCorpus_Test1 <- tm_map(myCorpus_Test1, removeWords, c("/jj","/nn","/np","/nns","/jjs","/in","/jjr","/nps"))
dtm_test1      <- DocumentTermMatrix(myCorpus_Test1, control = list(dictionary=dtm1$dimnames$Terms,tokenize =tab_tokenizer))
###
myCorpus_Test2 <- Corpus(VectorSource(df.test2$contents[1:length(df.test2$id)]))
myCorpus_Test2 <- tm_map(myCorpus_Test2, content_transformer(tolower))
myCorpus_Test2 <- tm_map(myCorpus_Test2, removeWords, c("/jj","/nn","/np","/nns","/jjs","/in","/jjr","/nps","person","organization","location"))
dtm_test2      <- DocumentTermMatrix(myCorpus_Test2, control = list(dictionary=dtm2$dimnames$Terms,tokenize =tab_tokenizer))
### test1
dtm_test.matrix1 <- as.matrix(dtm_test1)
#dtm_test.matrix1[dtm_test.matrix1 > 0] <- 1
dim(dtm_test.matrix1)
### test2
dtm_test.matrix2 <- as.matrix(dtm_test2)
#dtm_test.matrix2[dtm_test.matrix2 > 0] <- 1
dim(dtm_test.matrix2)
###
seuil <- 1
row_del <- c(NULL)
for(i in 1:dim(dtm_test.matrix1)[1])
{
  sum_row <- sum(dtm_test.matrix1[i,])
  #cat(tdm.new.matrix[i,1:10],' ',sum_row,'\n')
  if(sum_row < seuil)
  {
    row_del <- c(row_del,i)
  }
}
# delete all row or term with seuil defined
#dtm_test.matrix1 <- dtm_test.matrix1[-row_del,]
#dtm_test.matrix2 <- dtm_test.matrix2[-row_del,]
### format IN COSINE
kproche <- 5
#index_video <- 9
sink(paste("/home/saber/DA_Stage/Stage/graph/train_data/",paste('result_kppv_euclidienne.test.tf.',kproche,sep= '') , sep= ''))
for(index_video in 1:dim(dtm_test.matrix1)[1])
{
  distance_euclidien1 <- c(NULL)
  column_predict <- dtm_test.matrix1[index_video,]#dtm.filter.matrix["126",]
  ### distance cosine
  for(i in 1:length(rownames(dtm1.new.matrix)))
  {
    distance_tmp         <- dist(t(cbind(unlist(dtm1.new.matrix[i,]), unlist(column_predict))), "euclidean")
    distance_euclidien1  <- c(distance_euclidien1,distance_tmp)
  }
  distance_euclidien1[is.nan(distance_euclidien1)] <- 0
  ### distance cosine
  distance_euclidien2 <- c(NULL)
  column_predict <- dtm_test.matrix2[index_video,]#dtm.filter.matrix["126",]
  for(i in 1:length(rownames(dtm2.new.matrix)))
  {
    distance_tmp         <- dist(t(cbind(unlist(dtm2.new.matrix[i,]), unlist(column_predict))), "euclidean")
    distance_euclidien2   <- c(distance_euclidien2,distance_tmp)
  }
  distance_euclidien2[is.nan(distance_euclidien2)] <- 0
  #length(distance_cosine)
  distance_euclidien <- distance_euclidien1 +distance_euclidien2
  # KNN FUNCTION
  KNN_SN <- function(video_predict, distance.matrix, k = 5, with_order)
  {
    ordered.neighbors <- order(video_predict, decreasing = with_order) 
    return(ordered.neighbors[2:(k + 1)])
  }
  #
  # order_tmp <- order(cosine_predict, decreasing = TRUE) 
  # order_tmp[2:(5 + 1)]
  # prediction des nouvelles videos
  vect_knn <- KNN_SN(distance_euclidien, m.euclidean , k=kproche,FALSE)
  vect_result <- c(NULL)
  for(i in vect_knn)
  {
    #cat(i,' --> ',rownames(dtm1.new.matrix)[i],' --> ',
    #    as.character(df1[rownames(dtm1.new.matrix)[i],]$id),' --> ',
    #    as.character(df1[rownames(dtm1.new.matrix)[i],]$title),' --> ',
    #    as.character(df1[rownames(dtm1.new.matrix)[i],]$class),'\n')
    vect_result <- c(vect_result,as.character(df1[rownames(dtm1.new.matrix)[i],]$class))
  }
  #
  cat(as.character(df.test1$id[index_video]),' --> ',as.character(df.test1$title[index_video]),'\n')
  rsult <- sort(table(vect_result),TRUE)
  for(i in 1:length(rsult))
  {
    cat(names(rsult[i]),'\t',rsult[i],'\n')
  }
}
sink()