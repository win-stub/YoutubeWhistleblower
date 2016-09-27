# -*- coding: utf-8 -*-
"""
Created on Mon Jun  6 13:57:16 2016

@author: saber
"""

import nltk
from nltk.chunk import *
import sys

reload(sys)  
sys.setdefaultencoding('utf8')

def getNG(txt,lang):
    # get word tag
    patterns='None'
    gn_return=''
    # anglais
    if lang=='en':
        patterns    = """
                      NP: 
                      {<NN|NP|NNS|NPS><NN|NP|NNS|NPS>}
                      {<NN|NP|NNS|NPS><JJ|JJR|JJS>}                      
                      {<JJ|JJR|JJS><NN|NP|NNS|NPS>}                      
                      {<NN|NP|NNS|NPS><IN><NN|NP|NNS|NPS>}
                      """
    # français
    if lang=='fr':
        patterns    = """
                      NP: 
                      {<NOM><NOM>}
                      {<NAM><NAM>}
                      {<NAM><ADJ>}
                      {<NOM><ADJ>}
                      {<ADJ><NOM>}
                      {<ADJ><NAM>}
                      {<NOM><PRP><NOM>}
                      {<NAM><PRP><NAM>}
                      """ 
    # chnoise
    if lang=='cn':
        patterns    = """
                      NP: 
                      {<n|nd|nr|ng|ns|nt|nh|ni|nl|nx|nz><n|nd|nr|ng|ns|nt|nh|ni|nl|nx|nz>}
                      {<n|nd|nr|ng|ns|nt|nh|ni|nl|nx|nz><a|ad|ag|an>}                     
                      {<a|ad|ag|an><n|nd|nr|ng|ns|nt|nh|ni|nl|nx|nz>}
                      {<n|nd|nr|ng|ns|nt|nh|ni|nl|nx|nz><p|pg><n|nd|nr|ng|ns|nt|nh|ni|nl|nx|nz>}
                      """                      
    # russe
    if lang=='ru':
        patterns    = """
                      NP: 
                      {<Nccpay|Nccpdy|Nccpgy|Nccpiy|Nccpny|Nccsay|Nccsdy|Nccsgy|Nccsiy|Nccsny|Ncfpan|Ncfpay|Ncfpdn|Ncfpdy|Ncfpgn|Ncfpgy|Ncfpin|Ncfpiy|Ncfpln|Ncfply|Ncfpnn|Ncfpny|Ncfsan|Ncfsay|Ncfsdn|Ncfsdy|Ncfsgn|Ncfsgy|Ncfsin|Ncfsiy|Ncfsln|Ncfsly|Ncfsnn|Ncfsnnl|Ncfsnnp|Ncfsny|Ncmpan|Ncmpay|Ncmpdn|Ncmpdy|Ncmpgn|Ncmpgy|Ncmpin|Ncmpiy|Ncmpln|Ncmply|Ncmpnn|Ncmpnnl|Ncmpny|Ncmsan|Ncmsay|Ncmsdn|Ncmsdy|Ncmsgn|Ncmsgy|Ncmsin|Ncmsiy|Ncmsln|Ncmsly|Ncmsnn|Ncmsnnl|Ncmsnnp|Ncmsny|Ncmsvy|Ncnpan|Ncnpay|Ncnpdn|Ncnpdy|Ncnpgn|Ncnpgy|Ncnpin|Ncnpiy|Ncnpln|Ncnply|Ncnpnn|Ncnpny|Ncnsan|Ncnsay|Ncnsdn|Ncnsgn|Ncnsgy|Ncnsin|Ncnsiy|Ncnsln|Ncnsnn|Ncnsny|Npcsgy|Npcsiy|Npcsny|Npfsay|Npfsdy|Npfsgy|Npfsiy|Npfsly|Npfsny|Npfsvy|Npmpay|Npmpgy|Npmpny|Npmsay|Npmsdy|Npmsgy|Npmsiy|Npmsly|Npmsny|Npmsvy|Npnsnn><Nccpay|Nccpdy|Nccpgy|Nccpiy|Nccpny|Nccsay|Nccsdy|Nccsgy|Nccsiy|Nccsny|Ncfpan|Ncfpay|Ncfpdn|Ncfpdy|Ncfpgn|Ncfpgy|Ncfpin|Ncfpiy|Ncfpln|Ncfply|Ncfpnn|Ncfpny|Ncfsan|Ncfsay|Ncfsdn|Ncfsdy|Ncfsgn|Ncfsgy|Ncfsin|Ncfsiy|Ncfsln|Ncfsly|Ncfsnn|Ncfsnnl|Ncfsnnp|Ncfsny|Ncmpan|Ncmpay|Ncmpdn|Ncmpdy|Ncmpgn|Ncmpgy|Ncmpin|Ncmpiy|Ncmpln|Ncmply|Ncmpnn|Ncmpnnl|Ncmpny|Ncmsan|Ncmsay|Ncmsdn|Ncmsdy|Ncmsgn|Ncmsgy|Ncmsin|Ncmsiy|Ncmsln|Ncmsly|Ncmsnn|Ncmsnnl|Ncmsnnp|Ncmsny|Ncmsvy|Ncnpan|Ncnpay|Ncnpdn|Ncnpdy|Ncnpgn|Ncnpgy|Ncnpin|Ncnpiy|Ncnpln|Ncnply|Ncnpnn|Ncnpny|Ncnsan|Ncnsay|Ncnsdn|Ncnsgn|Ncnsgy|Ncnsin|Ncnsiy|Ncnsln|Ncnsnn|Ncnsny|Npcsgy|Npcsiy|Npcsny|Npfsay|Npfsdy|Npfsgy|Npfsiy|Npfsly|Npfsny|Npfsvy|Npmpay|Npmpgy|Npmpny|Npmsay|Npmsdy|Npmsgy|Npmsiy|Npmsly|Npmsny|Npmsvy|Npnsnn>}                      
                      {<Nccpay|Nccpdy|Nccpgy|Nccpiy|Nccpny|Nccsay|Nccsdy|Nccsgy|Nccsiy|Nccsny|Ncfpan|Ncfpay|Ncfpdn|Ncfpdy|Ncfpgn|Ncfpgy|Ncfpin|Ncfpiy|Ncfpln|Ncfply|Ncfpnn|Ncfpny|Ncfsan|Ncfsay|Ncfsdn|Ncfsdy|Ncfsgn|Ncfsgy|Ncfsin|Ncfsiy|Ncfsln|Ncfsly|Ncfsnn|Ncfsnnl|Ncfsnnp|Ncfsny|Ncmpan|Ncmpay|Ncmpdn|Ncmpdy|Ncmpgn|Ncmpgy|Ncmpin|Ncmpiy|Ncmpln|Ncmply|Ncmpnn|Ncmpnnl|Ncmpny|Ncmsan|Ncmsay|Ncmsdn|Ncmsdy|Ncmsgn|Ncmsgy|Ncmsin|Ncmsiy|Ncmsln|Ncmsly|Ncmsnn|Ncmsnnl|Ncmsnnp|Ncmsny|Ncmsvy|Ncnpan|Ncnpay|Ncnpdn|Ncnpdy|Ncnpgn|Ncnpgy|Ncnpin|Ncnpiy|Ncnpln|Ncnply|Ncnpnn|Ncnpny|Ncnsan|Ncnsay|Ncnsdn|Ncnsgn|Ncnsgy|Ncnsin|Ncnsiy|Ncnsln|Ncnsnn|Ncnsny|Npcsgy|Npcsiy|Npcsny|Npfsay|Npfsdy|Npfsgy|Npfsiy|Npfsly|Npfsny|Npfsvy|Npmpay|Npmpgy|Npmpny|Npmsay|Npmsdy|Npmsgy|Npmsiy|Npmsly|Npmsny|Npmsvy|Npnsnn><Afcmsnf|Afpfpgf|Afpfsaf|Afpfsdf|Afpfsgf|Afpfsif|Afpfslf|Afpfsnf|Afpfsns|Afpmpaf|Afpmpdf|Afpmpgf|Afpmpif|Afpmplf|Afpmpnf|Afpmpns|Afpmsaf|Afpmsdf|Afpmsgf|Afpmsgs|Afpmsif|Afpmslf|Afpmsnf|Afpmsns|Afpnsaf|Afpnsdf|Afpnsgf|Afpnsif|Afpnslf|Afpnsnf|Afpnsns>}
                      {<Afcmsnf|Afpfpgf|Afpfsaf|Afpfsdf|Afpfsgf|Afpfsif|Afpfslf|Afpfsnf|Afpfsns|Afpmpaf|Afpmpdf|Afpmpgf|Afpmpif|Afpmplf|Afpmpnf|Afpmpns|Afpmsaf|Afpmsdf|Afpmsgf|Afpmsgs|Afpmsif|Afpmslf|Afpmsnf|Afpmsns|Afpnsaf|Afpnsdf|Afpnsgf|Afpnsif|Afpnslf|Afpnsnf|Afpnsns><Nccpay|Nccpdy|Nccpgy|Nccpiy|Nccpny|Nccsay|Nccsdy|Nccsgy|Nccsiy|Nccsny|Ncfpan|Ncfpay|Ncfpdn|Ncfpdy|Ncfpgn|Ncfpgy|Ncfpin|Ncfpiy|Ncfpln|Ncfply|Ncfpnn|Ncfpny|Ncfsan|Ncfsay|Ncfsdn|Ncfsdy|Ncfsgn|Ncfsgy|Ncfsin|Ncfsiy|Ncfsln|Ncfsly|Ncfsnn|Ncfsnnl|Ncfsnnp|Ncfsny|Ncmpan|Ncmpay|Ncmpdn|Ncmpdy|Ncmpgn|Ncmpgy|Ncmpin|Ncmpiy|Ncmpln|Ncmply|Ncmpnn|Ncmpnnl|Ncmpny|Ncmsan|Ncmsay|Ncmsdn|Ncmsdy|Ncmsgn|Ncmsgy|Ncmsin|Ncmsiy|Ncmsln|Ncmsly|Ncmsnn|Ncmsnnl|Ncmsnnp|Ncmsny|Ncmsvy|Ncnpan|Ncnpay|Ncnpdn|Ncnpdy|Ncnpgn|Ncnpgy|Ncnpin|Ncnpiy|Ncnpln|Ncnply|Ncnpnn|Ncnpny|Ncnsan|Ncnsay|Ncnsdn|Ncnsgn|Ncnsgy|Ncnsin|Ncnsiy|Ncnsln|Ncnsnn|Ncnsny|Npcsgy|Npcsiy|Npcsny|Npfsay|Npfsdy|Npfsgy|Npfsiy|Npfsly|Npfsny|Npfsvy|Npmpay|Npmpgy|Npmpny|Npmsay|Npmsdy|Npmsgy|Npmsiy|Npmsly|Npmsny|Npmsvy|Npnsnn>}                      
                      {<Nccpay|Nccpdy|Nccpgy|Nccpiy|Nccpny|Nccsay|Nccsdy|Nccsgy|Nccsiy|Nccsny|Ncfpan|Ncfpay|Ncfpdn|Ncfpdy|Ncfpgn|Ncfpgy|Ncfpin|Ncfpiy|Ncfpln|Ncfply|Ncfpnn|Ncfpny|Ncfsan|Ncfsay|Ncfsdn|Ncfsdy|Ncfsgn|Ncfsgy|Ncfsin|Ncfsiy|Ncfsln|Ncfsly|Ncfsnn|Ncfsnnl|Ncfsnnp|Ncfsny|Ncmpan|Ncmpay|Ncmpdn|Ncmpdy|Ncmpgn|Ncmpgy|Ncmpin|Ncmpiy|Ncmpln|Ncmply|Ncmpnn|Ncmpnnl|Ncmpny|Ncmsan|Ncmsay|Ncmsdn|Ncmsdy|Ncmsgn|Ncmsgy|Ncmsin|Ncmsiy|Ncmsln|Ncmsly|Ncmsnn|Ncmsnnl|Ncmsnnp|Ncmsny|Ncmsvy|Ncnpan|Ncnpay|Ncnpdn|Ncnpdy|Ncnpgn|Ncnpgy|Ncnpin|Ncnpiy|Ncnpln|Ncnply|Ncnpnn|Ncnpny|Ncnsan|Ncnsay|Ncnsdn|Ncnsgn|Ncnsgy|Ncnsin|Ncnsiy|Ncnsln|Ncnsnn|Ncnsny|Npcsgy|Npcsiy|Npcsny|Npfsay|Npfsdy|Npfsgy|Npfsiy|Npfsly|Npfsny|Npfsvy|Npmpay|Npmpgy|Npmpny|Npmsay|Npmsdy|Npmsgy|Npmsiy|Npmsly|Npmsny|Npmsvy|Npnsnn><Sp-a|Sp-d|Sp-g|Sp-i|Sp-l|Sp-n><Nccpay|Nccpdy|Nccpgy|Nccpiy|Nccpny|Nccsay|Nccsdy|Nccsgy|Nccsiy|Nccsny|Ncfpan|Ncfpay|Ncfpdn|Ncfpdy|Ncfpgn|Ncfpgy|Ncfpin|Ncfpiy|Ncfpln|Ncfply|Ncfpnn|Ncfpny|Ncfsan|Ncfsay|Ncfsdn|Ncfsdy|Ncfsgn|Ncfsgy|Ncfsin|Ncfsiy|Ncfsln|Ncfsly|Ncfsnn|Ncfsnnl|Ncfsnnp|Ncfsny|Ncmpan|Ncmpay|Ncmpdn|Ncmpdy|Ncmpgn|Ncmpgy|Ncmpin|Ncmpiy|Ncmpln|Ncmply|Ncmpnn|Ncmpnnl|Ncmpny|Ncmsan|Ncmsay|Ncmsdn|Ncmsdy|Ncmsgn|Ncmsgy|Ncmsin|Ncmsiy|Ncmsln|Ncmsly|Ncmsnn|Ncmsnnl|Ncmsnnp|Ncmsny|Ncmsvy|Ncnpan|Ncnpay|Ncnpdn|Ncnpdy|Ncnpgn|Ncnpgy|Ncnpin|Ncnpiy|Ncnpln|Ncnply|Ncnpnn|Ncnpny|Ncnsan|Ncnsay|Ncnsdn|Ncnsgn|Ncnsgy|Ncnsin|Ncnsiy|Ncnsln|Ncnsnn|Ncnsny|Npcsgy|Npcsiy|Npcsny|Npfsay|Npfsdy|Npfsgy|Npfsiy|Npfsly|Npfsny|Npfsvy|Npmpay|Npmpgy|Npmpny|Npmsay|Npmsdy|Npmsgy|Npmsiy|Npmsly|Npmsny|Npmsvy|Npnsnn>}
                      """ 
    # german
    if lang=='de':
        patterns    = """
                      NP: 
                      {<NE|NN><NE|NN>}                     
                      {<NE|NN><ADJA|ADJD>}                      
                      {<ADJA|ADJD><NE|NN>}                                            
                      {<NE|NN><APPO|APPR|APPRART|APZR><NE|NN>}
                      """   
    # arabic
    if lang=='ar':
        patterns    = """
                      NP: 
                      {<NNP|NNPS|NN|NNS><NNP|NNPS|NN|NNS>}
                      {<NNP|NNPS|NN|NNS><JJ>}                      
                      {<JJ><NNP|NNPS|NN|NNS>}
                      {<NNP|NNPS|NN|NNS><IN|CC><NNP|NNPS|NN|NNS>}
                      """                       
    #
    if patterns!='None':
        txt = txt.decode("utf8").split('\n')
        tab_word = []
        for line in txt:        
            if len(line)!=0:
                tab_word.append((line.split('\t')[1],line.split('\t')[4]))                                    
        # recuperation des groupes nominaux
        #print(tab_word)
        #reg_exp = '\(NP(.*?)\)'
        #p = re.compile(reg_exp)        
        #
        NPChunker= nltk.RegexpParser(patterns) 
        result = NPChunker.parse(tab_word)                
        #for x in p.findall(str(result)):
        #    x = unicode(x,'utf8')
        #    print(x.encode("utf-8"))        
        #gn_return = "\n".join(x.strip() for x in p.findall(str(result)))        
        for a in result:                        
            if type(a[0]) == type(('','')):  
                if len(a)==3:
                    gn_return = gn_return +a[0][0]+'/'+a[0][1]+'\t'+a[1][0]+'/'+a[1][1]+'\t'+a[2][0]+'/'+a[2][1]+'\n'
                else:
                    gn_return = gn_return +a[0][0]+'/'+a[0][1]+'\t'+a[1][0]+'/'+a[1][1]+'\n'
    return (gn_return.strip())
        
            