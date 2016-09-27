# -*- coding: utf-8 -*-
"""
Created on Wed May 18 12:44:10 2016

@author: saber
"""
import sys
from subprocess import Popen, PIPE
import ngram
import NER_stanford
import SN_extract_dep as extract
import SN_ng as noun_group


reload(sys)  
sys.setdefaultencoding('utf8')

treetagger_languages = {
u'latin-1':['latin', 'latinIT', 'mongolian', 'swahili'],
u'utf-8' : ['bulgarian', 'dutch', 'english', 'estonian', 'finnish', 'french', 
            'galician', 'german', 'italian', 'polish', 'russian', 'slovak', 
            'slovak2', 'spanish','chinese']}
def getLingMeta (script_shell          ,
                 meta                  ,
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
                 dict_lang_treetagger  ,
                 list_lang             ,
                 lang_meta             ,
                 rel_list):  
        ner=''
        ngram_meta1       =''#[]
        ngram_meta2       =''#[]
        ngram_meta3       =''#[]
        ngram_meta4       =''#[]
        ngram_meta5       =''#[]
        ng_meta           ='' 
        rel_meta          =''
        deps_meta         ='' 
        # Le titre  
        if len(meta.strip())!=0:        
            u_txt = ngram.getMessageUTF(meta.strip())                     
            #print(u_txt)   
            #print('**************************************************************')
            #lang_meta = ngram.getLANG(u_txt)
            tab_list_lang = list_lang.split(',')
            if lang_meta in tab_list_lang:
                #print(lang)
                # calcul NGRAM   
                txt_all_sentence =  u_txt.replace('**********new_sentence**********','')
                tab_txt = txt_all_sentence.split('\n')
                for txt_sentence in tab_txt:
                    #txt_sentence_tmp = ngram.getMessageUTF(txt_sentence)
                    try:                     
                        ngram_meta1 = ngram_meta1+ngram.getNGRAM(txt_sentence.strip(),lang_meta,list_lang,1) 
                    except Exception as exception_error:
                        print type(exception_error)
                        print exception_error.args
                        print exception_error
                        pass                          
                    try:                     
                        ngram_meta2 = ngram_meta2+ngram.getNGRAM(txt_sentence.strip(),lang_meta,list_lang,2) 
                    except Exception as exception_error:
                        print type(exception_error)
                        print exception_error.args
                        print exception_error
                        pass  
                    try:                     
                        ngram_meta3 = ngram_meta3+ngram.getNGRAM(txt_sentence.strip(),lang_meta,list_lang,3) 
                    except Exception as exception_error:
                        print type(exception_error)
                        print exception_error.args
                        print exception_error
                        pass         
                    try:                     
                        ngram_meta4 = ngram_meta4+ngram.getNGRAM(txt_sentence.strip(),lang_meta,list_lang,4) 
                    except Exception as exception_error:
                        print type(exception_error)
                        print exception_error.args
                        print exception_error
                        pass        
                    try:                     
                        ngram_meta5 = ngram_meta5+ngram.getNGRAM(txt_sentence.strip(),lang_meta,list_lang,5) 
                    except Exception as exception_error:
                        print type(exception_error)
                        print exception_error.args
                        print exception_error
                        pass                      
                # calcul les entités nommées   
                try:                     
                    ner =  NER_stanford.getNER(txt_all_sentence,lang_meta,dict_model_stanford,path_to_stanford,path_to_java)
                except Exception as exception_error:
                    print type(exception_error)
                    print exception_error.args
                    print exception_error
                    pass                                                                                             
                #print(path_to_treetagger)
                #print(u_txt)
                #tags_title  = treetagger_test.getTAGS(treetagger_languages ,
                #                                      path_to_treetagger   ,
                #                                      None                 ,
                #                                      u_txt.strip()        ,
                #                                      'chinese')
                #print(tags_title)
                # les arbres de dependance                        
                deps_meta=''
                try:                
                    p = Popen([    script_shell,
                                   #input_conll,
                                   ##output_conll,
                                   path_to_maltparser,
                                   str(dict_model_maltparser.get(lang_meta)),
                                   #"treetagger_languages",
                                   path_to_treetagger,
                                   path_to_morphtagger,
                                   path_to_abbreviations,
                                   lang_meta,
                                   str(dict_lang_treetagger.get(lang_meta)),
                                   list_lang,
                                   u_txt.strip()
                                   ],stdout=PIPE,stderr=PIPE)                                                                                             
                    output, errors = p.communicate()
                    print(errors)
                    print(output)                                                                             
                    #
                    file_input  = open(output_conll,"r")            
                    txt         = file_input.read()
                    #
                    deps_meta = txt 
                    # NOUN GROUP AND RELATION WORDS
                    ng_meta   = noun_group.getNG(txt,lang_meta)
                    # RELATION               
                    rel_meta  = extract.getDEPS(txt,rel_list[0],rel_list[1])
                    #if tags_title=='None':
                    #   tags_title=['None']
                except Exception as exception_error:
                    print type(exception_error)
                    print exception_error.args
                    print exception_error                                                            
                    pass                     
            else:
                ner=''
                lang_meta   ="None"
                ngram_meta1 =''#[] 
                ngram_meta2 =''#[] 
                ngram_meta3 =''#[] 
                ngram_meta4 =''#[] 
                ngram_meta5 =''#[] 
                ng_meta     ='' 
                rel_meta    =''
                deps_meta   =''                
            #print('**************************************************************')
        else:
            ner=''
            lang_meta   ="None"
            ngram_meta1 =''#[] 
            ngram_meta2 =''#[] 
            ngram_meta3 =''#[] 
            ngram_meta4 =''#[] 
            ngram_meta5 =''#[] 
            ng_meta     =''
            rel_meta    =''
            deps_meta   ='' 
        # Document title
        doc_meta    = {
                      "meta_LANG" :lang_meta   ,
                      "meta_1GRAM":ngram_meta1 ,
                      "meta_2GRAM":ngram_meta2 ,
                      "meta_3GRAM":ngram_meta3 ,
                      "meta_4GRAM":ngram_meta4 ,
                      "meta_5GRAM":ngram_meta5 ,
                      "meta_NG"   :ng_meta     ,
                      "meta_REL"  :rel_meta    ,
                      "meta_NER"  :ner         ,
                      "meta_DEPS" :deps_meta
                      }
        return doc_meta