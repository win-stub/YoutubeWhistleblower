# -*- coding: utf-8 -*-
"""
Created on Fri Apr 22 14:54:23 2016

@author: saber
"""
import sys
import nltk
from nltk.tokenize import sent_tokenize
from langdetect import *
import jieba
#from polyglot.text import Text

reload(sys)  
sys.setdefaultencoding('utf8')

#file_name = sys.argv[1]
#print('file name to parse --> '+file_name)
#size_gram = int(sys.argv[2])
#print('nombre des ngram -')
########################## TOKENS #############################################
# lire le fichier en question
#file_txt = open(file_name) 
#txt = file_txt.read()
#print(txt)
# calcul des ngrams
#tokens      = nltk.wordpunct_tokenize(txt.decode("utf8"))
#tokens      = nltk.word_tokenize(txt.decode("utf8"))
#tokens      = nltk.wordpunct_tokenize(txt.decode("utf8"))
def getNGRAM(txt,lang,lang_list,size_gram):    
    ngram_list = ''#[]
    if (lang!='None') and (lang!='ar') and (lang in lang_list)==True:    
        sents       = sent_tokenize(txt.decode("utf8"), language=lang)
        #WhitespaceTokenizer().span_tokenize(s)
        # Affichage des resultats             
        for sent in sents:
            if lang=='cn':
                tokens=[]
                text = jieba.tokenize(sent,mode='search')               
                for segment in text:
                    tokens.append(segment[0])                 
            else:            
                tokens      = nltk.word_tokenize(sent)                      
            #
            if(tokens[-1]==u"\ufeff"):
                del tokens[-1]
            n_grams     = nltk.ngrams(tokens,size_gram)    
            for grams in n_grams: 
                s=''
                for i in range(size_gram):                    
                    s = s+grams[i]+'\t'                                  
                #print(s)
                #ngram_list.append(s.strip())
                ngram_list = ngram_list +s.strip()+'\n'
                    #ngram_list = list(set(ngram_list))      
                    #for ngram in ngram_list:
                    #   print(ngram)
    else:        
        tokens      = nltk.word_tokenize(txt)
        n_grams     = nltk.ngrams(tokens,size_gram)    
        for grams in n_grams: 
            s=''
            for i in range(size_gram):
                s = s+grams[i]+'\t'
            #print(s)
            #ngram_list.append(s.strip())
            ngram_list = ngram_list +s.strip()+'\n'
            #ngram_list = list(set(ngram_list))      
            #for ngram in ngram_list:
            #   print(ngram)             
    return ngram_list
###############################################################################
def getMessageUTF(text):
    try:
        text = unicode(text, 'utf-8')
    except TypeError:
        return text 
        
def getLANG(text):        
    try:       
        u = detect(text)
        if u=='zh-cn' or u=='zh-tw':
            u = 'cn'
    except:
        #pass
        u = 'None'
    return u    
###############################################################################    
# recuperation des phrases
def getSents(txt,lang,lang_list):    
    sent_list = []
    if (lang!='None') and (lang in lang_list)==True:    
        sent_list = sent_tokenize(txt.decode("utf8"), language=lang)
        #
    else:
        #text = Text(txt) 
        #sent_list = text.sentences
        sent_list = []
    return sent_list          