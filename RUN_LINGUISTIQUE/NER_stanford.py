# -*- coding: utf-8 -*-
"""
Created on Tue May 31 17:07:43 2016

@author: saber
"""

import sys
import os
import jieba
from nltk.tag import StanfordNERTagger
from itertools import groupby
import nltk
reload(sys)  
sys.setdefaultencoding('utf8')

def getNER(txt,lang,dict_stanford,path_to_stanford,java_path):
    dict_ner = {'PERSON':'PERSON',
                'PERS':'PERSON',
                'I-PER':'PERSON',
                'I-PERS':'PERSON',                
                'ORGANIZATION':'ORGANIZATION',
                'ORG':'ORGANIZATION',                
                'I-ORG':'ORGANIZATION',                
                'LOCATION':'LOCATION',
                'LOC':'LOCATION',
                'I-LOC':'LOCATION',                
                'I-LIEU':'LOCATION'}
    # list de retour
    if len(java_path)!=0:
        os.environ['JAVAHOME'] = java_path
    list_ner=''
    if lang in dict_stanford.keys():
        if lang=='ru':        
            st = StanfordNERTagger(path_to_stanford+dict_stanford[lang]   ,
    		                  path_to_stanford+dict_stanford['jar']  ,                               
    		                  encoding='utf-8'                       ,                                                         
                                   java_options='-mx4g'
                                   )
        else:
            st = StanfordNERTagger(path_to_stanford+dict_stanford[lang]   ,
    		                   path_to_stanford+dict_stanford['jar']  ,                               
    		                   encoding='utf-8'                       ,                                                         
                                   java_options=dict_stanford['size-jvm']
                                   )            
        # segmentation pour la langue chinoise
        if lang=='cn':
            tocken_cn =[]
            text = jieba.tokenize(txt,mode='search')            
            for segment in text:
                tocken_cn.append(segment[0])
            r=st.tag(tocken_cn)            
        else:
            #r=st.tag(txt.split())
            r=st.tag(nltk.word_tokenize(txt))
        # recuperation des entites nommees
        for tag, chunk in groupby(r, lambda x:x[1]):           
            if tag != "O" and tag in dict_ner.keys():
                list_ner=list_ner+dict_ner[tag]+'\t'+" ".join(w for w, t in chunk)+'\n'
                #print("%-12s"%tag, " ".join(w for w, t in chunk)) 
    else:
        list_ner=''
    return (list_ner)