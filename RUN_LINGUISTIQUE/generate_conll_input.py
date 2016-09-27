# -*- coding: utf-8 -*-
"""
Created on Tue May 17 13:27:28 2016

@author: saber
"""

import sys
import treetagger_test
import subprocess as sub
from TAG_SEG_ARA import *

reload(sys)  
sys.setdefaultencoding('utf8')
#
#
treetagger_languages       = sys.argv[1]
path_to_treetagger         = sys.argv[2]  # path to treetagger"/home/saber/DA_Stage/treetagger/cmd"
path_to_morphtagger        = sys.argv[3]  # path to morphtagger for arabic language"/home/saber/DA_Stage/Stage/nltk/MorphTaggerArabe"
path_to_abbreviations      = sys.argv[4]  #"/home/saber/DA_Stage/treetagger/lib/french-abbreviations"#
lang                       = sys.argv[5]  #"en"#
lang_treetagger            = sys.argv[6]  #"english"
list_lang                  = sys.argv[7]  #"en,fr,ru,cn,de"
texte                      = sys.argv[8]

# la langue arabe
file_ara                   = sys.argv[9]   # le fichier qui contient le texte en arabe
folder_ara                 = sys.argv[10]  # le dossier de morphtagger pour le texte en arabe
script_ara                 = sys.argv[11]  # le script pour morphtagger en arabe
#
#file_input  = open("/home/saber/test.txt","r")
#txt         = file_input.read()
#texte       = txt.decode("utf8")
#
treetagger_languages = {
u'latin-1':['latin', 'latinIT', 'mongolian', 'swahili'],
u'utf-8' : ['bulgarian', 'dutch', 'english', 'estonian', 'finnish', 'french', 
            'galician', 'german', 'italian', 'polish', 'russian', 'slovak', 
            'slovak2', 'spanish','chinese']}
# parametres d'entree
list_lang = list_lang.split(',')
#sent = getSents(texte,lang,list_lang)
#sent  = texte.split('\n')
# Parcourir la phrase en question
if lang!='ar':
    if lang=='cn':
        texte_cn = texte.replace('**********new_sentence**********','00000000000000000000000000000000')
        tags = treetagger_test.getTAGS(treetagger_languages ,
                                       path_to_treetagger   ,
                                       None                 ,
                                       texte_cn.strip()     ,
                                       lang_treetagger) 
        if tags=='None':
            print("1"+'\t'+"None"+'\t'+"None"+'\t'+'_'+'\t'+"None"+'\t'+'_')
        else:
            # generate format conll pour generer tree dependency de 6 columns
            ID=1
            for tag in tags:
                if tag[0] == '00000000000000000000000000000000':
                    ID=1
                    print('')
                else:                
                    # ID FORM LEMMA CPOSTAG POS FEATS
                    print(str(ID)+'\t'+tag[0]+'\t'+tag[2]+'\t'+'_'+'\t'+tag[1]+'\t'+'_')
                    ID+=1    
            print('')
    else:
        tags = treetagger_test.getTAGS(treetagger_languages ,
                                       path_to_treetagger   ,
                                       None                 ,
                                       texte.strip()        ,
                                       lang_treetagger) 
        if tags=='None':
            print("1"+'\t'+"None"+'\t'+"None"+'\t'+'_'+'\t'+"None"+'\t'+'_')
        else:
            # generate format conll pour generer tree dependency de 6 columns
            ID=1
            for tag in tags:
                if tag[0] == '**********new_sentence**********':
                    ID=1
                    print('')
                else:                
                    # ID FORM LEMMA CPOSTAG POS FEATS
                    print(str(ID)+'\t'+tag[0]+'\t'+tag[2]+'\t'+'_'+'\t'+tag[1]+'\t'+'_')
                    ID+=1    
            print('')        
        # save conll format
else:    
    sent = texte.strip().split('**********new_sentence**********') 
    for s in sent:
        if len(s)!=0:            
            p = sub.Popen([script_ara               ,#'./generate_tag_ara.sh'  ,
                           path_to_morphtagger      ,
                           path_to_morphtagger      ,
                           str(s.strip())]          ,
                           stdout=sub.PIPE,stderr=sub.PIPE)
            # recuperation des resulats pour morphtagger 
            output, errors = p.communicate()
            #print(output)
            #print(error)
            #result_tag = getTAGS_LIST(path_to_morphtagger+'/'+folder_ara+'/'+file_ara+'.txt.bama.format.tagging')
            #result_seg = getSEG_LIST (path_to_morphtagger+'/'+folder_ara+'/'+file_ara+'.txt.seg') 
            result_tag,result_seg =getSEG_TAG(path_to_morphtagger+'/'+folder_ara+'/'+file_ara+'.txt.bama.format.tagging',path_to_morphtagger+'/'+folder_ara+'/'+file_ara+'.txt.seg')                                                 
            if len(result_tag)==0:
                print("1"+'\t'+"None"+'\t'+"None"+'\t'+'_'+'\t'+"None"+'\t'+'_')
            else:               
                for tag_tmp in range(len(result_tag)):
                    # generate format conll pour generer tree dependency de 6 columns
                    ID=1                     
                    for tag in range(len(result_tag[tag_tmp])):                    
                        # ID FORM LEMMA CPOSTAG POS FEATS
                        print(str(ID)+'\t'+result_seg[tag_tmp][tag]+'\t'+'_'+'\t'+'_'+'\t'+result_tag[tag_tmp][tag]+'\t'+'_')
                        ID+=1    
                    print('')        
            # save conll format                
    