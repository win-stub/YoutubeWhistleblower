# -*- coding: utf-8 -*-
"""
Created on Tue Apr 19 16:45:21 2016

@author: saber
"""

import nltk
from nltk.chunk import *
import re

# sentense with POS
sentence = [("the", "DT"), ("little", "JJ"), ("yellow", "JJ"), ("dog", "NN"), ("barked", 
            "VBD"), ("at", "IN"), ("the", "DT"), ("cat", "NN")]
txt=[
("Le", "DET:ART"),
("Cercle	", "NAM"),
("athlétique","ADJ"),
("de", "PRP"),
("Neuilly", "NAM"),
(",", "PUN"),
("abrégé	", "VER:pper"),
("en", "PRP"),
("CA", "NAM"),
("Neuilly", "NAM"),
(",", "PUN"),
("est", "VER:pres"),
("un", "DET:ART"),
("club", "NOM"),
("de", "PRP"),
("football", "NOM"),
("français", "ADJ"),
("fondé", "VER:pper"),
("en", "PRP"),
("",""),
("1893", "NUM"),
(",", "PUN"),
("disparu", "VER:pper"),
("en", "PRP"),
("1896", "NUM"),
("et", "KON"),
("basé", "VER:pper"),
("à", "PRP"),
("Neuilly-sur-Seine", "NAM"),
(",", "PUN"),
("commune", "NOM"),
("limitrophe", "ADJ"),
("de", "PRP"),
("Paris", "NAM"),
(".", "SENT")
]
            
sentence1 = [("the", "DT"),("fact", "NN")]            
# Pattern for chunk            
pattern = "NP: {<DT>?<JJ>*<NN>}"
patterns = """
NP: 
{<DT|PP\$>?<JJ>*<NN>}
{<NNP>+}
{<NN>+}
{<NNP>+<NN>}
"""

patterns_fr = """
NP: 
{<NOM><NOM>}
{<NAM><ADJ>}
{<NOM><ADJ>}
{<ADJ><NOM>}
{<NOM><PRP><NOM>}
"""

NPChunker= nltk.RegexpParser(patterns_fr) 

result = NPChunker.parse(txt) 
# parse the example sentence
print result 


reg_exp = '\(NP(.*?)\)'
p = re.compile(reg_exp)
p.findall(str(result))

result.draw()

NPChunker= nltk.RegexpParser(patterns) 
result = NPChunker.parse(sentence) 
# parse the example sentence
print result 
result.draw()


# Training models
from nltk.corpus import conll2000
import sys  

reload(sys)  
sys.setdefaultencoding('utf8')

# job_titles = [line.decode('utf-8').strip() for line in title_file.readlines()]

test_sents  = conll2000.chunked_sents('test.txt')
train_sents = conll2000.chunked_sents('train_old.txt')
type(train_sents)
#
class ChunkParser(nltk.ChunkParserI):
    def __init__(self, train_sents):
        train_data= [[(t,c) for w,t,c in nltk.chunk.tree2conlltags(sent)]for sent in train_sents]
        print(type(train_data))
        self.tagger= nltk.TrigramTagger(train_data)        
    def parse(self, sentence):
        pos_tags= [pos for (word,pos) in sentence]
        tagged_pos_tags= self.tagger.tag(pos_tags)
        chunktags= [chunktag for (pos, chunktag) in tagged_pos_tags]
        conlltags= [(word, pos, chunktag) for ((word,pos),chunktag)in zip(sentence, chunktags)]
        return nltk.chunk.conlltags2tree(conlltags)
#TEST Chunker
NPChunker = ChunkParser(train_sents)
sentence = [("the", "DT"), ("little", "JJ"), ("yellow", "JJ"), ("dog", "NN"), ("barked", 
            "VBD"), ("at", "IN"), ("the", "DT"), ("cat", "NN")]
            
sent = [("Battle-tested","JJ"),
("Japanese","JJ"),
("industrial","JJ"),
("managers","NNS"),
("here","RB"),
("always","RB"),
("buck","VBP"),
("up","RP"),
("nervous","JJ"),
("newcomers","NNS"),
("with","IN"),
("the","DT"),
("tale","NN"),
("of","IN"),
("the","DT"),
("first","JJ"),
("of","IN"),
("their","PP$"),
("countrymen","NNS"),
("to","TO"),
("visit","VB"),
("Mexico","NNP"),
(",",","),
("a","DT"),
("boatload","NN"),
("of","IN"),
("samurai","FW"),
("warriors","NNS"),
("blown","VBN"),
("ashore","RB"),
("375","CD"),
("years","NNS"),
("ago","RB"),
(".",".")]            
sentence1 = [("the", "DT"),("fact", "NN")]  
result = NPChunker.parse(sent)
print result
result.draw()

print NPChunker.evaluate(test_sents)


nltk.corpus.sinica_treebank.parsed_sents()[3451]