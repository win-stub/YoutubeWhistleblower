library(hash)
library(igraph)
# Etude topologique du reseau wikipedia
graph_summary <- function(g){
  if(is_igraph(g)){
    
    cat("Nombre des noeuds     :",as.character(vcount(g)),"\n")
    cat("Nombre des liens      :",as.character(ecount(g)),"\n")
    cat("La densite du graphe  :",as.character(graph.density(g)),"\n")
    cat("Le diametre du graphe :",as.character(diameter(g)),"\n")
    if(is.connected(g)){
      cat("Graphe connecte \n")
    }else{
      cat("Graphe non connecte \n")
    }
    cat("La transitivite du graphe  :",as.character(transitivity(g)),"\n")
    #cat("Graph distribution degree :",as.character(degree.distribution(g)),"\n")
  }else{
    stop("not an igraph object")
  }
}
# ==========================================================
# Nombre des composantes connexes
# ==========================================================
graph_compenents  <- function(g)
{
  if(is_igraph(g))
  {
    cl <- clusters(g)
    if(cl$no==1)
    {
      print("Graphe connexe")
    }
    else
    {
      cat("Nombre des composantes connexes ",cl$no,"\n")
      cat("la taille de la composante maximal ", max(cl$csize),"\n")
      hist(cl$csize) 
    }
  }
  else
  {
    stop("Not an graph object")
  }
}
# ==============================================
# QUESTION-2 : La composante la plus grande
# ==============================================
get_maxComponents <- function(g)
{
  cl <- clusters(g)
  nodes <- which(cl$membership==which.max(cl$csize))
  cat("Taille du Sous-Graphe Maximal : ",length(induced_subgraph(g,nodes)))
  return (induced_subgraph(g,nodes))
}
# ==============================================
# cluster_edge_betweenness
# ==============================================
cluster_betweenness <- function(g)
{
  if(is_igraph(g))
  {
    comm <- cluster_edge_betweenness(g)
    return (comm)
  }
  else 
  {
    stop("Not an graph object")
  }
}
# ==============================================
# cluster_walktrap
# ==============================================
cluster_walk <- function(g)
{
  if(is_igraph(g))
  {
    comm <- cluster_walktrap(g)
    return (comm)
  }
  else 
  {
    stop("Not an graph object")
  }
}
# ==============================================
# cluster_louvain
# ==============================================
cluster_louv <- function(g)
{
  if(is_igraph(g))
  {
    comm <- cluster_louvain(g)
    return (comm)
  }
  else 
  {
    stop("Not an graph object")
  }
}
# La coherence semantique
get_info_comm <- function(g,comm,vect_titles,taille_comm,first_comm){
  # Attribuer le ID du graphe au ID du donnees
  vect_hash <- hash( V(g), V(g)$id )
  
  # On prend juste first_comm communautes
  for(i in 1:first_comm)
  {
    tab <- comm[[paste("",i,sep ="")]]
    # On prend juste les communaute dont la taille 
    # est inferieure ou egale a taille_comm
    if(length(tab) >= taille_comm)
    {
     cat("========================================================","\n")
     cat("Communaute N --> ",i," Taille ",length(tab),"\n")
    for(ii in 1:length(tab))
    {
      key_id <- paste("",tab[ii],sep="")
      id_info    <- V(g)[id==vect_hash[[key_id]]]$id
      label_info <- V(g)[id==vect_hash[[key_id]]]$label
      title_info <- V(g)[id==vect_hash[[key_id]]]$title
      #
      #
      
      #
      # On affiche ID GRAPHE et id, label du wikipedia
      cat(id_info," --> ",key_id," --> ",label_info," --> ",title_info,"\n")
      # cat(key_id," --> ",vect_hash[[key_id]]," --> ",vect_titles[[label_info]],"\n")
      # cat(key_id," --> ",label_info," --> ",vect_titles[[label_info]],"\n")
    }
    cat("========================================================","\n")     
    }
  }
}
# La coherence semantique
get_id_comm <- function(g,comm,hash_tab,vect_wb,vect_nwb,taille_comm,first_comm){
  # Attribuer le ID du graphe au ID du donnees
  vect_hash <- hash( V(g), V(g)$id )
  
  # On prend juste first_comm communautes
  for(i in 1:first_comm)
  {
    tab <- comm[[paste("",i,sep ="")]]
    # On prend juste les communaute dont la taille 
    # est inferieure ou egale a taille_comm
    if(length(tab) >= taille_comm)
    {
      #cat("========================================================","\n")
      #cat("Communaute N --> ",i," Taille ",length(tab),"\n")
      for(ii in 1:length(tab))
      {
        key_id <- paste("",tab[ii],sep="")
        id_info    <- V(g)[id==vect_hash[[key_id]]]$id
        #label_info <- V(g)[id==vect_hash[[key_id]]]$label
        #title_info <- V(g)[id==vect_hash[[key_id]]]$title
        #
        #
        if (i %in% vect_wb)
        {
          hash_tab[['WB']] <- c(hash_tab[['WB']],id_info)
        }
        if (i %in% vect_nwb)
        {
          hash_tab[['NWB']] <- c(hash_tab[['NWB']],id_info)
        }
        #
        # On affiche ID GRAPHE et id, label du wikipedia
        #cat(id_info," --> ",key_id," --> ",label_info," --> ",title_info,"\n")
        # cat(key_id," --> ",vect_hash[[key_id]]," --> ",vect_titles[[label_info]],"\n")
        # cat(key_id," --> ",label_info," --> ",vect_titles[[label_info]],"\n")
      }
      cat("========================================================","\n")     
    }
  }
}
# =====================================================
# QUESTION-3 : Identification des communautes locales
# =====================================================

# =====================================================
# Calculer la modularite local R
# =====================================================
Modularity_R <- function(g,C,B,S){
  if(is_igraph(g))
  {
    
    B_in <- length(E(g)[B%--%B])
    B_out <- length(E(g)[B%--%S])
    return (B_in / (B_in + B_out)) 
  }
  else 
  {
    stop("Not graph object")
  }
}
# =====================================================
# Calculer la modularite local M
# =====================================================
Modularity_M <- function(g,C,B,S){
  if(is_igraph(g))
  {
    D     <- union(B,C)
    D_in  <- length(E(g)[D%--%D])
    D_out <- length(E(g)[D%--%S])
    return (D_in/D_out)
  }
  else
  {
    stop("Not graph object")
  }
}
# =====================================================
# Calculer la modularite local L
# =====================================================
Modularity_L <- function(g,C,B,S){
  if(is_igraph(g))
  {
    D <- union(B,C)
    L_in  = 0
    L_out = 0
    for (i in D)
    {
      L_in = L_in + length(intersect(neighbors(g,i),D))
    }
    #
    L_in = (L_in / length(D))
    for (i in B)
    {
      L_out = L_out + length(intersect(neighbors(g,i),S))
    }
    #
    L_out = (L_out / length(B))
    #
    return (L_in/L_out)
  }
  else
  {
    stop("Not graph object")
  }
}
# =====================================================
# Fonction pour la detection des communautes
# =====================================================
Detect_Comm <- function(g,n_0,modularity_LMR)
{
  B <- vector()
  C <- vector()
  S <- vector()
  if(is_igraph(g))
  {
    # initialisation
    B  <- c(B,n_0)
    S  <- c(S,neighbors(g, n_0))
    Q  <- 0
    Qq <- 0
    #
    #
    while(Q<=Qq && length(S)>0)
    {
      Q <- Qq 
      #
      df <- data.frame(S,0)
      names(df) <- c("N","Q")
      vect_hash <- hash(S, 0)
      #
      for(i in S)
      {
        #print(i)
        tab_tmp <- Update_CBS(g,C,B,S,i,modularity_LMR)
        #print(tab_tmp)
        i_B <- tab_tmp[[1]]
        i_C <- tab_tmp[[2]]
        i_S <- tab_tmp[[3]]
        #
        vect_hash[i] <- tab_tmp
        #
        #cat(i," --> ",mod_R(g,i_C,i_B,i_S),"\n")
        df[df$N==i,"Q"] <- modularity_LMR(g,i_C,i_B,i_S)
        #
      }
      #
      df_tmp <- order(df$Q,decreasing = TRUE)
      # Recuperation des informations concernant B C S
      key_s <- paste("",df[df_tmp[1],"N"],sep="")
      tab_tmp <- vect_hash[[key_s]]
      i_B <- tab_tmp[[1]]
      i_C <- tab_tmp[[2]]
      i_S <- tab_tmp[[3]]
      #
      S <- i_S
      B <- i_B
      C <- i_C
      Qq <- df[df_tmp[1],"Q"]
      #
      if(Q<Qq){
      cat(" B --> ",i_B," C --> ",i_C," S --> ",i_S,"Qualite --> ",Qq,"\n")
      D <- union(i_B,i_C)
      }
      #
    }
    return (D)
  }
  else
  {
    stop("Not graph object")
  }  
}
# =====================================================
# Fonction pour mettre à jour les C B S
# =====================================================
Update_CBS <- function(g,C,B,S,i,modularity_LMR){
  #cat(" C ",C)
  if(is_igraph(g))
  {
    if(is.element(i,S)==TRUE)
    {
      #
      B  <- union(B,i)
      BB <- union(B,C)
      #
      for(b in BB)
      {
        S_b <- setdiff(neighbors(g,b), BB)
        #cat("Voisins de ",b," --> ",S_b,"\n")
        #
        if(length(S_b)==0)
        {
          C <- union(C,b)
          B <- setdiff(B, c(b))
        }
      }
      #
      S <- setdiff(union(S,neighbors(g,i)), union(C,B))
      #
      #cat(i," B --> ",B," C --> ",C," S --> ",S," Qualite ",modularity_LMR(g,C,B,S),"\n")
    }
    return (list(B, C, S))
  }
  else
  {
    stop("Not graph object")
  }
}

# Recuperation des labels de B et C
get_info_comm_locales <- function(g,D,vect_titles){
  # Attribuer le ID du graphe au ID du donnees
  vect_hash <- hash( V(g), V(g)$id )
      cat("========================================================","\n")
      for(ii in 1:length(D))
      {
        key_id <- paste("",D[ii],sep="")
        label_info <- V(g)[id==vect_hash[[key_id]]]$label
        title_info <- V(g)[id==vect_hash[[key_id]]]$title
        #'vect_hash[[key_id]]," --> "',
        # On affiche ID GRAPHE et id, label du wikipedia
        # cat(key_id," --> ",vect_hash[[key_id]]," --> ",vect_titles[[label_info]],"\n") 
        # cat(key_id," --> ",label_info," --> ",vect_titles[[label_info]],"\n")
        cat(key_id," --> ",label_info," --> ",title_info,"\n")
      }
      cat("========================================================","\n")
}

# ==========================================================================================================
# QUESTION-4 : Identification des communautes locales avec la combinaison des trois modularite
# ==========================================================================================================

# ======================================================
# La fonction pour comparer les vecteurs de qualites
# les trois strategie
# ======================================================

Domine_Quality_RML <- function(v_new,v_ould,num_strategie)
{
  is_ameliored <- FALSE
  v_tmp <- (v_new >= v_ould)
  # Toutes les qualite sont ameliorees
  if(num_strategie==1)
  {
    nb_true <- length(which(v_tmp==TRUE))
    
    if(nb_true==3)
    {
      is_ameliored <- TRUE
    }
  }
  # Au moins deux qualite sont ameliorees
  if(num_strategie==2)
  {
    nb_true <- length(which(v_tmp==TRUE))
    
    if(nb_true >= 2)
    {
      is_ameliored <- TRUE
    }
  }  
  # Au moins une qualite est amelioree
  if(num_strategie == 3)
  {
    nb_true <- length(which(v_tmp==TRUE))
    
    if(nb_true >= 1)
    {
      is_ameliored <- TRUE
    }
  }
  return (is_ameliored)
}

# ========================================================================
# Detection de communautes locales avec la combinaison des trois qualites
# ========================================================================

Detect_Comm_RML <- function(g,n_0,num_strategie)
{
  B <- vector()
  C <- vector()
  S <- vector()
  if(is_igraph(g))
  {
    # initialisation
    B  <- c(B,n_0)
    S  <- c(S,neighbors(g, n_0))
    # Declaration d'un vecteur de qualite
    Q  <- c(0,0,0)
    Qq <- c(0,0,0)
    #
    #
    while(Domine_Quality_RML(Qq,Q,num_strategie)==TRUE && length(S)>0)
    {
      Q <- Qq 
      #
      df <- data.frame(S,0,0,0)
      names(df) <- c("N","QR","QM","QL")
      vect_hash <- hash(S, 0)
      #
      for(i in S)
      {
        #print(i)
        tab_tmp <- Update_CBS(g,C,B,S,i,0)
        #print(tab_tmp)
        i_B <- tab_tmp[[1]]
        i_C <- tab_tmp[[2]]
        i_S <- tab_tmp[[3]]
        #
        vect_hash[i] <- tab_tmp
        #
        df[df$N==i,"QR"] <- Modularity_R(g,i_C,i_B,i_S)
        df[df$N==i,"QM"] <- Modularity_M(g,i_C,i_B,i_S)
        df[df$N==i,"QL"] <- Modularity_L(g,i_C,i_B,i_S)
        #
      }
      #
      vect_borda <- hash(S, 0)
      #
      df_R <- order(df$QR,decreasing = TRUE)
      df_M <- order(df$QM,decreasing = TRUE)
      df_L <- order(df$QR,decreasing = TRUE)
      # Recuperation des informations concernant B C S
      for(j in 1:length(df_R))
      {
        key_sR <- paste("",df[df_R[j],"N"],sep="")
        key_sM <- paste("",df[df_M[j],"N"],sep="")
        key_sL <- paste("",df[df_L[j],"N"],sep="")
        #cat(key_sR," ",key_sM," ",key_sL,"\n") 
        # Attribution des valeurs de n-1 pour chaque noeud
        vect_borda[key_sR] <- vect_borda[[ key_sR ]] + (length(df_R)-j)
        vect_borda[key_sM] <- vect_borda[[ key_sM ]] + (length(df_M)-j)
        vect_borda[key_sL] <- vect_borda[[ key_sL ]] + (length(df_L)-j)
        #
      }
      # recuperation le noeud qui contient la valeur maximale selon la methode BORDA
      val <- values(vect_borda)
      noeud_max <- names(val[val == max(val)])
      #cat("noeid  -->  ",noeud_max,"\n")
      cat("Le noeud selectionner   -->  ",noeud_max[1],"\n")
      #
      tab_tmp <- vect_hash[[noeud_max[1]]]
      i_B <- tab_tmp[[1]]
      i_C <- tab_tmp[[2]]
      i_S <- tab_tmp[[3]]
      #
      S <- i_S
      B <- i_B
      C <- i_C
      # vecteur des qualite selectionnee
      Qq <- c(df[df$N==noeud_max[1],"QR"],df[df$N==noeud_max[1],"QM"],df[df$N==noeud_max[1],"QL"])
      #
      v_tmp_Qq <- (Q < Qq)
      ##
      #if(length(which(v_tmp_Qq==FALSE))==num_strategie){
      cat(" B --> ",i_B," C --> ",i_C," S --> ",i_S,"Qualite R M L --> ",Qq,"\n")
      D <- union(i_B,i_C)
      #}
      #
    }
    return (D)
  }
  else
  {
    stop("Not graph object")
  }  
  
}

# ========================================================================
# Question 5 : Detection des liens manquants
# ========================================================================

#
# Recuperer les liens manquants : graphe complementaire
#

get_missing_links  <- function(g)
{
  if(is_igraph(g))
  {
    return (ecount(graph.complementer(g)))
  }
  else
  {
    stop("Not an graph object")
  }
}

#
# Permet de recuperer le noued le plus central selon les differentes centralites
#
get_centrality <- function(g,centrality,name) 
{
  # Appliquer la centralite
  cen <- centrality(g)
  # Recuperer l'index du centralite le plus grand
  cenIndex <- which.max(cen)
  vect <- as.vector(V(g)$label)
  #
  cat("L'index du noeud le plus central : ", cenIndex,"\n")
  cat("Le nom du noeud le plus central : ", vect[cenIndex],"\n")
  # Recuperer le sous graphe lie au centralite
  sousGraph <- graph.neighborhood(g,1,cenIndex)[[1]]
  return (sousGraph)
}


