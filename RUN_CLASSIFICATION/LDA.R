library("topicmodels")
library("tm")
library("biclust", quietly=TRUE)
library("blockcluster", quietly=TRUE)
library("CoClust", quietly=TRUE)
library("tictoc")

Chemin = '/home/saber/DA_Stage/Stage/graph/data_new/';
df <- read.csv(paste(Chemin, "en.data.lda.meta_REL.10000.10.txt" , sep= '') , sep = ';');
#df <- read.csv(paste(Chemin, "data.rel.vaccine.20.500.txt" , sep= '') , sep = ';');
#df <- read.csv(paste(Chemin, "data.rel.vaccine.10.1000.txt" , sep= '') , sep = ';');
#df <- read.csv(paste(Chemin, "data.rel.vaccine.20.1000.txt" , sep= '') , sep = ';');
#dfs <- paste(df$id[1:1000], df$contents[1:1000])
#dfs <- paste(df$id[1:length(df$id)], df$title[1:length(df$id)],df$contents[1:length(df$contents)])
dfs <- paste(df$contents[1:length(df$id)])
myCorpus <- Corpus(VectorSource(dfs))
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
#myCorpus <- tm_map(myCorpus, trim <- function( x ) {gsub("(^[[:space:]]+|[[:space:]]+$)", "", x)})
# suppression des lignes vides
#myCorpus <- tm_filter(myCorpus, FUN =function (x) {nchar(x)>0})
trim <- function( x ) {gsub("(^[[:space:]]+|[[:space:]]+$)", "", x)}
row_vide <- c(NULL)
for(i in 1:length(myCorpus))
{
  if (nchar(trim(myCorpus[[i]]$content))==0)
  {
    row_vide <- c(row_vide,i)
  }
}
row_vide <- c(row_vide,c(3149,5378,6014,7815))
myCorpus <- myCorpus[-row_vide]
#df <- df[-row_vide,]
# TermDocumentMatrix
tdm <- TermDocumentMatrix(myCorpus, control=list(minDocFreq=1, minWordLength=1))
dim(tdm)
#dtm = DocumentTermMatrix( myCorpus,control = list( wordLengths=c(0,0)))#, 
dtm <- DocumentTermMatrix(myCorpus, control=list(minDocFreq=1, minWordLength=1))
dtm <- DocumentTermMatrix(myCorpus,control = list(weighting = function(x) weightTfIdf(x, normalize = FALSE),stopwords = TRUE))
# avec tf-idf
dtm <- DocumentTermMatrix(myCorpus,control = list(weighting=weightTfIdf,minDocFreq=1, minWordLength=1))
# avec tf
dtm <- DocumentTermMatrix(myCorpus,control = list(weighting=weightTf,minDocFreq=1, minWordLength=1))
# exploration of dtm
dim(dtm)
sink("/home/saber/DA_Stage/Stage/graph/data_new/tf-idf.txt")
inspect(dtm[,1:10])
inspect(tdm[1:5,1:5])
sink()
#
dtms <- removeSparseTerms(dtm, 0.97)
dtms$dimnames
findAssocs(dtms, "obama", 0.2)
inspect(dtms[,1:10])
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)   
wf <- data.frame(word=names(freq), freq=freq)   
#head(wf) 
sink("/home/saber/DA_Stage/Stage/graph/data_new/freq_lda.txt")
for(i in 1:length(wf$word))
{
  cat(as.character(wf$word[i]),'\t',as.character(wf$freq[i]),'\n')
}
sink()
#
weightTfIdf(as.matrix(myCorpus), normalize = TRUE)
dtm$nrow
dtm$ncol
str(dtm)
count<- as.data.frame(inspect(dtm[,1000:3000]))
count$word = rownames(count)
colnames(count) <- c('count','word' )
count<-count[order(count$count, decreasing=TRUE), ]



findFreqTerms(dtm, 90)

dtm2 <- removeSparseTerms(dtm, .99)
dtm2

# suppression des documlents qui contient 0 terms
tic()
ui = unique(dtm$i)
dtm.new = dtm[ui,]
toc()
#
row_total = apply(dtm, 1, sum)
dtms       <- dtm[row_total> 0, ] #remove all docs without words
#dtm$dimnames$Terms
#dtm[,1:3]
# lda
p_LDA <- LDA(dtms[1:dtms$nrow,], control = list(alpha = 0.1), 100);
post <- posterior(p_LDA, newdata = dtms[1:dtms$nrow,]);
# lda tdm$nrow
p_LDA <- LDA(tdm[1:5000,], control = list(alpha = 0.1), 100);
post <- posterior(p_LDA, newdata = tdm[1:5000,]);
#round(post$topics[,], digits = 4);
#get_terms(p_LDA, 2)[,1]
# affiche cluster
sink("/home/saber/DA_Stage/Stage/graph/data_new/cluster_tags_tagger_5000.txt")
prop <- 0.99
nb_cluster <- 10
for(i in 1:nb_cluster)
{
  cat('cluster n --> ',i,' taille --> ',length(dtms$dimnames$Docs[post$topics[,i]>prop]),'\n')
  
  for(id in dtms$dimnames$Docs[post$topics[,i]>prop])
  {
    cat(as.character(df$id[as.numeric(id)]),' --> ',as.character(df$title[as.numeric(id)]),'\n')
  }
  length(dtms$dimnames$Docs[post$topics[,i]>prop])
}
sink()



# affiche cluster
sink("/home/saber/DA_Stage/Stage/graph/data_new/cluster_tags_tagger_5000.txt")
prop <- 0.95
nb_cluster <- 10
for(i in 1:nb_cluster)
{
  cat('cluster n --> ',i,' taille --> ',length(tdm$dimnames$Terms[post$topics[,i]>prop]),'\n')
  
  for(id in tdm$dimnames$Terms[post$topics[,i]>prop])
  {
    #cat(as.character(df$id[as.numeric(id)]),' --> ',as.character(df$title[as.numeric(id)]),'\n')
    cat(id,'\n')
  }
  length(tdm$dimnames$Terms[post$topics[,i]>prop])
}
sink()


df$title[as.numeric(tdm$dimnames$Terms[post$topics[,1]>0.90])]
df$title[as.numeric(tdm$dimnames$Terms[post$topics[,2]>0.90])]
df$title[as.numeric(tdm$dimnames$Terms[post$topics[,3]>0.90])]
df$title[as.numeric(tdm$dimnames$Terms[post$topics[,4]>0.90])]
df$title[as.numeric(tdm$dimnames$Terms[post$topics[,5]>0.90])]

df$title[as.numeric(dtm$dimnames$Docs[post$topics[,2]>0.999])]
perplexity(object=p_LDA)
#
dtm
dimnames(dtm)$Terms
M = as.matrix(dtm)

# bi-clustering
model <- biclust( M , method=BCBimax, minc=3, number=2)
print(model)
sort( rowSums( as.matrix(model@NumberxCol*1) ) , decreasing = T)
dimnames(dtm)$Docs [ model@NumberxCol[2,] ]

# block-clustering
model <- cocluster(M,datatype="binary",nbcocluster=c(2,3))
summary(model)
plot(model)
dimnames(dtm)$Docs[ model@colclass == 1 ]

# CoClust
#On cree le modele :
clust <- CoClust(M, dimset = 2:5, noc=2, copula="frank",
                 method.ma="empirical", method.c="ml",writeout=1)
#On consulte le contenu du modele :
clust
clust@"Number.of.Clusters"
clust@"Dependence"$Param
clust@"Data.Clusters"
index.clust <- clust@"Index.Matrix"

