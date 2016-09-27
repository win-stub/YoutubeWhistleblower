# -*- coding: utf-8 -*-
"""
Created on Mon Apr 25 10:34:16 2016

@author: saber
"""

import sys
from pymongo import MongoClient

reload(sys)  
sys.setdefaultencoding('utf8')

client      = MongoClient()
client      = MongoClient('localhost', 27017)
db          = client['youtube']
collection  = db['test']

# Sauvegarde dans MongoDB
# Document title
title    =    {
              "title_lang":"fr",
              "title_1GRAM":["1","2","3","4"],
              "title_2GRAM":["1 2","2 3","3 4"],
              "title_3GRAM":["1 2 3","2 3 4"],
              "title_4GRAM":["1 2 3 4"],
              "title_5GRAM":[]
              }
# Document description              
description = {
              "desc_lang":"fr",
              "desc_1GRAM":["1","2","3","4"],
              "desc_2GRAM":["1 2","2 3","3 4"],
              "desc_3GRAM":["1 2 3","2 3 4"],
              "desc_4GRAM":["1 2 3 4"],
              "desc_5GRAM":[]
              } 
# Document comments  
comments   = [{
              "comments_lang":"fr",
              "comments_1GRAM":["1","2","3","4"],
              "comments_2GRAM":["1 2","2 3","3 4"],
              "comments_3GRAM":["1 2 3","2 3 4"],
              "comments_4GRAM":["1 2 3 4"],
              "comments_5GRAM":[]
              }]              
video_lang= {   
            "_id":"video_id",      
            "title":title,
            "description":description,
            "comments":comments                             
        } 
# Insertion
collection.insert_one(video_lang)        