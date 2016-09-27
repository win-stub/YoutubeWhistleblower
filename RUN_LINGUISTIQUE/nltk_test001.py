# -*- coding: utf-8 -*-
"""
Created on Mon Apr 18 11:53:41 2016

@author: saber
"""

import nltk
from nltk.tokenize.stanford_segmenter import StanfordSegmenter
from nltk.corpus import treebank

# Exemple sentense
sentence_english    = unicode("At eight o'clock on Thursday morning Arthur didn't feel very good.")
sentense_arabe      = unicode("مقابلة صعبة على ارض ميدان كارثية تشبه مزارع البطاطس")
sentense_portegais  = unicode("Eu tenho plantada em minha casa  uma árvore do Pau Brasil e é uma \nmaravilha! Uma sombra abençoada.")
sentense_china      = unicode("于文文淘汰~说明这个节目还行~挺公正的~")
sentense_russia     = unicode("Пятая колонна,-это проплаченные предатели! ПАРНАС-передать срочно Западу!")
sentense_spain      = unicode("Mi gran deseo es ir a España y conocer los lugares de donde partieron mis ancestros. Saludos desde Costa Rica.")
sentense_deuch      = unicode("Iridium ist ein chemisches Element mit dem Symbol Ir und der Ordnungszahl 77.")
sentense_french     = unicode("L’Allemagne va arrêter plusieurs vieilles centrales au charbon")

# Les tokens français
print(sentense_french)
tokens_fr = nltk.word_tokenize(sentense_french)
print(len(tokens_fr))
for i in tokens_fr:
    print i   
# Les tokens arabe
print(sentense_arabe)
tokens_ar = nltk.word_tokenize(sentense_arabe)
print(len(tokens_ar))
for i in tokens_ar:
    print i        
# Les tokens portegais
print(sentense_portegais)
tokens_po = nltk.word_tokenize(sentense_portegais)
for i in tokens_po:
    print i
# Les tokens china
print(sentense_china)
tokens_cn = nltk.word_tokenize(sentense_china)
for i in tokens_cn:
    print i    
# Les tokens russian
print(sentense_russia)
tokens_ru = nltk.word_tokenize(sentense_russia)
for i in tokens_ru:
    print i 
# Les tokens english
print(sentence_english)
tokens_en = nltk.word_tokenize(sentence_english)
for i in tokens_en:
    print i     
# les tag arabic
tagged_en = nltk.pos_tag(tokens_en) 
print(len(tagged_en))
for i in tagged_en:
    print i 
# les tag english
tagged_ar = nltk.pos_tag(tokens_ar) 
print(len(tagged_ar))
for i in tagged_ar:
    print i    
# les tag french
tagged_fr = nltk.pos_tag(tokens_fr) 
print(len(tagged_fr))
for i in tagged_fr:
    print i     

text = nltk.word_tokenize(unicode("And now for something completely different"))
nltk.pos_tag(text)