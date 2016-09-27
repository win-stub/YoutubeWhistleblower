##########################################################################################
#                                  Loading Data                                          #
##########################################################################################
Chemin = '/home/saber/DA_Stage/Stage/graph/data_new/'
cname <- file.path(Chemin, "lda")   
cname   
dir(cname)   
##########################################################################################
Chemin = '/home/saber/DA_Stage/Stage/graph/data_new2/NER/'
df <- read.csv(paste(Chemin, "data.lda.rel.50.10.txt" , sep= '') , sep = ';')
df <- read.csv(paste(Chemin, "en.data.lda.meta_REL.10000.10.txt" , sep= '') , sep = ';')
df <- read.csv(paste(Chemin, "en.data.lda.meta_REL.30000.10.txt" , sep= '') , sep = ';')
df <- read.csv(paste(Chemin, "en.data.lda.meta_NER.10000.10.txt" , sep= '') , sep = ';')
df <- read.csv(paste(Chemin, "en.data.lda.filtred.meta_NG.10000.10.txt" , sep= '') , sep = ';')
df <- read.csv(paste(Chemin, "en.data.lda.filtred.meta_NER.10000.10.txt" , sep= '') , sep = ';')
df <- read.csv(paste(Chemin, "en.data.lda.filtred.meta_REL.10000.10.txt" , sep= '') , sep = ';')
##########################################################################################
Chemin = '/home/saber/DA_Stage/Stage/graph/train_data/'
df1      <- read.csv(paste(Chemin, "data.train.ng.txt",sep= '') ,sep =';')
df2      <- read.csv(paste(Chemin, "data.train.vaccine.patterns.txt" , sep= ''), sep =';')
df.test1  <- read.csv(paste(Chemin, "en.data.search.meta_NG.23.10.txt" , sep= ''), sep =';')
df.test2  <- read.csv(paste(Chemin, "en.data.search.meta_PATTERNS.23.10.txt" , sep= ''), sep =';')
# trait dtfm[!dtfm$C == "Foo", ]
empty_chr = character(0)
sink(paste("/home/saber/DA_Stage/Stage/graph/train_data/",'vide' , sep= ''))
for(i in 1:length(df.test1$id))
{
  if(length(str_trim(as.character(df.test1$contents[i])))!=length(empty_chr))
  {
    #cat(as.character(df.test1$id[i]),'\n')
    cat(length(str_trim(as.character(df.test1$contents[i]))),'\n')
  }
}
sink()
#
save(df1, file="/home/saber/DA_Stage/Stage/graph/train_data/DF1.Rdata")
save(df2, file="/home/saber/DA_Stage/Stage/graph/train_data/DF2.Rdata")
save(df.test1, file="/home/saber/DA_Stage/Stage/graph/train_data/DF.TEST1.Rdata")
save(df.test2, file="/home/saber/DA_Stage/Stage/graph/train_data/DF.TEST2.Rdata")
##########################################################################################
# echantillonnage
gc()
df   <- read.csv(paste(Chemin, "en.data.lda.filtred.meta_NG.349679.40.txt" , sep= '') , sep = ';')
df   <- read.csv(paste(Chemin, "en.data.lda.filtred.meta_REL.349679.40.txt" , sep= '') , sep = ';')
df   <- read.csv(paste(Chemin, "en.data.lda.filtred.meta_NER.349679.40.txt" , sep= '') , sep = ';')

save(df, file="/home/saber/DA_Stage/Stage/graph/data_new2/NER/NER.40.ALL.Rdata")
length(df$id)
df1  <- df[1:10000,]
df2  <- df[10001:16562,]
df3  <- df[20001:30000,]
df4  <- df[30001:40000,]
df5  <- df[40001:50000,]
df6  <- df[50001:60000,]
df7  <- df[70001:71269,]
df8  <- df[80001:90000,]
df9  <- df[90001:100000,]
df10 <- df[100001:109633,]
###
save(df1, file="/home/saber/DA_Stage/Stage/graph/data_new2/NER/NER.40.DF1.Rdata")
save(df2, file="/home/saber/DA_Stage/Stage/graph/data_new2/NER/NER.40.DF2.Rdata")
save(df3, file="/home/saber/DA_Stage/Stage/graph/data_new2/REL/REL.40.DF3.Rdata")
save(df4, file="/home/saber/DA_Stage/Stage/graph/data_new2/REL/REL.40.DF4.Rdata")
save(df5, file="/home/saber/DA_Stage/Stage/graph/data_new2/REL/REL.40.DF5.Rdata")
save(df6, file="/home/saber/DA_Stage/Stage/graph/data_new2/REL/REL.40.DF6.Rdata")
save(df7, file="/home/saber/DA_Stage/Stage/graph/data_new2/REL/REL.40.DF7.Rdata")
df8 <- df8[1:9732,]
save(df8, file="/home/saber/DA_Stage/Stage/graph/data_new2/REL/REL.40.DF8.Rdata")
save(df9, file="/home/saber/DA_Stage/Stage/graph/data_new2/REL/REL.40.DF9.Rdata")
save(df10, file="/home/saber/DA_Stage/Stage/graph/data_new2/REL/REL.40.DF10.Rdata")
## LOAD
load("/home/saber/DA_Stage/Stage/graph/data_new2/NG/NG.40.DF3.Rdata")
##########################################################################################
Chemin = '/home/saber/DA_Stage/Stage/graph/data_new/'
df_test  <- read.csv(paste(Chemin, "en.data.lda.meta_NER.100000.10.txt" , sep= '') , sep = ';')
df_video <- read.csv(paste(Chemin, "en.data.lda.meta_NER.1.1.txt" , sep= '') , sep = ';')
df_test <- df_test[10001:10500,]
##########################################################################################
myCorpus_Test <- Corpus(VectorSource(df_video$contents[1:length(df_video$id)]))
myCorpus_Test <- tm_map(myCorpus_Test, content_transformer(tolower))
myCorpus_Test <- tm_map(myCorpus_Test, removeWords, c("person","organization","location"))
dtm_test      <- DocumentTermMatrix(myCorpus_Test,control=list(tokenize =tab_tokenizer))
dtm_test      <- DocumentTermMatrix(myCorpus_Test, control = list(dictionary=dtm$dimnames$Terms))
findFreqTerms(dtm_test,4)
row_total = apply(dtm_test, 1, sum)

##########################################################################################
library("wordnet")

getFilterTypes()
filter <- getTermFilter("ContainsFilter", "compound:porn_industry_shut_down", TRUE)
terms <- getIndexTerms("NOUN", 5, filter)
sapply(terms, getLemma)
a <- c(1,2,3,4,5,6)
b <- c(10,10,10,10,10,10)
c <- a+b


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
seuil <- 1
row_del <- c(NULL)
for(i in 1:dim(dtm_test.matrix)[1])
{
  sum_row <- sum(dtm_test.matrix[i,])
  #cat(tdm.new.matrix[i,1:10],' ',sum_row,'\n')
  if(sum_row < seuil)
  {
    row_del <- c(row_del,i)
  }
}
# delete all row or term with seuil defined
dtm_test.matrix <- dtm_test.matrix[-row_del,]