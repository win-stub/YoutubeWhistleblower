# -*- coding: utf-8 -*-
"""
Created on Thu Jun 23 17:58:10 2016

@author: saber
"""

import sys
import operator
from pymongo import MongoClient

reload(sys)  
sys.setdefaultencoding('utf8')

def getDICT(server,dbanme,collection):  
    
    client           = MongoClient()
    client           = MongoClient(server, 27017)
    db               = client[dbanme]
    collection       = db[collection]
    # "is_ling":"false" "_id":"g8bt8eUB1CU"
    dict_total = {}
    for col in collection.find({}):  
        transcription  = col["transcription"]   
        if len(transcription)!=0:
            txt = transcription.split('\n')
            for i in range(len(txt)):          
                if i+1 < len(txt):        
                    taille_line_1 = len(txt[i].split(' '))                  
                    key = txt[i].split(' ')[taille_line_1-1]+'\t'+txt[i+1].split(' ')[0]
                    if dict_total.has_key(key):
                        dict_total[key] = int(dict_total[key])+1
                    else:
                        dict_total[key]=1
    dico_trie = sorted(dict_total.iteritems(), reverse=True, key=operator.itemgetter(1))
    for words in dico_trie:
        print(words[0]+'\t'+str(words[1]))
    ##return (dict_total)