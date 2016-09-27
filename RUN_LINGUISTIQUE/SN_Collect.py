# -*- coding: utf-8 -*-
"""
Created on Wed May 18 12:44:10 2016

@author: saber
"""
import sys
import ngram
from nltk.tokenize import sent_tokenize
import SN_paragraph as sn_paragraph


reload(sys)  
sys.setdefaultencoding('utf8')

def getAllMetaLang (meta             ,
                    dict_video       ,
                    list_lang        ,
                    is_transcription ,
                    dict_corpus      ,
                    seuil
                    ):                     
        #
        if is_transcription==True:
            if len(meta.strip())!=0:        
                u_txt = ngram.getMessageUTF(meta.strip())                     
                #print(u_txt)   
                #print('**************************************************************')
                lang_meta = ngram.getLANG(u_txt)
                tab_list_lang = list_lang.split(',')                
                if (lang_meta in tab_list_lang) and (lang_meta!='None') and (lang_meta!='ar') :
                    # recuperation des sentence   
                    new_sent =''
                    new_sent = sn_paragraph.getPARAGRAPH(meta,dict_corpus,seuil)                                       
                    dict_video[lang_meta] = new_sent
                else:                
                    if lang_meta=='ar':
                        # recuperation des sentence            
                        new_sent =''            
                        new_sent = sn_paragraph.getPARAGRAPH(meta,dict_corpus,seuil)                
                        dict_video[lang_meta] = new_sent                   
        else:        
            if len(meta.strip())!=0:        
                u_txt = ngram.getMessageUTF(meta.strip())                     
                #print(u_txt)   
                #print('**************************************************************')
                lang_meta = ngram.getLANG(u_txt)
                tab_list_lang = list_lang.split(',')                
                if (lang_meta in tab_list_lang) and (lang_meta!='None') and (lang_meta!='ar') :
                    # recuperation des sentence            
                    sent_list = sent_tokenize(u_txt.decode("utf8"), language=lang_meta)                              
                    for sent in sent_list:                   
                        dict_video[lang_meta] = dict_video[lang_meta]+'\n'+sent+'\n**********new_sentence**********'                                        
                else:                
                    if lang_meta=='ar':
                        # recuperation des sentence            
                        sent_list = sent_tokenize(u_txt.decode("utf8"), language="en")                              
                        for sent in sent_list:                   
                            dict_video[lang_meta] = dict_video[lang_meta]+'\n'+sent+'\n**********new_sentence**********'