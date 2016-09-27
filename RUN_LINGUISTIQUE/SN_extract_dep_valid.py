# -*- coding: utf-8 -*-
"""
Created on Wed Jun  1 18:47:58 2016

@author: saber
"""
import sys

reload(sys)  
sys.setdefaultencoding('utf8')

def getDEPS(txt,list_rel):
    #
    txt = txt.decode("utf8").split('\n')
    # rel_list =['amod','nmod','compound','name']
    # les tables src dest rel
    tab_src  =[]   
    tab_dest =[]
    tab_rel  =[]
    tab_word =[]
    all_extract  =[]
    tab_tmp=[]
    all_return=''
    #
    for line in txt:        
        if len(line)!=0:
            tab_word.append(line.split('\t')[1]) 
            if line.split('\t')[7] in list_rel:
                tab_src.append(line.split('\t')[6])
                tab_dest.append(line.split('\t')[0])
                tab_rel.append(line.split('\t')[7])
                #print(line.split('\t')[6]+'\t'+line.split('\t')[0])
        else:
            #print('line vide')
            #print(tab_src)
            #print(tab_dest)
            #
            for i in range(len(tab_src)):
                # assigne src dest et rel
                src  = tab_src[i]
                dest = tab_dest[i]
                rel  = tab_rel[i]
                # lancer la fonction recursive                
                getLINKS(tab_word,tab_src,tab_dest,tab_rel,list_rel,src,dest,rel,tab_tmp)
            # add relation to vector
            #liste_sans = set(tmp_src_dest)
            #liste_sans = list(liste_sans)
            #liste_sans.sort()
            #
            #word_comp = ''
            #for val in liste_sans:
            #    word_comp = word_comp + tab_word[int(val)-1]+'\t'
            # add the word extracted in the new list and return
                #print('src ------------------------------------------ '+src)                
                all_extract.append(tab_tmp) 
                tab_tmp=[]
            #
            str_tmp = getWORDS(all_extract,tab_word)
            all_return = all_return+str_tmp+"\n"
            # mettre les variables à zero
            tab_src      =[]   
            tab_dest     =[]
            tab_rel      =[]
            tab_word     =[]
            all_extract  =[]            
            #                
    return (all_return)
###############################################################################
#print(len(tab_src)) 
def getLINKS(tab_word,tab_src,tab_dest,tab_rel,list_rel,src,dest,rel,tab_tmp):
    # test si la relation est dans la liste et le dest aussi   
    #
    if dest in tab_src:
        src_tmp  = dest        
        for i_src in range(len(tab_src)):                        
            if tab_src[i_src]==src_tmp:  
                dest_tmp = tab_dest[i_src]
                rel_tmp  = tab_rel[i_src]                 
                #print(src+' ---> '+dest) 
                tab_tmp.append((src+'--->'+dest))
                #tmp.append(src+' ---> '+dest+' ---> '+str(nb_ch))
                getLINKS(tab_word,tab_src,tab_dest,tab_rel,list_rel,src_tmp,dest_tmp,rel_tmp,tab_tmp)                                             
    else:        
        #print('--------------------------------------------------------------') 
        #tmp.append(src+' ---> '+dest+' ---> '+str(nb_ch)) 
        #print(src+' ---> '+dest)
        #group_str = group_str+''+src+' ---> '+dest+'\t'
        tab_tmp.append((src+'--->'+dest))
        tab_tmp.append('group')
        #print('extracted')            
        #group_str = group_str+''+'extracted'
        #print('--------------------------------------------------------------') 
    return (tab_tmp)

def getWORDS(all_groups,all_words):
    #
    str_glo_return=''
    #
    for gr in all_groups:
        str_gr = "--->".join(x.strip() for x in gr)    
        tab_groups = str_gr.split('--->')
        i=0
        group_tmp = []
        while i < len(tab_groups):        
            if tab_groups[i]!='group':
                if i+1<len(tab_groups):
                    src  = tab_groups[i] 
                    dest = tab_groups[i+1] 
                    if src==dest:
                        #group_tmp.append(tab_groups[i])
                        i=i+1
                    else:
                        group_tmp.append(tab_groups[i])
                        i=i+1
                else:
                    i=i+1
            else:                                 
                str_return     = "\t".join(all_words[int(x)-1] for x in group_tmp)
                str_glo_return = str_glo_return+str_return+"\n" 
                str_return=''
                group_tmp = []
                i=i+1
    return(str_glo_return)



















        