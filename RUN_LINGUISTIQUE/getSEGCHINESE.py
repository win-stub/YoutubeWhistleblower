# -*- coding: utf-8 -*-
"""
Created on Thu May 19 11:47:30 2016

@author: saber
"""
import sys
from polyglot.text import Text
import treetagger_test

reload(sys)  
sys.setdefaultencoding('utf8')

path_to_treetagger    = '/home/saber/DA_Stage/treetagger/cmd'
#
dict_lang ={
'cn':'chinese'
}

treetagger_languages = {
u'latin-1':['latin', 'latinIT', 'mongolian', 'swahili'],
u'utf-8' : ['bulgarian', 'dutch', 'english', 'estonian', 'finnish', 'french', 
            'galician', 'german', 'italian', 'polish', 'russian', 'slovak', 
            'slovak2', 'spanish','chinese']}
            
list_lang        = "en,fr,it,cs,da,de,el,es,fi,hu,ko,nl,no,pl,pt,ru,sk,sv,tr,cn"

txt_cn = unicode("两个月前遭受恐怖袭击的法", 'utf-8')
txt_cn = unicode("欧文现在效力于利物浦队。", 'utf-8')
text = Text(txt_cn)


tags = treetagger_test.getTAGS(treetagger_languages ,
                               path_to_treetagger   ,
                               None                 ,
                               txt_cn.strip()       ,
                               'chinese')
ID=1                               
for tag in tags:
    print(str(ID)+'\t'+tag[0]+'\t'+'_'+'\t'+'_'+'\t'+tag[1]+'\t'+'_')  
    ID=ID+1

txt_fr = unicode("Le petit garçon parle à Marie.", 'utf-8')
text = Text(txt_fr)
tags = treetagger_test.getTAGS(treetagger_languages ,
                               path_to_treetagger   ,
                               None                 ,
                               txt_fr.strip()       ,
                               'french')

ID=1                               
for tag in tags:
    print(str(ID)+'\t'+tag[0]+'\t'+tag[2]+'\t'+'_'+'\t'+tag[1]+'\t'+'_')  
    ID=ID+1
                            

txt = unicode('[(NN myrAv)][(IN b)][(CD 300)][(NN >lf)][(NN dwlAr)][(VBP yqlb)][(NN HyAp)][(JJ mt$rd)][(JJ >myrky)]','utf-8')    
txt = unicode('[(CC w)][(VBD kAnt)][(NN wkAlp)][(NN Al>nbA'')][(JJ AlErAqyp)][(VBD >Elnt)][(CC >n)][(NN mjmwEp)][(NN mnZmp)][(PUNC ")][(NN >SwAt)][(IN fy)][(NN Albryp)][(PUNC ")][(VBP tDm)][(NN stp)][(NN >$xAS)][(IN byn)(PRP hm)][(NN vlAv)][(NN nsA'')][(PUNC ,)][(RP gyr)][(CC >n)][(NN r}ysp)(PRPS hA)][(NNP kyty)][(NNP kyly)][(VBD >wDHt)][(IN l)(NN wkAlp)][(NNP frAns)][(NNP brs)][(CC >n)][(NN AlEDw)][(JJ AlsAds)][(VBP synDm)][(JJ lAHqA)][(IN <lY)][(NN AlmjmwEp)][(WP Alty)][(VBP tEtnq)][(NN Eqydp)][(NNP gAndy)][(IN fy)][(NN AllAEnf)][(CC w)][(NN AlESyAn)][(JJ Almdny)][(PUNC .)]','utf-8')    

txt = unicode('[_CC_] [_VBD_] [_NN_] [_NN_] [_JJ_] [_VBD_] [_CC_] [_NN_] [_NN_] [_PUNC_] [_NN_] [_IN_] [_NN_] [_PUNC_] [_VBP_] [_NN_] [_NN_] [_IN__PRP_] [_NN_] [_NN_] [_PUNC_] [_RP_] [_CC_] [_NN__PRPS_] [_NNP_] [_NNP_] [_VBD_] [_IN__NN_] [_NNP_] [_NNP_] [_CC_] [_NN_] [_JJ_] [_VBP_] [_JJ_] [_IN_] [_NN_] [_WP_] [_VBP_] [_NN_] [_NNP_] [_IN_] [_NN_] [_CC_] [_NN_] [_JJ_] [_PUNC_]','utf-8')
tokens = txt.split(' ')
print(len(tokens))
for word in tokens:
    print(word)