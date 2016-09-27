# -*- coding: utf-8 -*-
# coding: utf8
"""
Created on Mon Apr 18 13:47:21 2016

@author: saber
"""
import encodings
from nltk.tag import StanfordPOSTagger
from __future__ import unicode_literals

st = StanfordPOSTagger('english-bidirectional-distsim.tagger') 





# Train models CRF
from nltk.tag import CRFTagger

ct = CRFTagger()
train_data = [[(unicode('dog'),'Noun'),(unicode('eat'),'Verb'),(unicode('meat'),'Noun')]]
ct.train(train_data,'model.crf.tagger')
ct.tag_sents([[unicode('dog'),unicode('is'),unicode('good')], [unicode('Cat'),unicode('eat'),unicode('meat')]])
gold_sentences = [[('dog','Noun'),('is','Verb'),('good','Adj')] , [('Cat','Noun'),('eat','Verb'), ('meat','Noun')]]
ct.evaluate(gold_sentences) 
# 

import nltk.data as data
words = ['some', 'words', 'in', 'a', 'sentence']
feats = dict([(word, True) for word in words])
data.classify(feats)


from nltk.util import ngrams
import nltk

sentence = 'this is a foo bar sentences and i want to ngramize it'
sentence_english    = unicode("At eight o'clock on Thursday morning Arthur didn't feel very good.")
sentense_arabe      = unicode("مقابلة صعبة على ارض ميدان كارثية تشبه مزارع البطاطس")
sentense_portegais  = unicode("Eu tenho plantada em minha casa  uma árvore do Pau Brasil e é uma \nmaravilha! Uma sombra abençoada.")
sentense_china      = unicode("于文文淘汰~说明这个节目还行~挺公正的~")
sentense_russia     = unicode("Пятая колонна,-это проплаченные предатели! ПАРНАС-передать срочно Западу!")
sentense_spain      = unicode("Mi gran deseo es ir a España y conocer los lugares de donde partieron mis ancestros. Saludos desde Costa Rica.")
sentense_deuch      = unicode("Iridium ist ein chemisches Element mit dem Symbol Ir und der Ordnungszahl 77.")
sentense_french     = unicode("L’Allemagne va arrêter plusieurs vieilles centrales au charbon")

n = 1
tokens = nltk.word_tokenize(sentense_french)
sixgrams = ngrams(tokens, n)
for i in tokens:
    print i   
for grams in sixgrams:
  print grams
  
  
 from nltk.collocations import *
 import nltk
 #You should tokenize your text
 text = "I do not like green eggs and ham, I do not like them Sam I am!"
 tokens = nltk.word_tokenize(sentense_russia )
 for i in tokens:
    print i 
 len(tokens)
 tokens = nltk.wordpunct_tokenize(sentense_russia )
 for i in tokens:
    print i 
 len(tokens)
 fourgrams=nltk.collocations.QuadgramCollocationFinder.from_words(tokens)
 for fourgram, freq in fourgrams.ngram_fd.items():  
       print fourgram, freq  

# Tokennize fril file txt
file_txt = open('/home/saber/DA_Stage/Stage/nltk/data/fr.txt') 
txt = file_txt.read().encode('utf8')
print(txt)
tokens = nltk.word_tokenize(txt)
#for i in tokens:
#    print i
text = nltk.Text(tokens)   
text.collocations()
len(text)
len(set(text)) 
text.count('centrales')

from nltk.tokenize import word_tokenize
from nltk.probability import FreqDist

sent = 'This is an example sentence'
fdist = FreqDist()
for word in tokens:
    fdist[word.lower()] += 1
fdist.tabulate()    
#print(text)
#nltk.pos_tag(tokens)
ngrams = nltk.ngrams(text,4)
for grams in ngrams:
  print grams

       