# -*- coding: utf-8 -*-
"""
Created on Thu Jun  9 11:54:34 2016

@author: saber
"""

import sys
import SN_extract_dep as extract

reload(sys)  
sys.setdefaultencoding('utf8')

txt1 ='''
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

1	The	the	_	DT	_	2	det	_	_
2	bill	bill	_	NN	_	5	nsubjpass	_	_
3	was	be	_	VBD	_	5	auxpass	_	_
4	finally	finally	_	RB	_	5	advmod	_	_
5	signed	sign	_	VBN	_	0	root	_	_
6	into	into	_	IN	_	7	case	_	_
7	law	law	_	NN	_	5	nmod	_	_
8	by	by	_	IN	_	12	case	_	_
9	President	President	_	NP	_	12	compound	_	_
10	Ulysses	Ulysses	_	NP	_	12	compound	_	_
11	S.	S.	_	NP	_	12	compound	_	_
12	Grant	Grant	_	NP	_	7	nmod	_	_
13	.	.	_	SENT	_	5	punct	_	_
'''

txt='''
1	The	the	_	DT	_	2	det	_	_
2	bill	bill	_	NN	_	5	nsubjpass	_	_
3	was	be	_	VBD	_	5	auxpass	_	_
4	finally	finally	_	RB	_	5	advmod	_	_
5	signed	sign	_	VBN	_	0	root	_	_
6	into	into	_	IN	_	7	case	_	_
7	law	law	_	NN	_	5	nmod	_	_
8	by	by	_	IN	_	12	case	_	_
9	President	President	_	NP	_	12	compound	_	_
10	Ulysses	Ulysses	_	NP	_	12	compound	_	_
11	S.	S.	_	NP	_	12	compound	_	_
12	Grant	Grant	_	NP	_	7	nmod	_	_
13	.	.	_	SENT	_	5	punct	_	_
'''

import SN_extract_dep as extract

rel_list_sec =['amod','nmod']
rel_list_pri =['name','compound']

ret = extract.getDEPS(txt1,rel_list_pri,rel_list_sec)
print(ret.strip())
# print result
#print(tab_global)
#for tab_groups in tab_global:
#    str_return = "_".join(tab_word[int(x)-1] for x in tab_groups)
#    print(str_return)

















