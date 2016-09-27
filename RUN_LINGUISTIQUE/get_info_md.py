# -*- coding: utf-8 -*-
"""
Created on Thu May 12 12:04:15 2016

@author: saber
"""

import sys
from pymongo import MongoClient

reload(sys)  
sys.setdefaultencoding('utf8')

client           = MongoClient()
client           = MongoClient('localhost', 27017)
db               = client['youtube']
collection_lang  = db['corpus_lang.lang']

for col in collection_lang.find({"title.title_lang":"fr"}):
    title = col["title"]
    tags  = title["title_tags"]
    for tag in tags:
        print tag[0]+'\t'+tag[1]+'\t'+tag[2]+'\n'