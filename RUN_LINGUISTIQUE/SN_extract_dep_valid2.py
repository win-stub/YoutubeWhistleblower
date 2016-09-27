# -*- coding: utf-8 -*-
"""
Created on Wed Jun  1 18:47:58 2016

@author: saber
"""
import sys

reload(sys)  
sys.setdefaultencoding('utf8')

def getALL(txt,list_name,list_compound,list_nmod,list_amod):
    #
    pass
    #

def getDEPS(txt,list_rel):
    #
    txt = txt.decode("utf8").split('\n')
    # rel_list =['amod','nmod','compound','name']
    # les tables src dest rel
    tab_src  =[]   
    tab_dest =[]
    tab_rel  =[]
    tab_src_nmod  =[]   
    tab_dest_nmod =[]
    tab_rel_nmod  =[]    
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
            else:
                if (line.split('\t')[7]=='nmod') and ('nmod' not in list_rel):
                    tab_src_nmod.append(line.split('\t')[6])
                    tab_dest_nmod.append(line.split('\t')[0])
                    tab_rel_nmod.append(line.split('\t')[7])                    
                #print(line.split('\t')[6]+'\t'+line.split('\t')[0])
        else:            
            #
            for i in range(len(tab_src)):
                # assigne src dest et rel
                src  = tab_src[i]
                dest = tab_dest[i]
                rel  = tab_rel[i]
                #print(src+'   '+dest+'   '+rel)
                # lancer la fonction recursive                
                getLINKS(tab_word,tab_src,tab_dest,tab_rel,list_rel,src,dest,rel,tab_tmp) 
                # add relation to vector                
                all_extract.append(tab_tmp)                 
                tab_tmp=[]                           
            #
            str_tmp,dict_groups       = getWORDS(all_extract,tab_word,list_rel)    
            all_return = all_return+str_tmp
            #
            str_tmp_nmod=''
            for i in range(len(tab_dest_nmod)):
                for key in dict_groups.keys():
                    tab = dict_groups[key]                    
                    if int(tab_dest_nmod[i]) in tab:
                        str_tmp_nmod1 = 'nmod:'+tab_word[int(tab_src_nmod[i])-1]+'_'+key
                        str_tmp_nmod = str_tmp_nmod+str_tmp_nmod1+"\n"
            # 
            all_return = all_return+str_tmp_nmod+"\n"
            # mettre les variables à zero
            tab_src      =[]   
            tab_dest     =[]
            tab_rel      =[]
            tab_src_nmod  =[]   
            tab_dest_nmod =[]
            tab_rel_nmod  =[]            
            tab_word      =[]
            all_extract   =[]            
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
                #print(src+' ---> '+dest+' ---> '+rel) 
                tab_tmp.append((src+' ---> '+dest+' ---> '+rel))
                #tmp.append(src+' ---> '+dest+' ---> '+str(nb_ch))
                getLINKS(tab_word,tab_src,tab_dest,tab_rel,list_rel,src_tmp,dest_tmp,rel_tmp,tab_tmp)                                             
    else:        
        #print('--------------------------------------------------------------') 
        #tmp.append(src+' ---> '+dest+' ---> '+str(nb_ch)) 
        #print(src+' ---> '+dest+' ---> '+rel)
        #print('group')         
        #group_str = group_str+''+src+' ---> '+dest+'\t'        
        tab_tmp.append((src+' ---> '+dest+' ---> '+rel))
        tab_tmp.append('group')           
        #group_str = group_str+''+'extracted'
        #print('--------------------------------------------------------------') 
    return (tab_tmp)

def getWORDS(all_groups,all_words,rel_list):
    #
    str_glo_return = ''
    dict_groups    = {}
    #
    for gr in all_groups:
        str_gr = "--->".join(x.strip() for x in gr)    
        tab_groups = str_gr.split('--->')
        i=0
        group_tmp = []        
        while i < len(tab_groups):        
            if tab_groups[i]!='group':
                if tab_groups[i].strip().isdigit():
                    group_tmp.append(int(tab_groups[i].strip()))
                #else:
                #    print('type relation : '+tab_groups[i].strip())
                i=i+1
            else:                     
                group_tmp = list(set(group_tmp))                
                group_tmp.sort()                               
                str_return     = "_".join(all_words[x-1] for x in group_tmp)
                str_return     = rel_list[0]+':'+str_return
                #
                dict_groups[str_return] = group_tmp
                #
                str_glo_return = str_glo_return+str_return+"\n" 
                str_return=''
                group_tmp = []
                i=i+1
    return(str_glo_return,dict_groups)




        