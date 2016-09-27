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
myCorpus <- Corpus(VectorSource(df$contents[1:length(df$id)]))
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
#myCorpus <- tm_map(myCorpus, removeWords, c("person","organization","location"))
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
tdm   <- TermDocumentMatrix(myCorpus, control=list(wordLengths=c(10, Inf),bounds = list(global = c(1,Inf)),tokenize =tab_tokenizer))
#dtm  <- DocumentTermMatrix(myCorpus, control=list(tokenize =tab_tokenizer))
#tdm  <- TermDocumentMatrix(myCorpus, control=list(tokenize =tab_tokenizer))
# tokenize avec trigram
#TrigramTokenizer    <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
#BigramTokenizer     <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 3))
#
#tdm$dimnames$Terms[1:1000]
tdm.new <- tdm
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


tdm.new.matrix <- as.matrix(tdm.new)
#dim(tdm.new.matrix)
tdm.new.matrix[tdm.new.matrix>=1] <- 1
#tdm.new.matrix[1:10,1:10]
#
#
seuil <- 10
row_del <- c(NULL)
for(i in 1:dim(tdm.new.matrix)[1])
{
  sum_row <- sum(tdm.new.matrix[i,])
  #cat(tdm.new.matrix[i,1:10],' ',sum_row,'\n')
  if(sum_row < seuil)
  {
    row_del <- c(row_del,i)
  }
}
# delete all row or term with seuil defined
tdm.new.matrix <- tdm.new.matrix[-row_del,]
dim(tdm.new.matrix)
length(row_del)
tdm.new.matrix[,1:20]