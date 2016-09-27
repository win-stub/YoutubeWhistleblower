# -*- coding: utf-8 -*-
"""
Created on Sun Apr 24 00:05:23 2016

@author: saber
"""

import sys
from pymongo import MongoClient
import SN_Lang as sn_lang

reload(sys)  
sys.setdefaultencoding('utf8')
# START PC PERSONNEL
# path to maltparser and model maltparser   
##script_sell           = "./generate_conll.sh" #sys.argv[1]
##input_conll           = 'input_conll.conll'   #sys.argv[2]
##output_conll          = 'output_conll.conll'   #sys.argv[3]
#
#file_name     = sys.argv[1]
#file_input    = open(file_name,"r")
#txt           = file_input.read()
##all_ids       =  ['do_swOstGaI']#txt.decode("utf8").split('\n')
#
##path_to_maltparser    = 'maltparser-1.8.1.jar' #sys.argv[3]
#
##path_to_morphtagger   = '/home/saber/DA_Stage/Stage/nltk/MorphTaggerArabe'
##path_to_treetagger    = '/home/saber/DA_Stage/treetagger/cmd'
##path_to_abbreviations = '/home/saber/DA_Stage/treetagger/lib/french-abbreviations'
##path_to_stanford      = '/home/saber/DA_Stage/stanford/stanford_ner/'
##path_to_java          = ''
# END PC PERSONNEL

# START SERVER
# path to maltparser and model maltparser
script_sell           = sys.argv[1] # "./generate_conll.sh"   #sys.argv[1]
input_conll           = sys.argv[2] # 'input_conll1.conll'    #sys.argv[2]
output_conll          = sys.argv[3] # 'output_conll1.conll'   #sys.argv[3]
#
file_name     = sys.argv[4]
file_input    = open(file_name,"r")
txt           = file_input.read()
all_ids       = txt.decode("utf8").split('\n')
#
path_to_maltparser    = 'maltparser-1.8.1.jar' #sys.argv[3]
#
path_to_morphtagger   = sys.argv[5]#'/projets/musk/Youtube/ling_youtube/nltk/MorphTaggerArabe'
path_to_treetagger    = sys.argv[6]#'/projets/musk/Youtube/ling_youtube/treetagger/cmd'
path_to_abbreviations = sys.argv[7]#'/projets/musk/Youtube/ling_youtube/treetagger/lib/french-abbreviations'
path_to_stanford      = sys.argv[8]#'/projets/musk/Youtube/ling_youtube/stanford_ner/'
path_to_java          = sys.argv[9]#'/logiciels/java1.8/bin/java'
# END SERVER

dict_lang ={
'fr':'french'  ,
'en':'english' ,
'ar':'arabic'  ,
'cn':'chinese' ,
'de':'german'  ,
'ru':'russian'
}
# dictionnaire model
dict_model_maltparser ={
'fr':'french1.3'  ,
'en':'english1.3' ,
'de':'german1.3'  ,
'cn':'chinese1.3' ,
'ru':'russian1.3' ,
'ar':'arabic1.3'
}
# dictionnaire model
dict_model_stanford ={
'en':'english3.ser.gz',
'de':'german1.ser.gz' ,
'cn':'chinese.ser.gz' ,
'fr':'french.ser.gz'  ,
'ru':'russian.ser.gz' ,
'ar':'arabic.ser.gz'  ,
'jar':'stanford-ner-3.6.0.jar',
'size-jvm':'-mx2g'
}
# relation list between word
rel_list =[['compound','name'],['amod','nmod']]
#list lang
#,'zh-cn'
server_name          = sys.argv[10]
db_anme              = sys.argv[11]
collection_name_all  = sys.argv[12]
collection_name_ling = sys.argv[13]
#
list_lang        = "en,fr,ru,de,ar,cn"
client           = MongoClient()
client           = MongoClient(server_name, 27017)
db               = client[db_anme]
collection       = db[collection_name_all]
collection_lang  = db[collection_name_ling]
#
#
for video_id in all_ids:
    # recuperation des donnees depuis MongoDB    
    col = collection.find_one({"_id":video_id})
    #video_id     = col["_id"]
    # Test if video exist in database
    if collection_lang.find({"_id": video_id}).count()<1 and collection.find({"_id": video_id}).count()>0:
        print("video exist pas "+video_id)
        # intialization of dictionary
        dict_all_doc={}                 
        for lang in list_lang.split(','):
            dict_all_doc[lang]=""        
        #tab_comments   = col["comments"]
        #title          = col["title"]
        #description    = col["description"]  
        #transcription  = col["transcription"]
        for lang in list_lang.split(','):
            txt_meta          = col[lang]
            # anglais
            #try:
            doc_meta    = sn_lang.getLingMeta(
                                              script_sell           ,
                                              txt_meta              ,                             
                                              input_conll           ,
                                              output_conll          ,
                                              path_to_maltparser    ,
                                              dict_model_maltparser ,
                                              dict_model_stanford   ,
                                              path_to_treetagger    ,
                                              path_to_morphtagger   ,
                                              path_to_stanford      ,
                                              path_to_java          ,
                                              path_to_abbreviations ,
                                              dict_lang             ,
                                              list_lang             ,
                                              lang                  ,
                                              rel_list)
            dict_all_doc[lang] = doc_meta
            #except Exception as exception_error:
            #    print type(exception_error)
            #    print exception_error.args
            #    print exception_error
            #    pass        
        # Sauvegarde dans MongoDB
        # Document comments              
        video_lang= {   
                    "_id"   :video_id           ,      
                    "en"    :dict_all_doc["en"] ,
                    "fr"    :dict_all_doc["fr"] , 
                    "de"    :dict_all_doc["de"] ,
                    "ru"    :dict_all_doc["ru"] ,
                    "cn"    :dict_all_doc["cn"] ,
                    "ar"    :dict_all_doc["ar"]                   
                    } 
        
        # Insertion and test video_id exists
        collection_lang.insert_one(video_lang)
        # update doc ling_cal=true        
        collection.update_one({'_id':video_id},{"$set":{'is_ling':'true'}},upsert=False)
    else:
        print("video exists")           
