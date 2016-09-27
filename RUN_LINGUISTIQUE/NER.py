# -*- coding: utf-8 -*-
"""
Created on Tue May 31 15:21:04 2016

@author: saber
"""

import sys
from polyglot.text import Text
from get_dep_conll import getSents

from nltk.tag import StanfordNERTagger
from nltk.tokenize import word_tokenize

from itertools import groupby

reload(sys)  
sys.setdefaultencoding('utf8')

list_lang        = "en,fr,ar,ru,cn,de"
input_conll   = '/home/saber/DA_Stage/Stage/nltk/data/transcription1.srt'#sys.argv[1]
file_input  = open(input_conll,"r")
#file_output = open(output_conll,"w")
 
txt   = file_input.read()


texte = txt.decode("utf8").split('\n')
texte_space =''
for line in texte:
    if len(line.strip())!=0:
        texte_space=texte_space+line+'\n'

sent = getSents(texte_space.strip(),'fr',list_lang.split(','))

print(sent[0])
########################## extraction des entités nommées
input_conll   = '/home/saber/DA_Stage/stanford/data_train/trans1.tok'#sys.argv[1]
input_conll   = '/home/saber/DA_Stage/stanford/data_train/trans1.txt'#sys.argv[1]
input_conll   = '/home/saber/DA_Stage/stanford/train_fr/aij-wikiner-fr-wp3'#sys.argv[1]


file_input  = open(input_conll,"r")
txt   = file_input.read()
texte = txt.decode("utf8")
nb_sent=1
print(len(texte.split('\n')))
for line in texte.split('\n'):
    if (len(line)!=0):
        line_tmp = line.split(' ')
        for tag in line_tmp:
            tag_tmp = tag.split('|')
            print(tag_tmp[0]+'\t'+tag_tmp[1]+'\t'+tag_tmp[2])
        break
    else:
        print('')        
# 
st = StanfordNERTagger('/home/saber/DA_Stage/stanford/train_en/english.ser.gz'  ,
		       '/home/saber/DA_Stage/stanford/stanford_ner/stanford-ner-3.6.0.jar'       ,
		       encoding='utf-8')
# tous en miniscule
texte =texte.lower()
# meme txt
r=st.tag(texte.split())
for tag, chunk in groupby(r, lambda x:x[1]):
    if tag != "O":
        print("%-12s"%tag, " ".join(w for w, t in chunk))          