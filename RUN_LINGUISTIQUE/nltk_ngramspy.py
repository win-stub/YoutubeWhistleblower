# -*- coding: utf-8 -*-
"""
Created on Mon Apr 18 16:59:11 2016

@author: saber
"""

import nltk

# Tokennize fril file txt
file_txt = open('/home/saber/data/some_fr.txt') 
txt = file_txt.read().encode('utf8')
print(txt)
tokens = nltk.word_tokenize(txt)
tokens_tagger = ['Aujourd’hui','l','Allemagne','va','arrêter','plusieurs','vieilles','centrales','au','charbon','.']
#for i in tokens:
#    print i
text        = nltk.Text(tokens)  
text_tagger = nltk.Text(tokens_tagger)  
 
text.collocations()
len(text)
len(set(text)) 
text.count('centrales')
#print(text)
#nltk.pos_tag(tokens)
n_grams         = nltk.ngrams(text,2)
n_grams_tagger  = nltk.ngrams(text_tagger,2)

#ignored_words = nltk.corpus.stopwords.words('french')

for grams in n_grams:  
      print(grams[0]+'  '+grams[1])

for grams in n_grams_tagger:  
      print(grams[0]+'  '+grams[1])  

from nltk.util import ngrams

def word_grams(words, min=1, max=4):
    s = []
    for n in range(min, max):
        for ngram in ngrams(words, n):
            s.append(' '.join(str(i) for i in ngram))
    return s

print word_grams('one two three four'.split(' '))  