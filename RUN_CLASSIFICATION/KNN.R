library(knitr)
library(class)
library(lsa)
#
df$class <- 'NA'
df[hash_class[['WB']],]$class <- 'WB'
df[hash_class[['NWB']],]$class <- 'NWB'
# construct a train database from graph
dim(dtm.filter.matrix)
df.filter.matrix <- data.frame(dtm.filter.matrix)
dim(df.filter.matrix)
# train data
df.filter.matrix$class <- 'NA'
df.filter.matrix[hash_class[['WB']],]$class <- 'WB'
df.filter.matrix[hash_class[['NWB']],]$class <- 'NWB'
dim(df.filter.matrix)
# preparation des donnees et KNN
###
myCorpus_Test <- Corpus(VectorSource(df_test$contents[1:length(df_test$id)]))
myCorpus_Test <- tm_map(myCorpus_Test, content_transformer(tolower))
myCorpus_Test <- tm_map(myCorpus_Test, removeWords, c("person","organization","location"))
dtm_test      <- DocumentTermMatrix(myCorpus_Test,control=list(tokenize =tab_tokenizer))
dtm_test      <- DocumentTermMatrix(myCorpus_Test, control = list(dictionary=dtm$dimnames$Terms))
dtm$dimnames$Terms[1:20]
dtm_test$dimnames$Terms[1:20]
###
dtm_test.matrix <- as.matrix(dtm_test)
dtm_test.matrix[dtm_test.matrix > 0] <- 1

### format IN COSINE
distance_cosine <- c(NULL)
column_predict <- dtm_test.matrix[1,]#dtm.filter.matrix["126",]
### distance cosine
for(i in 1:length(rownames(dtm.filter.matrix)))
{
  distance_tmp        <- cosine(dtm.filter.matrix[i,],column_predict)
  distance_cosine     <- c(distance_cosine,distance_tmp)
}
### distance euclidienne
m_euclidean <- dist(dtm.filter.matrix, method="euclidean")
m_euclidean <- as.matrix(m.euclidean)
### distance euclidean format IN
distance_euclidean <- c(NULL)
for(i in 1:length(rownames(dtm.filter.matrix)))
{
  distance_tmp         <- dist(t(cbind(unlist(dtm.filter.matrix[i,]), unlist(column_predict))), "euclidean")
  distance_euclidean   <- c(distance_euclidean,distance_tmp)
}
### distance binaire jaccard
m_jaccard   <- dist.binary(dtm.filter.matrix,method = 1)
m_jaccard   <- as.matrix(m_jaccard)
### distance jaccard format IN
distance_jaccard <- c(NULL)
for(i in 1:length(rownames(dtm.filter.matrix)))
{
  distance_tmp       <- dist(t(cbind(unlist(dtm.filter.matrix[i,]), unlist(column_predict))), "binary")
  distance_jaccard   <- c(distance_jaccard,distance_tmp)
}
# cosine_predict[1:10]
# m_cosine[76,1:10]
# calcul distances
# d <- dist(dtm.filter.matrix[,1:10], method="cosine")
# d <- as.matrix(d)
KNN_SN <- function(video_predict, distance.matrix, k = 5, with_order)
{
  ordered.neighbors <- order(video_predict, decreasing = with_order) 
  return(ordered.neighbors[2:(k + 1)])
}
#
# order_tmp <- order(cosine_predict, decreasing = TRUE) 
# order_tmp[2:(5 + 1)]
# prediction des nouvelles videos
vect_knn <- KNN_SN(distance_cosine, m_cosine       , k=20,TRUE)
vect_knn <- KNN_SN(distance_euclidean, m_euclidean , k=20,FALSE)
vect_knn <- KNN_SN(distance_jaccard, m_jaccard     , k=20,FALSE)

vect_result <- c(NULL)
for(i in vect_knn)
{
  cat(i,' --> ',rownames(dtm.filter.matrix)[i],' --> ',
                as.character(df[rownames(dtm.filter.matrix)[i],]$id),' --> ',
                as.character(df[rownames(dtm.filter.matrix)[i],]$title),' --> ',
                as.character(df[rownames(dtm.filter.matrix)[i],]$class),'\n')
  vect_result <- c(vect_result,as.character(df[rownames(dtm.filter.matrix)[i],]$class))
}
#
cat(as.character(df_video$id[1]),' --> ',as.character(df_video$title[1]))
table(vect_result)
# 24 35 60 87 92
length(hash_class[['WB']])
length(hash_class[['NWB']])
length(dtm.filter.matrix["126",])
cat(as.character(df[126,]$title),'\t',as.character(df[126,]$class))
as.character(df[76,]$class)
as.character(df[60,]$class)
as.character(df[87,]$class)
as.character(df[92,]$class)
