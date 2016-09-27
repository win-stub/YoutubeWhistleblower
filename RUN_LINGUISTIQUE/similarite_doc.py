# -*- coding: utf-8 -*-
"""
Created on Tue Jun  7 15:35:24 2016

@author: saber
"""

# coding: utf-8

from math import sqrt
import sys
from pymongo import MongoClient
#
reload(sys)  
sys.setdefaultencoding('utf8')
#
is_intersect = sys.argv[1]
video_id     = sys.argv[2]
type_rel     = sys.argv[3]
#
client           = MongoClient()
client           = MongoClient('localhost', 27017)
db               = client['youtube']
collection       = db['corpus_youtube.meta']
collection_lang  = db['corpus_youtube.ling']

for col in collection_lang.find({}):
    #        
    for artist, tags in col.items():
        print(tags)
    #
   


data = {
    'Pink Floyd': {
        'progressive rock': "saber",
        'classic rock': 78,
        'psychedelic rock': 70,
        'experimental': 5
    },
    'Alain Souchon': {
        'chanson française': 100,
        'chanson': 34,
        'pop': 33,
        'singer-songwriter': 12
    },
    'Hans Zimmer': {
        'soundtrack': 100,
        'instrumental': 57,
        'classical': 41,
        'composer': 32
    },
    'The Police': {
        'rock': 100,
        'new wave': 66,
        'classic rock': 81,
        'pop': 40
    },
    'Chopin': {
        'classical': 100,
        'piano': 47,
        'romantic': 26,
        'instrumental': 22
    }
}

from operator import itemgetter

for artist, tags in data.items():
    scores = {}
    for artist_, tags_ in data.items():
        scores[artist_] = similarity(tags, tags_)
    scores = sorted(scores.items(), key=itemgetter(1), reverse=True)
    print('\nSimilar artists for {}:'.format(artist))
    for artist, score in scores:
        print('\t{} ({:.2})'.format(artist, score))


def similarity(a, b):
    all_keys = set(list(a) + list(b))
    diffs = ((a.get(k, 0) - b.get(k, 0)) ** 2 for k in all_keys)
    distance = sqrt(sum(diffs))
    return 1 / (1 + distance)