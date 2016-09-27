# -*- coding: utf-8 -*-
"""
Created on Thu Jun  2 16:15:57 2016

@author: saber
"""
import sys
import jieba

# segmenter un texte chinois
reload(sys)  
sys.setdefaultencoding('utf8')

cn_input = sys.argv[1]
# recuperation et codage de la chaine d entree
txt_cn = unicode(cn_input, 'utf-8')
# recuperation des token
text = jieba.tokenize(txt_cn,mode='search')
for segment in text:
    print(segment[0])
