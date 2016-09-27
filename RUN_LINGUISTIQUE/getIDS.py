# -*- coding: utf-8 -*-
"""
Created on Thu Jun 23 14:29:28 2016

@author: saber
"""

import sys
from pymongo import MongoClient

reload(sys)  
sys.setdefaultencoding('utf8')

# Param2 : server_name     par exemple localhost
# Param3 : db_name         par exemple youtube
# Param4 : collection_meta par exemple corpus.youtube.meta
# Param5 : collection_all  par exemple corpus.youtube.all

server_name     = sys.argv[1]
db_name         = sys.argv[2]
collection_meta = sys.argv[3]
collection_all  = sys.argv[4]

client           = MongoClient()
client           = MongoClient(server_name, 27017)
db               = client[db_name]
collection       = db[collection_meta]
collection_all	 = db[collection_all]
for col in collection.find({}):
	video_id = col["_id"]
    	if collection_all.find({"_id": video_id}).count()<1:
                all =''
		all = col["_id"]
		print(all)
