# -*- coding: utf-8 -*-
"""
Created on Tue May 31 17:07:43 2016

@author: saber
"""

import sys
from nltk.tag import StanfordNERTagger
from itertools import groupby

reload(sys)  
sys.setdefaultencoding('utf8')

def getNER(txt,lang,lang_list,tag_list,dict_lang,path_to_models,path_to_stanford):
    # list de retour
    list_ner=''
    if (lang!='None') and (lang in lang_list)==True:         
        st = StanfordNERTagger(path_to_models+dict_lang[lang]  ,
		               path_to_stanford                ,
		               encoding='utf-8')
        r=st.tag(txt.split())
        for tag, chunk in groupby(r, lambda x:x[1]):
            if tag != "O" and tag in tag_list:
                #print(tag+"\t".join(w for w, t in chunk))
                list_ner=list_ner+tag+"\t".join(w for w, t in chunk)+'\n'
    else:
        print('no ok')
    return (list_ner)