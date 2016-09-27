# -*- coding: utf-8 -*-
"""
Created on Sat Jun  4 23:47:08 2016

@author: user
"""
import sys
from igraph import *

reload(sys)  
sys.setdefaultencoding('utf8')

txt3='''
1	A	A	NAM	_	_	3	nsubj	_	_
2	B	B	NAM	_	_	1	name	_	_
3	C	C	VER:pres	_	Mood=Ind|Number=Sing|Person=3|Tense=Pres|VerbForm=Fin	0	root	_	_
4	D	D	DET:ART	_	Definite=Def|Gender=Masc|Number=Sing	5	det	_	_
5	E	E	NOM	_	Gender=Masc|Number=Sing	3	dobj	_	_
6	F	F	PRP	_	_	8	case	_	_
7	G	G	DET:ART	_	Definite=Def|Gender=Fem|Number=Sing	8	det	_	_
8	H	H	NOM	_	Gender=Fem|Number=Sing	3	nmod	_	_
9	I	I	ADJ	_	Gender=Fem|Number=Sing	8	amod	_	_
10	J	J	ADJ	_	Gender=Fem|Number=Sing	8	amod	_	_
11	K	K	SENT	_	_	3	punct	_	_
'''

tab_src=[]
tab_dest=[]
tab_rel=[]
tab_word=[]

txt = txt3.strip().decode("utf8").split('\n')
rel_list =['amod','nmod','compound','name']

for line in txt:
    tab_word.append(line.split('\t')[1])
    if len(line)!=0 and line.split('\t')[7] in rel_list:
        tab_src.append(line.split('\t')[6])
        tab_dest.append(line.split('\t')[0])
        tab_rel.append(line.split('\t')[7])
print(tab_src)
print(tab_dest)
print(tab_rel)

tmp_graph = []
for i in range(len(tab_src)):
    tmp_graph.append((int(tab_src[i]),int(tab_dest[i])))
print(tmp_graph)    

g = Graph(tmp_graph,directed=True)
print g

g.ecount() 

for src in tab_src:
    for dest in tab_dest:
        if src!=dest:
            find_all_paths2(g,int(src),int(dest),[])

def find_all_paths2(G, start, end, vn = []):
    """ Finds all paths between nodes start and end in graph.
    If any node on such a path is within vn, the path is not returned.
    !! start and end node can't be in the vn list !!
    
    Params:
    --------
    
    G : igraph graph
    
    start: start node index
    
    end : end node index
    
    vn : list of via- or stop-nodes indices
    
    Returns:
    --------
    
    A list of paths (node index lists) between start and end node
    """
    vn = vn if type(vn) is list else [vn]
    #vn = list(set(vn)-set([start,end]))
    path  = []
    paths = []
    queue = [(start, end, path)]
    while queue:
        start, end, path = queue.pop()
        path = path + [start]
    
        if start not in vn:
            for node in set(G.neighbors(start,mode='OUT')).difference(path):
                queue.append((node, end, path))
    
            if start == end and len(path) > 0:              
                paths.append(path)
            else:
                pass
        else:
            pass
    
    return paths