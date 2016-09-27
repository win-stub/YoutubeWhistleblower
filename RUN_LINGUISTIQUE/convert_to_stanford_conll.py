# -*- coding: utf-8 -*-
"""
Created on Thu Jun  2 16:15:57 2016

@author: saber
"""
import sys

reload(sys)  
sys.setdefaultencoding('utf8')

input_conll   = '/home/saber/DA_Stage/stanford/train_fr/fr_wiki.conll'#sys.argv[1]

file_input  = open(input_conll,"r")
txt   = file_input.read()
texte = txt.decode("utf8")
nb_sent=1
for line in texte.split('\n'):
    if (len(line)==0):
        #line_tmp = line.split(' ')                        
        #for tag in line_tmp:
        #    tag_tmp = tag.split('|')
        #    if len(tag_tmp)==3:
        #        print(tag_tmp[0]+'\t'+tag_tmp[2]) 
        #    #print(len(tag_tmp))               
        nb_sent=nb_sent+1
    #print('')
print(nb_sent)        