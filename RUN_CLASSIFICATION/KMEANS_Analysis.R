library(datasets)
library(ggplot2)
library(hash)
# prepare data youtube
Chemin = '/home/saber/DA_Stage/Stage/graph/data/' ;
RawData <- read.csv(paste(Chemin, "data.matrix.rel.vaccine.10.500.txt" , sep= '') , sep = ';');
kc <- kmeans(RawData[,3:length(RawData)], 5)
# get cluster means
aggregate(RawData[,3:length(RawData)],by=list(kc$cluster),FUN=mean)
# append cluster assignment
mydata <- data.frame(RawData[,3:length(RawData)], kc$cluster) 

# Ward Hierarchical Clustering
d <- dist(mydata, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward.D2")
plot(fit) # display dendogram
groups <- cutree(fit, k=5) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters
rect.hclust(fit, k=5, border="red") 


# Ward Hierarchical Clustering with Bootstrapped p values
library(pvclust)
fit <- pvclust(mydata, method.hclust="ward.D2",
               method.dist="euclidean")
plot(fit) # dendogram with p values
# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95) 



# K-Means Clustering with 5 clusters
fit <- kmeans(RawData[,3:length(RawData)], 5)

# Cluster Plot against 1st 2 principal components

# vary parameters for most readable graph
library(cluster)
clusplot(RawData[,3:length(RawData)], fit$cluster, color=TRUE)

# Centroid Plot against 1st 2 discriminant functions
library(fpc)
plotcluster(RawData[,3:length(RawData)], fit$cluster) 