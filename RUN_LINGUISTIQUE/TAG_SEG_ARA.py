# -*- coding: utf-8 -*-
"""
Created on Mon May 23 12:41:39 2016

@author: saber
"""
import sys
import re

reload(sys)  
sys.setdefaultencoding('utf8')

# get tags and seg
def getSEG_TAG(file_name_tag,file_name_seg):
    input_tag = open(file_name_tag) 
    input_seg = open(file_name_seg) 
    #
    txt_tag = input_tag.read()
    txt_seg = input_seg.read()
    # encodage en UTF-8
    texte_tag = txt_tag.decode("utf8").split('\n')
    texte_seg = txt_seg.decode("utf8").split('\n')
    
    #print(len(texte_tag))
    #print(len(texte_seg))
    
    # les expressions regulieres
    reg_exp = '\[\_(.*?)\_\]'
    p = re.compile(reg_exp)
    # parcourir les tag et seg
    all_tag=[]
    all_seg=[]
    for i in range(len(texte_tag)):    
        if texte_tag[i]!='' and texte_seg[i]!='@emptyline@':
            list_tag = getTAGS_LIST(texte_tag[i])
            list_seg = getSEG_LIST(texte_seg[i])
            all_tag.append(list_tag)
            all_seg.append(list_seg)
            
        #else:
            #all_tag.append('')
            #all_seg.append('')
    return all_tag,all_seg
# fonction pour adapter les tags generer par MorphTagger
def getTAGS_LIST(file_name_tag):
    reg_exp = '\[\_(.*?)\_\]'
    p = re.compile(reg_exp)
    #input_tag = open(file_name_tag)
    txt_tag =file_name_tag#input_tag.read()
    # encodage en UTF-8
    texte_tag = p.findall(txt_tag)
    list_tags=[]
    for tag in texte_tag:
        result_tmp = tag.split('__')
        for new_tag in result_tmp:
            list_tags.append(new_tag.strip())
    return list_tags
# fonction pour adapter les tags generer par MorphTagger
def getSEG_LIST(file_name_seg):
    #input_seg = open(file_name_seg)
    txt_seg =file_name_seg #input_seg.read() 
    # encodage en UTF-8
    texte_seg = txt_seg.decode("utf8").split(' ')  
    list_segs=[]
    for seg in texte_seg:       
        list_segs.append(seg.strip())    
    return list_segs 
#testtesttestest
#list_tmp = getSEG_LIST('test.conll.seg')    
#for tmp in list_tmp:
#    print(tmp)
#print(len(list_tmp))    

#list_tmp = getTAGS_LIST('test.conll.bama.format.tagging')    
#for tmp in list_tmp:
#    print(tmp)
#print(len(list_tmp)) 