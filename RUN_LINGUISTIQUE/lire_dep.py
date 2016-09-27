# -*- coding: utf-8 -*-
"""
Created on Tue May 17 16:19:52 2016

@author: saber
"""

import sys
import os

reload(sys)  
sys.setdefaultencoding('utf8')
#
input_conll          = sys.argv[1]
output_conll         = sys.argv[2]
path_to_model        = sys.argv[3]
path_to_maltparser   = sys.argv[4]
# Appliquer le MaltParser
os.system("sh generate_conll.sh "+input_conll+" "+output_conll+" "+path_to_model+" "+path_to_maltparser+"")    
# lire le fichier
file_input  = open(output_conll,"r")
txt         = file_input.read()
texte       = txt.decode("utf8").split('\n')
for line in texte:        
    if(len(line)!=0):
        print(line)
    else:
        print("vide")       
