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
#
load("/home/saber/DA_Stage/Stage/graph/data_new2/REL/REL.40.DF5.Rdata")
df <- df5
#
myCorpus <- Corpus(VectorSource(paste(df$contents[1:length(df$id)])))
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
#
#dtm  <- DocumentTermMatrix(myCorpus, control=list(minDocFreq=1, minWordLength=1))
#dtm  <- DocumentTermMatrix(myCorpus, control=list(wordLengths=c(10, Inf),bounds = list(global = c(10,Inf))))
#dtm  <- DocumentTermMatrix(myCorpus, control=list(bounds = list(global = c(10,Inf))))
dtm  <- DocumentTermMatrix(myCorpus, control=list(wordLengths=c(10, Inf),bounds = list(global = c(10,Inf))))
#dtm2 <- NULL
stop_words <- c(NULL)
for(i in 1:length(dtm$dimnames$Terms))
{
  if(startsWith(dtm$dimnames$Terms[i],"amod:")==TRUE | startsWith(dtm$dimnames$Terms[i],"nmod:")==TRUE)
  {
    #cat(list_terms[[1]][j],'\n')
    stop_words <- c(stop_words,i)
  } 
}
dtm.new <- dtm[,-stop_words]
# freq filter
#dtm.new$dimnames$Docs
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
list_prop <- c(0.5,0.60,0.70,0.80,0.90,0.95,0.99)
for (prop in list_prop) 
{
  sink(paste("/home/saber/DA_Stage/Stage/graph/data_new2/REL/lda_rel_40_5/cluster_rel_10000_50_20_10_", 
             paste(prop,".txt",sep='') , sep= ''))
  #prop <- 0.90
  nb_cluster <- 50
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