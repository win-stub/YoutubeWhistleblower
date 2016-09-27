# -*- coding: utf-8 -*-
"""
Created on Wed Jun 22 17:32:37 2016

@author: saber
"""

import sys
from pymongo import MongoClient
import SN_Collect as sn_collect


reload(sys)  
sys.setdefaultencoding('utf8')

list_lang        = "en,fr,ru,de,ar,cn"

# Start les tests au niveau de PC Personnel
#client           = MongoClient()
#client           = MongoClient('localhost', 27017)
#db               = client['youtube']
#collection       = db['corpus_youtube.meta']
#collection_tmp   = db['corpus_youtube.all.tmp2']
#nb_video=0
# file for the id list
#file_name     = '/home/saber/DA_Stage/Result_Frequence/log/folder_ids/folder_ids_partie2/xaa'
#file_input    = open(file_name,"r")
#txt           = file_input.read()
#all_ids       = txt.decode("utf8").split('\n')
#all_ids = ['FoEwf_lynsU','XSuKGgIRAew','4R94fJGZ_c8','M3O9Nhs-zWE','i8Ihl_gOw94','cUgJ10IV0x0','G5ImnAQAS_M','cNWOpxK6dhc','M93GrE5Ny84','MAYCeXpooRQ','M51j1Taddsc','A8r9lFitswc','FlEmJ3WgiVE','cEr6l-PEafQ',
#'cF6JN-PtSDE','RcZfn6mkTUo','RcdqS3kHy-8','Rcvawgv9uwA','cFbwePWTrTU','FlgM0voWKUc','FloVDjZUmok','cFlKeHZ8W2A','A9VAcVbAITg','Re9BvSGNDAU','cHe4uAm_9n4','FmZSddE3edA','cJgTGFIk73g',
#'cJnBDLn-fDE','AD1wm-hL_As','ADObFs4zHNQ','LwciQIcQlMs','cN7vjccImtY','LzVfR-G3vW0','cEr6l-PEafQ','FlqNe_wBS18','LslfRYAkSc8','Re9BvSGNDAU','cHe4uAm_9n4','Rf0xsMp2SK4','AAQ5qnzHlus','XNLIy7gckro','FmZSddE3edA','Lu6q_mS_Gyk',
#'cIhDVWYnfsk','LslfRYAkSc8','cHe4uAm_9n4','Rf5eXAaEPyE','AAQ5qnzHlus','AAXhtbSr1_M','XNLikdqhTC0','cKMFG1_Sh4Y','LwDJy4P_cnk','XQ_JLAnvC7Q','--BjA08E2ZU','LyrxsZC4IIY']

#file_input  = open("/home/saber/data_test/dict.conll","r")
#txt         = file_input.read()
#all_words       = txt.decode("utf8").split('\n')

# type save format
# type_save ="1" format numero 1 all in some bloc
# type_save ="2" format numero 2 differents blocs
# type_save ="2"
# END les tests au niveau du PC Personnel
# START tests au niveau de Serveur
server_name          = sys.argv[1]
db_name              = sys.argv[2]
collection_meta_name = sys.argv[3]
collection_all_name  = sys.argv[4]

client           = MongoClient()
client           = MongoClient(server_name, 27017)
db               = client[db_name]
collection	 = db[collection_meta_name]
collection_tmp   = db[collection_all_name]

nb_video=0
file_name1     = sys.argv[5]
file_input1    = open(file_name1,"r")
txt1           = file_input1.read()
all_ids       = txt1.decode("utf8").split('\n')

file_name2  = sys.argv[6]
file_input2  = open(file_name2,"r")
txt2         = file_input2.read()
all_words	= txt2.decode("utf8").split('\n')

# type save format
# type_save ="1" format numero 1 all in some bloc
# type_save ="2" format numero 2 differents blocs
type_save =sys.argv[7]
# END tests au niveau de Serveur

# charger le dictionnaire
dict_corpus = {}
for line in all_words:
    if len(line.split('\t'))!=0:
        try:
            dict_corpus[line.split('\t')[0]+'\t'+line.split('\t')[1]] = int(line.split('\t')[2])            
        except Exception:
            pass

if type_save=="1":       
    ##for col in collection.find({}).limit(1000):  
    #for col in collection.find({"_id":{"$in" : all_ids}}):
    for video_id in all_ids:
        lang_comments=[]
        dict_video = {}
        # recuperation des donnees depuis MongoDB
        col = collection.find_one({"_id":video_id})           
        # Test if video exist in database
        if collection_tmp.find({"_id": video_id}).count()<1:
            print(video_id+"\t"+str(nb_video))
            tab_comments   = col["comments"]
            title          = col["title"]
            description    = col["description"]  
            transcription  = col["transcription"]
            # initialization of a dictionnary
            for lang in list_lang.split(','):
                dict_video[lang]=''
                    # Les commentaires           
            try:
                
                # les titres
                sn_collect.getAllMetaLang(title,dict_video,list_lang,False,dict_corpus,2)
                # les descriptions
                sn_collect.getAllMetaLang(description,dict_video,list_lang,False,dict_corpus,2)
                # les transcriptions
                sn_collect.getAllMetaLang(transcription,dict_video,list_lang,True,dict_corpus,2)  
                # les commentaires
                if tab_comments!=None:                    
                    for comment in tab_comments:                        
                        u_message_comments = comment["message"]
                        sn_collect.getAllMetaLang(u_message_comments,dict_video,list_lang,False,dict_corpus,2)
            except Exception as exception_error:
                print type(exception_error)
                print exception_error.args
                print exception_error
                pass
            #affichage du dictionnaire
            #for key_lang in dict_video.keys():
            #    if key_lang=='en':
            #        print(dict_video[key_lang])
            # traitement         
            video_tmp= {   
                        "_id"  :  video_id          ,      
                        "ar"   :  dict_video['ar']  ,
                        "en"   :  dict_video['en']  ,
                        "fr"   :  dict_video['fr']  , 
                        "de"   :  dict_video['de']  ,
                        "ru"   :  dict_video['ru']  ,
                        "cn"   :  dict_video['cn']  ,
                        "is_ling": "false"
                        } 
            # Insertion and test video_id exists
            try:                    
                collection_tmp.insert_one(video_tmp)
            except Exception as exception_error:
                print type(exception_error)
                print exception_error.args
                print exception_error
                pass        
            nb_video = nb_video +1
            # update doc ling_cal=true        
            collection.update_one({'_id':video_id},{"$set":{'is_ling':'true'}},upsert=False)        
        else:
            print(video_id+'\t'+'exist')
# type de sauvegarde numero 2
if type_save=="2":       
    #for col in collection.find({"is_ling":"false"}).limit(10):  
    #for col in collection.find({"_id":{"$in" : all_ids}}):
    for video_id in all_ids:   
        lang_comments=[]
        dict_video_title         = {}
        dict_video_desc          = {}
        dict_video_comments      = {}
        dict_video_transcription = {}
        # recuperation des donnees depuis MongoDB
        col = collection.find_one({"_id":video_id})   
        # Test if video exist in database
        if collection_tmp.find({"_id": video_id}).count()<1:
            print(video_id+"\t type 2 \t"+str(nb_video))
            tab_comments   = col["comments"]
            title          = col["title"]
            description    = col["description"]  
            transcription  = col["transcription"]
            # initialization of a dictionnary
            for lang in list_lang.split(','):
                dict_video_title[lang]         =''
                dict_video_desc[lang]          =''
                dict_video_comments[lang]      =''
                dict_video_transcription[lang] =''
                    # Les commentaires           
            try:
                
                # les titres
                sn_collect.getAllMetaLang(title,dict_video_title,list_lang,False,dict_corpus,2)
                # les descriptions
                sn_collect.getAllMetaLang(description,dict_video_desc,list_lang,False,dict_corpus,2)
                # les transcriptions
                sn_collect.getAllMetaLang(transcription,dict_video_transcription,list_lang,True,dict_corpus,2)  
                # les commentaires
                if tab_comments!=None:
                    for comment in tab_comments:                        
                        u_message_comments = comment["message"]
                        sn_collect.getAllMetaLang(u_message_comments,dict_video_comments,list_lang,False,dict_corpus,2)
            except Exception as exception_error:
                print type(exception_error)
                print exception_error.args
                print exception_error
                pass
            #affichage du dictionnaire
            #for key_lang in dict_video.keys():
            #    if key_lang=='en':
            #        print(dict_video[key_lang])
            # traitement         
            video_tmp= {   
                        "_id"  :  video_id          ,      
                        "ar"   :  {"title":dict_video_title['ar'],"description":dict_video_desc['ar'],"comments":dict_video_comments['ar'],"transcription":dict_video_transcription['ar']}  ,
                        "en"   :  {"title":dict_video_title['en'],"description":dict_video_desc['en'],"comments":dict_video_comments['en'],"transcription":dict_video_transcription['en']}  ,
                        "fr"   :  {"title":dict_video_title['fr'],"description":dict_video_desc['fr'],"comments":dict_video_comments['fr'],"transcription":dict_video_transcription['fr']}  ,
                        "de"   :  {"title":dict_video_title['de'],"description":dict_video_desc['de'],"comments":dict_video_comments['de'],"transcription":dict_video_transcription['de']}  ,
                        "ru"   :  {"title":dict_video_title['ru'],"description":dict_video_desc['ru'],"comments":dict_video_comments['ru'],"transcription":dict_video_transcription['ru']}  ,
                        "cn"   :  {"title":dict_video_title['cn'],"description":dict_video_desc['cn'],"comments":dict_video_comments['cn'],"transcription":dict_video_transcription['cn']}  ,
                        "is_ling": "false"
                        } 
            # Insertion and test video_id exists
            try:                    
                collection_tmp.insert_one(video_tmp)
            except Exception as exception_error:
                print type(exception_error)
                print exception_error.args
                print exception_error
                pass        
            nb_video = nb_video +1
            # update doc ling_cal=true        
            collection.update_one({'_id':video_id},{"$set":{'is_ling':'true'}},upsert=False)        
        else:
            print(video_id+'\t'+'exist')             
