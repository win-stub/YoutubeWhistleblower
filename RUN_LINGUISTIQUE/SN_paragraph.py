# -*- coding: utf-8 -*-
"""
Created on Thu Jun 23 18:02:59 2016

@author: saber
"""
import sys

reload(sys)  
sys.setdefaultencoding('utf8')

def getPARAGRAPH(transcription,dict_total,seuil):

    # parcourirs all line
    all_txt = transcription.split('\n')   
    i=0
    tab_sent = []
    dict_sent ={}
    while (i < len(all_txt)):     
        
        if len(all_txt[i])!=0:           
            dict_sent[i]=all_txt[i]
            if i+1 < len(all_txt):        
                taille_line_1 = len(all_txt[i].split(' '))                  
                key = all_txt[i].split(' ')[taille_line_1-1]+'\t'+all_txt[i+1].split(' ')[0]
                if dict_total.has_key(key):
                    if dict_total[key]>seuil:                       
                        tab_sent.append(str(i)+'-'+str(i+1)+'-O')                    
                    else:                        
                        tab_sent.append(str(i)+'-'+str(i+1)+'-N')
                else:                    
                    tab_sent.append(str(i)+'-'+str(i+1)+'-N')
            #
            i=i+1
        else:
            i=i+1
    # restructuration de la transcription
    i=0
    is_group = False  
    tab_group=[]  
    new_sent = '' 
    #print(dict_sent)
    #print(tab_sent)
    while(i<len(tab_sent)):
        if i+1 < len(tab_sent):
            ite1 = tab_sent[i].split('-')[2]
            ite2 = tab_sent[i+1].split('-')[2]        
            if ite1==ite2=='O':
                tab_group.append(i) 
                tab_group.append(i+1)                                   
                #i=i+1
                is_group = True                    
            else:
                 if is_group==True:                                                          
                     tab_group = list(set(tab_group))                           
                     tab_group.sort()                                           
                     for n_sent in tab_group:
                         new_sent = new_sent + dict_sent[n_sent]+' '
                         #i=i+1
                     new_sent = new_sent +'\n**********new_sentence**********\n'
                     #print(new_sent)
                     tab_group=[]                 
                 else:
                     if ite1=='O':
                         #print('group o')
                         tab_group.append(i) 
                         tab_group.append(i+1)
                         new_sent = new_sent + dict_sent[i]+' '+dict_sent[i+1]+'\n**********new_sentence**********\n'
                         #new_sent = new_sent +'\n**********new_sentence**********\n'
                         #print(new_sent)
                         i=i+1
                     else:
                         #print('group non')
                         new_sent = new_sent+dict_sent[i]+'\n**********new_sentence**********\n'
                         #new_sent = new_sent +'\n**********new_sentence**********\n'
                         #print(new_sent)
                         
                 is_group = False                        
        i=i+1 
    new_sent = new_sent+dict_sent[i]+'\n**********new_sentence**********\n'
    return (new_sent)