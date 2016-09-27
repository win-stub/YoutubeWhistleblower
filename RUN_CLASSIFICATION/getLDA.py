# -*- coding: utf-8 -*-
"""
Created on Wed Jul 13 15:26:41 2016

@author: saber
"""

import sys
from pymongo import MongoClient

reload(sys)  
sys.setdefaultencoding('utf8')
#
lang             = sys.argv[1] #"en"
meta_name        = sys.argv[2] #"meta_REL" 
limit            = int(sys.argv[3]) #500
freq_min         = int(sys.argv[4]) #10
option           = sys.argv[5]
#
server_name             = sys.argv[6]
db_name                 = sys.argv[7]
collection_ling_name    = sys.argv[8]
collection_meta_name    = sys.argv[9]
#
client           = MongoClient()
client           = MongoClient(server_name, 27017)
db               = client[db_name]
collection       = db[collection_ling_name]
collection_meta  = db[collection_meta_name]
nb_video = 0
#print('id;title;contents')
#for col in collection.find({lang+'.'+meta_name: {'$regex' : '.*' + 'water' + '.*'}}).limit(limit):
if option=='VACCINE':    
    for col in collection.find({'$or':[{lang+'.'+meta_name: {'$regex' : '.*' + 'vaccine' + '.*'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'virus' + '.*'}},                                       
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'cancer' + '.*'}}]}).limit(limit):                                       
        doc_lang      = col[lang]
        video_id      = col['_id']
        meta_rel      = doc_lang[meta_name]
        col_title     = collection_meta.find_one({'_id':video_id})
        title         = col_title['title'].replace(",","").replace("'","").replace('"',"").replace(";","")
        if meta_rel!='':        
            meta_all=''
            nb_terms =0
            for meta_tmp in meta_rel.split('\n'):
                #if ('water'.lower() in meta_tmp.lower()):
                if ('vaccine'.lower() in meta_tmp.lower() or 'virus'.lower() in meta_tmp.lower()  or 'cancer'.lower() in meta_tmp):
                    meta_all = meta_all+' '+meta_tmp
                    nb_terms = nb_terms+1
            #
            if nb_terms>freq_min:
                meta_all = video_id+';'+title+';'+meta_all.replace(",","").replace("'","").replace('"',"").replace(";","")            
                print(meta_all)
#
if option=='WATER':
    for col in collection.find({lang+'.'+meta_name: {'$regex' : '.*' + 'water' + '.*'}}).limit(limit):
        doc_lang      = col[lang]
        video_id      = col['_id']
        meta_rel      = doc_lang[meta_name]
        col_title     = collection_meta.find_one({'_id':video_id})
        title         = col_title['title'].replace(",","").replace("'","").replace('"',"").replace(";","")
        if meta_rel!='':        
            meta_all=''
            nb_terms =0
            for meta_tmp in meta_rel.split('\n'):
                if ('water'.lower() in meta_tmp.lower()):
                #if ('vaccine'.lower() in meta_tmp.lower() or 'virus'.lower() in meta_tmp.lower()  or 'cancer'.lower() in meta_tmp):
                    meta_all = meta_all+' '+meta_tmp
                    nb_terms = nb_terms+1
            #
            if nb_terms>freq_min:
                meta_all = video_id+';'+title+';'+meta_all.replace(",","").replace("'","").replace('"',"").replace(";","")            
                print(meta_all)      

if option=='NER':    
    for col in collection.find({}).limit(limit):                                      
        doc_lang      = col[lang]
        video_id      = col['_id']
        meta_rel      = doc_lang[meta_name]
        col_title     = collection_meta.find_one({'_id':video_id})
        title         = col_title['title'].replace(",","").replace("'","").replace('"',"").replace(";","")
        if meta_rel!='':        
            meta_all=''
            nb_terms =0	    
            for meta_tmp in meta_rel.split('\n'):
                #if ('water'.lower() in meta_tmp.lower()):
                if (meta_tmp!=''):
                    meta_all = meta_all+' '+meta_tmp.lower()
                    nb_terms = nb_terms+1
            #
            if nb_terms>freq_min:
                meta_all = video_id+';'+title+';'+meta_all.replace(",","").replace("'","").replace('"',"").replace(";","")            
                print(meta_all)                
if option=='DEL1':   
    #print('id;title;date_year;date_full;title_data;desc_data;comments_data;transc_data')
    for col in collection.find({'$or':[{lang+'.'+meta_name: {'$regex' : '.*' + 'walking dead' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'life is strange' + '.*','$options': 'i'}}]}):        
        video_id = col['_id']  
        #col_title     = collection_meta.find_one({'_id':video_id})
        #title         = col_title['title']
        #print(video_id,'\t',title)                                 
        result = collection.delete_one({'_id': video_id})
        print(result.deleted_count)
if option=='DEL3':
    #print('id;title;date_year;date_full;title_data;desc_data;comments_data;transc_data')
    for col in collection.find({'$or':[{lang+'.'+meta_name: {'$regex' : '.*' + 'aliens' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'alien' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'ufos' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'ufo' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'star wars' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'nibiru' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'planet' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'lucifer' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'nephilim' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'illuminati' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'satanic' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'nazi' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'hitler' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'extraterrestrial' + '.*','$options': 'i'}}]}):
        video_id = col['_id']
        #col_title     = collection_meta.find_one({'_id':video_id})
        #title         = col_title['title']
        #print(video_id,'\t',title)
        result = collection.delete_one({'_id': video_id})
        print(result.deleted_count)
if option=='NG':    
    for col in collection.find({}):                                      
        doc_lang      = col[lang]
        video_id      = col['_id']
        meta_rel      = doc_lang[meta_name]
        col_title     = collection_meta.find_one({'_id':video_id})
        title         = col_title['title'].replace(",","").replace("'","").replace('"',"").replace(";","")
        if meta_rel!='':        
            meta_all=''            
            for meta_tmp in meta_rel.split('\n'):                
                if (meta_tmp!=''):
                    meta_tmp = meta_tmp.replace("\t"," ")
                    meta_all = meta_all+'\t'+meta_tmp.lower()
                    nb_terms = nb_terms+1
            #
            if nb_terms>freq_min:
            	meta_all = video_id+';'+title+';'+meta_all.replace(",","").replace("'","").replace('"',"").replace(";","")            
            	print(meta_all)
if option=='DEL2':   
    #print('id;title;date_year;date_full;title_data;desc_data;comments_data;transc_data')
    for col in collection_meta.find({'$or':[{'title': {'$regex' : '.*' + 'walking dead' + '.*','$options': 'i'}},
					    {'title': {'$regex' : '.*' + 'walkingdead' + '.*','$options': 'i'}},
                                            {'title': {'$regex' : '.*' + 'life is strange' + '.*','$options': 'i'}},
                                            {'description': {'$regex' : '.*' + 'walking dead' + '.*','$options': 'i'}},
					    {'description': {'$regex' : '.*' + 'walkingdead' + '.*','$options': 'i'}},
                                            {'description': {'$regex' : '.*' + 'life is strange' + '.*','$options': 'i'}}]}):        
    #for col in collection.find({"_id":"Ea6pt13Jp5Q"}):
        #col_tmp = col['en']  
        #col_title     = collection_meta.find_one({'_id':col['_id']})
        #title         = col_title['title']
        #col_all       = collection_all.find_one({'_id':col['_id']})
        print(col['_id'],'\t',col['title'])                                 
        result = collection.delete_one({'_id': col['_id']})
        print(result.deleted_count)
        #print(col_tmp['meta_1GRAM'])   
if option=='SER1':   
    #print('id;title;date_year;date_full;title_data;desc_data;comments_data;transc_data')
    for col in collection.find({'$or':[{lang+'.'+meta_name: {'$regex' : '.*' + 'water' + '.*','$options': 'i'}},
                                       {lang+'.'+meta_name: {'$regex' : '.*' + 'waters' + '.*','$options': 'i'}}]}):        
        doc_lang      = col[lang]
        video_id      = col['_id']      
        col_meta      = collection_meta.find_one({'_id':video_id})        
        title         = col_meta['title']       
        #
        print(video_id+' --> '+title) 
if option=='SER2':
    #print('id;title;date_year;date_full;title_data;desc_data;comments_data;transc_data')
    for col in collection.find({'$or':[{lang+'.'+meta_name: {'$regex' : '.*' + 'cancer' + '.*','$options': 'i'}}]}):
        doc_lang      = col[lang]
        video_id      = col['_id']
        col_meta      = collection_meta.find_one({'_id':video_id})
        title         = col_meta['title']
        #
	print(video_id+' --> '+title)
if option=='NGRAM':
    file_name     = "/home/saber/DA_Stage/Stage/graph/data_new2/NER/vaccine.txt"
    file_input    = open(file_name,"r")
    txt           = file_input.read()
    all_ids       = txt.decode("utf8").split('\n')   
    while '' in all_ids:
        all_ids.remove('')
    for term in all_ids:        
        video_id      = term.split('  -->  ')[0]
        col           = collection.find_one({'_id':video_id})                                    
        doc_lang      = col[lang]
        video_id      = col['_id']
        meta_rel      = doc_lang[meta_name]
        col_title     = collection_meta.find_one({'_id':video_id})
        title         = col_title['title'].replace(",","").replace("'","").replace('"',"").replace(";","")
        if meta_rel!='':        
            meta_all=''
            nb_terms =0
            for meta_tmp in meta_rel.split('\n'):
                #if ('water'.lower() in meta_tmp.lower()):
                if (meta_tmp!=''):
                    meta_tmp = meta_tmp.replace("\t"," ")
                    meta_all = meta_all+'\t'+meta_tmp.lower()
                    nb_terms = nb_terms+1
            #
            if nb_terms>freq_min:
                meta_all = video_id+';'+title+';'+meta_all.replace(",","").replace("'","").replace('"',"").replace(";","")            
                print(meta_all)
if option=='TEST':
    print('id;title;contents')   
    # all pattern
    file_pattern     = "/projets/musk/Youtube/ling_youtube/data_train/patterns_vaccine.txt"
    pattern_input    = open(file_pattern,"r")
    txt_pattern      = pattern_input.read()
    all_pattern      = txt_pattern.decode("utf8").split('\n')     
    ######
    while '' in all_pattern:
        all_pattern.remove('')
    ######
    all_meta = ['meta_2GRAM','meta_3GRAM','meta_4GRAM','meta_5GRAM','meta_REL','meta_NG','meta_NER']    
    for col in collection.find({}):
        term_tmp      = ['1','2']
        if len(term_tmp)==1 :
            class_name = term_tmp[0]            
        else:
            meta_all=''
            video_id     = col['_id']            
            col_meta     = collection_meta.find_one({'_id':video_id})  
            title_name   = col_meta['title']
            doc_lang     = col[lang]            
            for meta_name in all_meta:                 
                meta_kind     = doc_lang[meta_name]
                if meta_kind!='':
                    for meta_tmp in meta_kind.split('\n'):                   
                        if (meta_tmp!='' and meta_tmp in all_pattern):
                            meta_tmp = meta_tmp.replace("\t"," ")
                            meta_all = meta_all+'\t'+meta_tmp.lower()        
            meta_all = video_id+';'+title_name+';'+meta_all.replace(",","").replace("'","").replace('"',"").replace(";","")            
            print(meta_all) 
if option=='NG_TEST':    
    print('id;title;contents') 
    for col in collection.find({}):
        doc_lang      = col[lang]
        video_id      = col['_id']
        meta_rel      = doc_lang[meta_name]
        col_title     = collection_meta.find_one({'_id':video_id})
        title         = col_title['title'].replace(",","").replace("'","").replace('"',"").replace(";","")
        #if meta_rel!='':        
        meta_all=''
        nb_terms =0
        for meta_tmp in meta_rel.split('\n'):
            #if ('water'.lower() in meta_tmp.lower()):
            if (meta_tmp!=''):
                meta_tmp = meta_tmp.replace("\t"," ")
                meta_all = meta_all+'\t'+meta_tmp.lower()
                nb_terms = nb_terms+1
            #            
        meta_all = video_id+';'+title+';'+meta_all.replace(",","").replace("'","").replace('"',"").replace(";","")            
        print(meta_all) 
