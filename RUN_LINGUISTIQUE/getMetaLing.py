# -*- coding: utf-8 -*-
"""
Created on Tue Jun 14 10:44:26 2016

@author: saber
"""

import sys
from pymongo import MongoClient
#
reload(sys)  
sys.setdefaultencoding('utf8')
#
client           = MongoClient()
client           = MongoClient('localhost', 27017)
db               = client['youtube']
collection       = db['corpus_youtube.meta']
collection_lang  = db['corpus_youtube.ling']
#
for col in collection.find({"_id":"g8bt8eUB1CU"}):         
    # 
    #tab_comments   = col["comments"]    
    title          = col["title"]
    description    = col["description"]  
    #
    transcription  = col["transcription"]
    #print(title)
    # description
    #print(description)
    print(transcription)
#    
for col in collection_lang.find({"_id":"g8bt8eUB1CU"}):         
    # 
    #tab_comments   = col["comments"]    
    title          = col["title"]
    description    = col["description"]  
    #
    transcription  = col["transcription"]
    #print(title["meta_REL"])
    #print(description["meta_REL"])
    #print(transcription["meta_DEPS"])
    print(transcription["meta_REL"])