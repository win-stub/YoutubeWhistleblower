# -*- coding: utf-8 -*-
"""
Created on Wed Jun  1 18:47:58 2016

@author: saber
"""
import sys

reload(sys)  
sys.setdefaultencoding('utf8')


def getDEPS(txt,list_rel_pricipal,list_rel_secondaire):            
    txt        = txt.decode("utf8").split('\n')
    tab_tmp    = []
    tab_global = []
    tab_word   = []
    # All returns
    all_returns_groups = ''
    for line in txt:
        if len(line)!=0:
            tab_tmp.append(line.split('\t')[0]+'\t'+line.split('\t')[6]+'\t'+line.split('\t')[7]) 
            tab_word.append(line.split('\t')[1]+'\t'+line.split('\t')[4])
        else:
            i=0
            is_group = False
            rel_name = 'None'
            tab_tmp_group_pri = []
            tab_tmp_group_sec = []
            while(i<len(tab_tmp)):            
                if i+1 <len(tab_tmp):
                    # recuperation des relation n et n+1
                    ite1 = tab_tmp[i].split('\t')[2]
                    ite2 = tab_tmp[i+1].split('\t')[2]                    
                    #
                    if ite1 in list_rel_secondaire:                        
                        tab_tmp_group_sec.append(tab_tmp[i].split('\t')[1]+'\t'+tab_tmp[i].split('\t')[0]+'\t'+tab_tmp[i].split('\t')[2])                                        
                    #
                    if ite1==ite2 and ite1 in list_rel_pricipal and ite2 in list_rel_pricipal:        
                        rel_name = tab_tmp[i].split('\t')[2]                                 
                        tab_tmp_group_pri.append(int(tab_tmp[i].split('\t')[0])) 
                        tab_tmp_group_pri.append(int(tab_tmp[i].split('\t')[1]))
                        i=i+1
                        is_group = True                    
                    else:
                        if is_group==True and ite1 in list_rel_pricipal and ite2 in list_rel_pricipal: 
                            rel_name = tab_tmp[i].split('\t')[2]
                            tab_tmp_group_pri.append(int(tab_tmp[i].split('\t')[0])) 
                            tab_tmp_group_pri.append(int(tab_tmp[i].split('\t')[1]))                      
                        else:
                            if tab_tmp[i].split('\t')[2] in list_rel_pricipal:   
                                rel_name = tab_tmp[i].split('\t')[2]
                                tab_tmp_group_pri.append(int(tab_tmp[i].split('\t')[0])) 
                                tab_tmp_group_pri.append(int(tab_tmp[i].split('\t')[1]))
                                               
                        if len(tab_tmp_group_pri)!=0:
                            tab_tmp_group_pri = list(set(tab_tmp_group_pri))                           
                            tab_tmp_group_pri.sort()                          
                            tab_global.append([rel_name,tab_tmp_group_pri])
                        # initialisation des paramettres
                        i=i+1 
                        tab_tmp_group_pri = []
                        #tab_tmp_group_sec = []
                        is_group = False
                        rel_name = 'None'                        
                else:
                    i=i+1
            #
            # les list secondaires 
            #print(tab_global)                                
            for tab_groups in tab_global:
                ##print()
                all_returns_groups = all_returns_groups+tab_groups[0]+':'+"_".join(tab_word[int(x)-1].split('\t')[0] for x in tab_groups[1])+'\n'
            #            
            #print(tab_tmp_group_sec)        
            for tab_anmod in tab_tmp_group_sec:
                src  = int(tab_anmod.split('\t')[0])
                dest = int(tab_anmod.split('\t')[1])
                rel  = tab_anmod.split('\t')[2]
                # 
                if src>dest:
                    dest  = int(tab_anmod.split('\t')[0])
                    src   = int(tab_anmod.split('\t')[1])                    
                #                              
                tab_src  =[]
                tab_dest =[]                                           
                for tab_groups in tab_global: 
                    ########################                                            
                    if src in tab_groups[1]:                       
                        tab_src.append(tab_groups[0]+':'+"_".join(tab_word[int(x)-1].split('\t')[0] for x in tab_groups[1]))
                    if dest in tab_groups[1]:                        
                        tab_dest.append(tab_groups[0]+':'+"_".join(tab_word[int(x)-1].split('\t')[0] for x in tab_groups[1]))                       
                    ########################                 
                # src
                if len(tab_src)==0:
                    tab_src.append(tab_word[src-1].split('\t')[0])
                # dest
                if len(tab_dest)==0:
                    tab_dest.append(tab_word[dest-1].split('\t')[0])
                # les relations results                    
                for src_result in tab_src:
                    for dest_result in tab_dest:
                        #print(rel+':'+src_result+'_'+dest_result)
                        all_returns_groups = all_returns_groups+rel+':'+src_result+'_'+dest_result+'\n'
                #                        
                tab_src  =[]
                tab_dest =[]                       
            # initialiser la liste    
            tab_tmp=[]    
            tab_word = []            
            tab_global=[]
            tab_tmp_group_sec = []
    return (all_returns_groups)    