# -*- coding: utf-8 -*-
"""
Created on Mon Jun  6 18:08:24 2016

@author: saber
"""
from operator import itemgetter
import sys
from math import sqrt

reload(sys)  
sys.setdefaultencoding('utf8')

def get_FREQ(title,description,transcription,comments,n_gram):
    # les commentaires
    tab_comments=[]   
    for comment in comments:
        tab_comments = tab_comments +comment[n_gram]   
    # title  NGRAM        
    tab_ngram = title[n_gram]+description[n_gram]+transcription[n_gram]+tab_comments  
    tab_ngram = [[x,tab_ngram.count(x)] for x in set(tab_ngram)]
    tab_ngram1 = sorted(tab_ngram, key=itemgetter(1),reverse=True)
    for gram in tab_ngram1:
        print(gram[0]+'\t'+str(gram[1]))
        
def get_FREQ_NG_REL_NER(title,description,transcription,comments,type_rel):
    # les commentaires
    tab_comments=[]   
    for comment in comments:
        tab_comments = tab_comments +comment[type_rel].strip().split('\n')                
    # all meta data        
    tab_fre = title[type_rel].strip().split('\n')+description[type_rel].strip().split('\n')+transcription[type_rel].strip().split('\n')+tab_comments 
    # start delete value null   
    for i in range(tab_fre.count('')):
        tab_fre.remove('') 
    # end delete value null
    tab_fre = [[x,tab_fre.count(x)] for x in set(tab_fre)]
    tab_fre = sorted(tab_fre, key=itemgetter(1),reverse=True)
    for gram in tab_fre:
        print(gram[0]+'\t'+str(gram[1]))
    return tab_fre

def getNG_REL_NER(title,description,transcription,comments,type_rel):
    # les commentaires
    tab_comments=[]   
    for comment in comments:
        tab_comments = tab_comments +comment[type_rel].strip().split('\n')                
    # all meta data        
    tab_fre = title[type_rel].strip().split('\n')+description[type_rel].strip().split('\n')+transcription[type_rel].strip().split('\n')+tab_comments 
    # start delete value null   
    for i in range(tab_fre.count('')):
        tab_fre.remove('') 
    # end delete value null    
    return tab_fre      

def similarity(a, b): 
    val_retrun=-1
    scalar = sum(a[k] * b[k] for k in range(len(a)))    
    norm_a = sqrt(sum(v ** 2 for v in a))
    norm_b = sqrt(sum(v ** 2 for v in b))   
    if norm_a!=0 and norm_b!=0:
        val_retrun = scalar / (norm_a * norm_b) 
    return val_retrun
def getGML(tab_src_dest,dict_index,dict_title):
    # enete du graphe
    graph_format = 'graph [\ndirected 0\n'      
    # les nodes
    str_node=''
    for key in dict_index.keys():
        index = dict_index[key]         
        str_node = str_node+'node [\n'+'id '+str(index)+'\n'+'label "'+key+'"\n'+'title "'+dict_title[key]+'"\n'+']\n' 
    # les liens
    str_edge=''
    for src_dest in tab_src_dest:        
        str_edge = str_edge+'edge[\n source '+src_dest.split('\t')[0]+'\n target '+src_dest.split('\t')[1]+'\n weight '+src_dest.split('\t')[2]+'\n]\n'
    #
    graph_format = graph_format +str_node+str_edge+']'
    return (graph_format)
    # 
               
           
    