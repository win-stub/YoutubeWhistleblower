# -*- coding: utf-8 -*-
"""
Created on Thu May 26 15:33:12 2016

@author: saber
"""

# -*- coding: utf-8 -*-
"""
Created on Sun Apr 24 00:05:23 2016

@author: saber
"""

import sys
import SN_Lang as sn_lang

reload(sys)  
sys.setdefaultencoding('utf8')
# path to maltparser and model maltparser   
script_sell           = "./generate_conll.sh" #sys.argv[1]
input_conll           = 'input_conll1.conll'   #sys.argv[2]
output_conll          = 'output_conll1.conll'   #sys.argv[3]

path_to_maltparser   = 'maltparser-1.8.1.jar'#sys.argv[3]

#
path_to_morphtagger   = '/projets/musk/Youtube/ling_youtube/nltk/MorphTaggerArabe'
path_to_treetagger    = '/projets/musk/Youtube/ling_youtube/treetagger/cmd'
path_to_abbreviations = '/projets/musk/Youtube/ling_youtube/treetagger/lib/french-abbreviations'
path_to_stanford      = '/projets/musk/Youtube/ling_youtube/stanford_ner/'
path_to_java          = '/logiciels/java1.8/bin/java'
#
dict_lang ={
'ar':'arabic'  ,
'fr':'french'  ,
'en':'english' ,
'it':'italian' ,
'cs':'czech'   ,
'da':'danish'  ,
'de':'german'  ,
'el':'greek'   ,
'es':'spanish' ,
'fi':'finnish' ,
'pl':'polish'  ,
'ru':'russian'
}
# dictionnaire model
dict_model_maltparser ={
'fr':'french1.3',
'ar':'arabic1.3',
'en':'english1.3'
}
# dictionnaire model
dict_model_stanford ={
'en':'english3.ser.gz',
'de':'german1.ser.gz' ,
'cn':'chinese.ser.gz' ,
'jar':'stanford-ner-3.6.0.jar'
}
# relation list between word
rel_list =[['compound','name','list'],['amod','nmod']]
#rel_list =[['amod'],['nmod']]
#list lang
#,'zh-cn'
list_lang        = "en,fr,ar,ru,cn,de"
# "ling_cal":"false" "_id":"gF2kl7K-sP0" or "hBaqdp8_6_U"
ch1='Les communes limitrophes de Paris sont très pauvres.'
ch2='ألمانيا و الهند تطمحان لزيادة تجارتهما.\n**********new_sentence**********'
ch3='أكتبها من فضلك'
ch4='The fate of Lehman Brothers, the beleaguered investment bank, hung in the balance on Sunday as Federal Reserve officials and the leaders of major financial institutions continued to gather in emergency meetings trying to complete a plan to rescue the stricken bank.  Several possible plans emerged from the talks, held at the Federal Reserve Bank of New York and led by Timothy R. Geithner, the president of the New York Fed, and Treasury Secretary Henry M. Paulson Jr.'
ch5='''
The Coinage Act of 1873 declared that US dollar coins struck from silver bullion were no longer considered legal tender, thus placing the nation firmly on the gold 
standard and ending bimetallism.
'''
ch6='''
الجزائر (أمازيغية: ⵍⵣⵣⴰⵢⴻⵔ دزاير) هو أكبر بلد أفريقي وعربي من حيث المساحة، والعاشر عالميا. والاسم الرسمي للجزائر هو الجمهورية الجزائرية الديمقراطية الشعبية. تقع الجزائر في شمال غرب القارة الأفريقية، تطل شمالا على البحر الأبيض المتوسط ويحدها من الشّرق تونس وليبيا ومن الجنوب مالي والنيجر ومن الغرب المغرب و الصحراء الغربية وموريتانيا.
'''
ch7='''
Big Pharmaceutical Executive Turns Whistle blower. Dr. John Rengen Virapen.
'''
ch8='''
Le premier brevet (intitulé Method for Node Ranking in a Linked Database)4, déposé en janvier 1997 et enregistré le 9 janvier 1998, est la propriété de l'Université Stanford5, qui a octroyé la licence de cette technologie à Google en 1998 (amendée en 2000 et 2003), deux mois après sa fondation. Il s'agit d'une licence exclusive jusqu'en 2011, l'exclusivité prenant fin à cette date6.

Les recherches qui ont abouti au développement de la technologie du PageRank ont été financées en partie par la National Science Foundation7. Il est donc précisé dans le brevet que le gouvernement a certains droits sur cette invention8.

Le Théorèmes de point fixe est le concept mathématique qui a permis l'invention du PageRank. Celui-ci permet en effet d'assurer que le calcul du PageRank est possible.
'''
doc_meta    = sn_lang.getLingMeta(
                                  script_sell           ,
                                  unicode(ch2,'utf-8')  ,                             
                                  input_conll           ,
                                  output_conll          ,
                                  path_to_maltparser    ,
                                  dict_model_maltparser ,
                                  dict_model_stanford   ,
                                  path_to_treetagger    ,
                                  path_to_morphtagger   ,
                                  path_to_stanford      ,
                                  ""          ,
                                  path_to_abbreviations ,
                                  dict_lang             ,
                                  list_lang             ,
                                  'ar'                  ,
                                  rel_list)
print(doc_meta.get('meta_NER'))
print(doc_meta.get('meta_REL'))
print(doc_meta.get('meta_DEPS'))
#print(doc_title.get('meta_DEPS'))
