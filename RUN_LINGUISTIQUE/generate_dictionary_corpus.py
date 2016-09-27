# -*- coding: utf-8 -*-
"""
Created on Thu Jun 23 18:19:08 2016

@author: saber
"""

import SN_getDictCorpus as sn_corpus

server_name           = sys.argv[1]
db_name               = sys.argv[2]
collection_meta_name  = sys.argv[3]
try:
    sn_corpus.getDICT(server_name,db_name,collection_meta_name)
except Exception as exception_error:      
      pass
