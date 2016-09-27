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
#
#load(paste("/home/saber/DA_Stage/Stage/graph/data_new2/REL/REL.40.DF",8,paste(".Rdata","",sep=''),sep=''))
#df8 <- df8[1:9732,]
name_str <- c()
for(index_df in 1:2)
{
  load(paste("/home/saber/DA_Stage/Stage/graph/data_new2/NER/NER.40.DF",index_df,paste(".Rdata","",sep=''),sep=''))
  name_str <- c(name_str,paste("df",index_df,sep=''))
}
#df8 <- df8[1:9732,]
vect_hash <- hash(name_str, NULL)
vect_hash[["df1"]] <- df1
vect_hash[["df2"]] <- df2

for(index_df in 1:2)
{
nb_cluster <- 50  
df <- vect_hash[[paste("df",index_df,sep='')]]
#
myCorpus <- Corpus(VectorSource(df$contents[1:length(df$id)]))
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
myCorpus <- tm_map(myCorpus, removeWords, c("person","organization","location"))
#
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
#
#dtm  <- DocumentTermMatrix(myCorpus, control=list(minDocFreq=1, minWordLength=1))
#dtm  <- DocumentTermMatrix(myCorpus, control=list(wordLengths=c(5, Inf),bounds = list(global = c(10,Inf))))
dtm  <- DocumentTermMatrix(myCorpus, control=list(bounds = list(global = c(10,Inf)),tokenize =tab_tokenizer))
# tokenize avec trigram
#TrigramTokenizer    <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
#BigramTokenizer     <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 3))
#
#dtm$dimnames
dtm.new <- dtm
# freq filter
#words_list <- findFreqTerms(dtm.new, 10)
#pot_words <- c(NULL)
#for(i in 1:length(dtm.new$dimnames$Terms))
#{
#  if(dtm.new$dimnames$Terms[i] %in% words_list)
#  {
#    #cat(list_terms[[1]][j],'\n')
#    pot_words <- c(pot_words,i)
#  } 
#}
# construct a new dtm with filter arguments
#dtm.new <- dtm.new[,pot_words]
# remove dics empty and lda
#dtm.sparse <- removeSparseTerms(dtm.new, 0.95) 
#p_LDA <- LDA(dtm.sparse[1:dtm.sparse$nrow,], control = list(alpha = 0.1), 5)
#post <- posterior(p_LDA, newdata = dtms[1:dtm.sparse$nrow,])
# filter with count rows
row_total = apply(dtm.new, 1, sum)
#remove all docs without words
dtm.filter   <- dtm.new[row_total> 10,]
# lda
p_LDA <- LDA(dtm.filter[1:dtm.filter$nrow,], control = list(alpha = 0.1), 50)
post <- posterior(p_LDA, newdata = dtm.filter[1:dtm.filter$nrow,])
# affiche cluster
list_prop <- c(0.3,0.5,0.60,0.70,0.80,0.90,0.95,0.99)
for (prop in list_prop) 
{
  sink(
    paste("/home/saber/DA_Stage/Stage/graph/data_new2/NER/lda_ner_40_" ,
          paste(index_df,"",sep='')                                    ,
          "/cluster_compund_10000_",paste(nb_cluster,"",sep='')        ,
          paste("_20_10_","",sep='')                                   ,  
          paste(prop,".txt",sep='') , 
          sep= '')
  )
  #prop <- 0.90
  for(i in 1:nb_cluster)
  {
    cat('cluster n --> ',i,' taille --> ',length(dtm.filter$dimnames$Docs[post$topics[,i]>prop]),'\n')
    
    for(id in dtm.filter$dimnames$Docs[post$topics[,i]>prop])
    {
      cat(as.character(df$id[as.numeric(id)]),' --> ',as.character(df$title[as.numeric(id)]),'\n')
    }
    length(dtm.filter$dimnames$Docs[post$topics[,i]>prop])
  }
  sink()  
}
}