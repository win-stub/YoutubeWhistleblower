# -*- coding: utf-8 -*-
"""
Created on Mon Jun  6 16:35:59 2016

@author: saber
"""
import sys
from pymongo import MongoClient
import SN_fre as sn_fre
from igraph import *
#
reload(sys)  
sys.setdefaultencoding('utf8')
#
is_intersect = sys.argv[1]
video_id     = sys.argv[2]
type_rel     = sys.argv[3]
#
client           = MongoClient()
client           = MongoClient('localhost', 27017)
db               = client['youtube']
collection       = db['corpus_youtube.meta']
collection_lang  = db['corpus_youtube.ling']
# les meta données
#for col in collection.find({"_id":"g8bt8eUB1CU"}):
#    video_id     = col["_id"]
#    title        = col["title"]
#    print(title)
# les linguistique les statistiques
if is_intersect=='1':
    tab_ngram=[]    
    for col in collection_lang.find({"_id":video_id}):         
        # 
        tab_comments   = col["comments"]    
        title          = col["title"]
        description    = col["description"]  
        #
        transcription  = col["transcription"]             
        #    
        if (type_rel=='1GRAM'):
            sn_fre.get_FREQ(title,description,transcription,tab_comments,"meta_1GRAM")
        if (type_rel=='2GRAM'):
            sn_fre.get_FREQ(title,description,transcription,tab_comments,"meta_2GRAM")
        if (type_rel=='3GRAM'):
            sn_fre.get_FREQ(title,description,transcription,tab_comments,"meta_3GRAM")
        if (type_rel=='4GRAM'):
            sn_fre.get_FREQ(title,description,transcription,tab_comments,"meta_4GRAM")
        if (type_rel=='5GRAM'):
            sn_fre.get_FREQ(title,description,transcription,tab_comments,"meta_5GRAM")
        if (type_rel=='NER'):
            sn_fre.get_FREQ_NG_REL_NER(title,description,transcription,tab_comments,"meta_NER")
        if (type_rel=='NG'):
            sn_fre.get_FREQ_NG_REL_NER(title,description,transcription,tab_comments,"meta_NG")
        if (type_rel=='REL'):
            sn_fre.get_FREQ_NG_REL_NER(title,description,transcription,tab_comments,"meta_REL") 
if is_intersect=='2':
    tab_global =[]
    i=1
    for col in collection_lang.find({}):
        #        
        tab_comments   = col["comments"]    
        title          = col["title"]
        description    = col["description"]  
        transcription  = col["transcription"] 
        #
        print(col["_id"])
        tab_tmp=[]
        tab_tmp = sn_fre.getNG_REL_NER(title,description,transcription,tab_comments,"meta_REL")
        tab_global.append(tab_tmp)
        tab_tmp=[]        
        if i==3:            
            break
        i=i+1
    # intersection entre les vecteurs  
    print(len(tab_global))
    result = reduce(set.intersection,map(set,tab_global))
    print(result)
if is_intersect=='3':
    #tab_global =[]
    dict_tab   ={}
    dict_index ={}
    dict_title ={}
    i=0
    for col in collection.find({}):
        #        
        title                  = col["title"]
        dict_title[col["_id"]] = title
    #
    for col in collection_lang.find({}):
        #        
        tab_comments   = col["comments"]    
        title          = col["title"]
        description    = col["description"]  
        transcription  = col["transcription"] 
        #
        print(col["_id"])
        #   
        tab_tmp=[]
        tab_tmp = sn_fre.getNG_REL_NER(title,description,transcription,tab_comments,"meta_NER")
        #tab_global.append(tab_tmp)
        dict_tab[col["_id"]] = tab_tmp
        dict_index[col["_id"]] = i
        i=i+1
    # construction d un vecteur
    tab_base = []    
    for key in dict_tab.keys():
        tab_base = tab_base+dict_tab[key]
    # suppression des doublons
    tab_base = list(set(tab_base))
    #print(len(tab_base))
    #
    dict_graph={}
    for key in dict_tab.keys():
        # initialisation d'un tableau de taille tab_base
        tab_video = [0] * len(tab_base)        
        #
        for rel in  dict_tab[key]:            
            tab_video[tab_base.index(rel)]=1
        #
        dict_graph[key] = tab_video
        tab_video=[]
    #
    tab_src_dest=[]
    links_poids =[]
    for key1 in dict_graph.keys():
        for key2 in dict_graph.keys():
            if key1!=key2:                
                val = sn_fre.similarity(dict_graph[key1],dict_graph[key2])
                #print(key1+'\t'+key2+'\t'+str(val))
                #if val >0.01:                    
                tab_src_dest.append(str(dict_index[key1])+'\t'+str(dict_index[key2])+'\t'+str(val))
                print(tab_src_dest)
        # supprimer key1
        if key1 in dict_graph: del dict_graph[key1]               
    # tracer le graphe en question
    import SN_fre as sn_fre
    graph = sn_fre.getGML(tab_src_dest,dict_index,dict_title)
    print(graph)
    #for src_dest in range(len(tab_src_dest)):
    #    print(str(tab_src_dest[src_dest])+'\t'+str(links_poids[src_dest]))
    
    #
    #g = Graph()
    #g.add_vertices(len(dict_index))
    #g.add_edges(tab_src_dest)
    #for key in dict_index.keys():
    #    index = dict_index[key]
    #    print(index)
    #    g.vs[index]["name"] = key        
    #g.vs["name"] = dict_index.keys()
    #
    #print(g)
    #g.es["poids"]    
    #
    #g.vs["label"] = g.vs["name"]
    #g.es["label"] = g.es["poids"]
    #
    #layout = g.layout("kk")
    #plot(g, layout = layout)    
        
        
        