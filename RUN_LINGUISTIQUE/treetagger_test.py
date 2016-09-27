# -*- coding: utf-8 -*-
"""
Created on Mon Apr 25 13:07:21 2016

@author: saber
"""
import sys
from treetagger import TreeTagger

reload(sys)  
sys.setdefaultencoding('utf8')

def getTAGS(treetagger_languages,path,abbrevaiations,text,lang):        
    try:       
        treetagger_paths = [path]
        tags = TreeTagger(treetagger_languages = treetagger_languages ,
                          treetagger_paths=treetagger_paths           ,
                          encoding='utf-8'                            , 
                          verbose=False                               , 
                          abbreviation_list=abbrevaiations            ,
                          language=lang)        
        result_tag = tags.tag(text)
    except:
        #pass
        result_tag = "None"
    return result_tag
