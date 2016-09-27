# -*- coding: utf-8 -*-
"""
Created on Thu May 12 13:42:57 2016

@author: saber
"""
import os
import nltk
from nltk.parse import malt

reload(sys)  
sys.setdefaultencoding('utf8')

os.environ['MALT_PARSER']="/home/saber/DA_Stage/parser/maltparser/french-malt"
os.environ['MALT_MODEL']="/home/saber/DA_Stage/parser/maltparser/french-malt"

maltParser = malt.MaltParser("maltparser-1.8.1", 
                             "french.mco"
                            )
txt = '''Nous prions les cinéastes et tous nos lecteurs de bien vouloir nous en excuser.'''
text = unicode(txt, 'utf-8')
text = unicode('''
Le	DET:ART	le
métro	NOM	métro
de	PRP	de
Montréal	NAM	Montréal
est	VER:pres	être
un	DET:ART	un
service	NOM	service
de	PRP	de
transport	NOM	transport
en	PRP	en
commun	NOM	commun
qui	PRO:REL	qui
dessert	VER:pres	desservir
l	VER:pper	l
île	NOM	île
de	PRP	de
Montréal	NAM	Montréal
ainsi	ADV	ainsi
que	KON	que
les	DET:ART	le
villes	NOM	ville
de	PRP	de
Laval	NAM	Laval
et	KON	et
de	PRP	de
Longueuil	NAM	Longueuil
au	PRP:det	au
Québec	NAM	Québec
.	SENT	.
''', 'utf-8')

graph = maltParser.parse_tagged_sents(text)
print(graph)

type(graph)
print(graph.__iter__)