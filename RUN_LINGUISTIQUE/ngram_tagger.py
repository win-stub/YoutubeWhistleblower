# -*- coding: utf-8 -*-
"""
Created on Fri Apr 22 14:54:23 2016

@author: saber
"""
import sys
import nltk
from nltk.tokenize import sent_tokenize

reload(sys)  
sys.setdefaultencoding('utf8')

file_name = sys.argv[1]
print('file name to parse --> '+file_name)
size_gram = int(sys.argv[2])
print('nombre des ngram -')
########################## TREETAGGER #########################################
# lire le fichier en question
file_txt = open(file_name) 
txt = file_txt.read()
texte = txt.decode("utf8").split('\n')
print(len(texte))
#print(texte)
tokens = []  
i=0
for line in texte:   
    column = line.split('\t')      
    if(len(column)==3):
        #print (column[0]+' '+column[1]+' '+column[2]) 
        tokens.append(column[0])
        if(column[1]=='SENT'):                        
            n_grams     = nltk.ngrams(tokens,size_gram)
            for grams in n_grams:
                s=''
                for i in range(size_gram):
                    s = s+grams[i]+'\t'
                print(s)
            tokens = []            
###############################################################################
txt = "And the beggars are Gypsies from Eastern Europe, and NEVER give them anything even if they pretend to be dying in front of you!"
tokens      = nltk.word_tokenize(txt)
n_grams     = nltk.ngrams(tokens,2)    
type(n_grams)
for grams in n_grams:
    print(grams)
    
sents = sent_tokenize(txt.decode("utf8"), language='fr')    
for sent in sents:
    tokens      = nltk.word_tokenize(sent)
    print(len(tokens))
    print(tokens)
    print(tokens[25])
    del tokens[25]
    n_grams     = nltk.ngrams(tokens,2)    
    for grams in n_grams: 
        print(grams)    
                    