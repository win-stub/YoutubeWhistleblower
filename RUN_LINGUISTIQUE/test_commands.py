# -*- coding: utf-8 -*-
"""
Created on Wed May 18 10:35:25 2016

@author: saber
"""

import subprocess as sub

treetagger_languages = {
u'latin-1':['latin', 'latinIT', 'mongolian', 'swahili'],
u'utf-8' : ['bulgarian', 'dutch', 'english', 'estonian', 'finnish', 'french', 
            'galician', 'german', 'italian', 'polish', 'russian', 'slovak', 
            'slovak2', 'spanish','chinese']}
            
p = sub.Popen(['./test.sh','aa aa aa aa','a'],stdout=sub.PIPE,stderr=sub.PIPE)
output, errors = p.communicate()

print output