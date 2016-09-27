# -*- coding: utf-8 -*-
"""
Created on Tue May 17 13:06:51 2016

@author: saber
"""
import sys
from nltk.tokenize import sent_tokenize
#from polyglot.text import Text

reload(sys)  
sys.setdefaultencoding('utf8')

# recuperation des phrases
def getSents(txt,lang,lang_list):    
    sent_list = []
    if (lang!='None') and (lang!='ar') and (lang in lang_list)==True:    
        sent_list = sent_tokenize(txt.decode("utf8"), language=lang)
        #
    else:
        #text = Text(txt) 
        #sent_list = text.sentences
        sent_list = []
    return sent_list
