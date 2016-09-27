# -*- coding: utf-8 -*-
"""
Created on Wed Jun  1 18:47:58 2016

@author: saber
"""
import sys
import SN_extract_dep as extract


reload(sys)  
sys.setdefaultencoding('utf8')

txt='''
1	This	this	_	DT	Number=Sing|PronType=Dem	7	nsubj	_	_
2	is	be	_	VBZ	Mood=Ind|Number=Sing|Person=3|Tense=Pres|VerbForm=Fin	7	cop	_	_
3	a	a	_	DT	Definite=Ind|PronType=Art	7	det	_	_
4	"	"	_	``	_	7	punct	_	_
5	test	test	_	NN	Number=Sing	7	compound	_	_
6	email	<unknown>	_	NN	Number=Sing	7	compound	_	_
7	send	send	_	NN	Number=Sing	0	root	_	_
8	"	"	_	''	_	7	punct	_	_
9	of	of	_	IN	_	13	case	_	_
10	the	the	_	DT	Definite=Def|PronType=Art	13	det	_	_
11	WPO	<unknown>	_	NP	Number=Sing	12	compound	_	_
12	Forum	Forum	_	NP	Number=Sing	13	compound	_	_
13	Group	Group	_	NP	Number=Sing	7	nmod	_	_
14	from	from	_	IN	_	16	case	_	_
15	Richard	Richard	_	NP	Number=Sing	16	name	_	_
16	Everett	Everett	_	NP	Number=Sing	7	nmod	_	_
17	.	.	_	SENT	_	7	punct	_	_
'''

txt='''
1	Several	several	_	JJ	_	3	amod	_	_
2	possible	possible	_	JJ	_	3	amod	_	_
3	plans	plan	_	NNS	_	4	nsubj	_	_
4	emerged	emerge	_	VBD	_	0	root	_	_
5	from	from	_	IN	_	7	case	_	_
6	the	the	_	DT	_	7	det	_	_
7	talks	talk	_	NNS	_	4	nmod	_	_
8	,	,	_	,	_	4	punct	_	_
9	held	hold	_	VBN	_	4	parataxis	_	_
10	at	at	_	IN	_	14	case	_	_
11	the	the	_	DT	_	14	det	_	_
12	Federal	Federal	_	NP	_	14	compound	_	_
13	Reserve	Reserve	_	NP	_	14	compound	_	_
14	Bank	Bank	_	NP	_	9	nmod	_	_
15	of	of	_	IN	_	17	case	_	_
16	New	New	_	NP	_	17	compound	_	_
17	York	York	_	NP	_	14	nmod	_	_
18	and	and	_	CC	_	9	cc	_	_
19	led	lead	_	VBN	_	9	conj	_	_
20	by	by	_	IN	_	23	case	_	_
21	Timothy	Timothy	_	NP	_	23	name	_	_
22	R.	R.	_	NP	_	23	name	_	_
23	Geithner	<unknown>	_	NP	_	19	nmod	_	_
24	,	,	_	,	_	23	punct	_	_
25	the	the	_	DT	_	26	det	_	_
26	president	president	_	NN	_	23	appos	_	_
27	of	of	_	IN	_	31	case	_	_
28	the	the	_	DT	_	31	det	_	_
29	New	New	_	NP	_	30	compound	_	_
30	York	York	_	NP	_	31	compound	_	_
31	Fed	Fed	_	NP	_	26	nmod	_	_
32	,	,	_	,	_	9	punct	_	_
33	and	and	_	CC	_	9	cc	_	_
34	Treasury	Treasury	_	NP	_	35	compound	_	_
35	Secretary	Secretary	_	NP	_	39	compound	_	_
36	Henry	Henry	_	NP	_	39	compound	_	_
37	M.	M.	_	NP	_	39	compound	_	_
38	Paulson	Paulson	_	NP	_	39	compound	_	_
39	Jr	Jr	_	NP	_	9	conj	_	_
40	.	.	_	SENT	_	4	punct	_	_
'''
rel_list =['compound','name','amod','nmod']
rel_list =['name','compound']
import SN_extract_dep as extract

# get all relation
rel_list =['compound','name','amod','nmod']
all_groups = extract.getDEPS(txt,rel_list)
# get all name and compound relation

rel_list =['name']
import SN_extract_dep as extract
all_groups_name = extract.getDEPS(txt,rel_list)
rel_list =['compound']
all_groups_compound = extract.getDEPS(txt,rel_list)
rel_list =['amod']
all_groups_amod = extract.getDEPS(txt,rel_list)
rel_list =['nmod']
all_groups_nmod = extract.getDEPS(txt,rel_list)
print(all_groups_name.strip()+'\n'+all_groups_compound.strip()+'\n'+all_groups_amod.strip())




