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
dtm1.new.matrix[dtm1.new.matrix>=1] <- 1
# CONSTRUCT A MATRIX FOR DTM2
dtm2.new.matrix <- as.matrix(dtm2)
dim(dtm2.new.matrix)
dtm2.new.matrix[dtm2.new.matrix>=1] <- 1
# CONSTRUCT A COSINE MATRIX 1
cos.sim1 <- function(ix) 
{
  A = dtm1.new.matrix[ix[1],]
  B = dtm1.new.matrix[ix[2],]
  
  if((sum(A)*sum(B))==0)
  {
    return(0)
  }
  else
  {
    return( sum(A*B)/sqrt(sum(A^2)*sum(B^2)) )
  }
}   
n <- nrow(dtm1.new.matrix) 
cmb1 <- expand.grid(i=1:n, j=1:n) 
dtm1_cosine <- matrix(apply(cmb1,1,cos.sim1),n,n)
# CONSTRUCT A COSINE MATRIX 2
cos.sim2 <- function(ix) 
{
  A = dtm2.new.matrix[ix[1],]
  B = dtm2.new.matrix[ix[2],]
  if((sum(A)*sum(B))==0)
  {
    return(0)
  }
  else
  {
    return( sum(A*B)/sqrt(sum(A^2)*sum(B^2)) )
  }
}   
n <- nrow(dtm2.new.matrix) 
cmb2 <- expand.grid(i=1:n, j=1:n) 
dtm2_cosine <- matrix(apply(cmb2,1,cos.sim2),n,n)
# la somme des deux matrix
dtm_cosine <- dtm1_cosine+dtm2_cosine
# inspect matrix cosine
dim(dtm1_cosine)
dim(dtm2_cosine)
dtm1_cosine[1:5,1:5]
dtm2_cosine[1:5,1:5]
dtm_cosine[1:5,1:5]
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
# inspect
dtm1$dimnames$Terms[1:20]
dtm_test1$dimnames$Terms[1:20]
dtm2$dimnames$Terms[1:20]
dtm_test2$dimnames$Terms[1:20]
### test1
dtm_test.matrix1 <- as.matrix(dtm_test1)
dtm_test.matrix1[dtm_test.matrix1 > 0] <- 1
dim(dtm_test.matrix1)
### test2
dtm_test.matrix2 <- as.matrix(dtm_test2)
dtm_test.matrix2[dtm_test.matrix2 > 0] <- 1
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
sink(paste("/home/saber/DA_Stage/Stage/graph/train_data/",paste('result_kppv.cosine.test.' ,kproche,sep=''), sep= ''))
for(index_video in 1:dim(dtm_test.matrix1)[1])
{
  distance_cosine1 <- c(NULL)
  column_predict <- dtm_test.matrix1[index_video,]#dtm.filter.matrix["126",]
  ### distance cosine
  for(i in 1:length(rownames(dtm1.new.matrix)))
  {
    distance_tmp        <- cosine(dtm1.new.matrix[i,],column_predict)
    if (is.nan(distance_tmp)==TRUE)
    {
      #cat(distance_tmp,'\t',is.nan(distance_tmp),'\n')
      distance_cosine1     <- c(distance_cosine1,0) 
    }
    else
    {
      distance_cosine1     <- c(distance_cosine1,distance_tmp) 
    }
  }
  ### distance cosine
  distance_cosine2 <- c(NULL)
  column_predict <- dtm_test.matrix2[1,]#dtm.filter.matrix["126",]
  for(i in 1:length(rownames(dtm2.new.matrix)))
  {
    distance_tmp        <- cosine(dtm2.new.matrix[i,],column_predict)
    if (is.nan(distance_tmp)==TRUE)
    {
      #cat(distance_tmp,'\t',is.nan(distance_tmp),'\n')
      distance_cosine2     <- c(distance_cosine2,0) 
    }
    else
    {
      distance_cosine2     <- c(distance_cosine2,distance_tmp) 
    }
  }  
  #length(distance_cosine)
  distance_cosine <- distance_cosine1 +distance_cosine2
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
  vect_knn <- KNN_SN(distance_cosine, dtm_cosine     , k=kproche,TRUE)
  #vect_knn <- KNN_SN(distance_euclidean, m_euclidean , k=20,FALSE)
  #vect_knn <- KNN_SN(distance_jaccard, m_jaccard     , k=20,FALSE)
  
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