#!/bin/bash
# Param1 : server_name     par exemple localhost
# Param2 : db_name         par exemple youtube
# Param3 : collection_meta par exemple corpus.youtube.meta
# Param4 : collection_all  par exemple corpus.youtube.all
# Param5 : le nom vers un fichiers qui contient des ID de vidéos, on peut le récupérer on exécutant le script 
# Param6 : le nom vers un fichiers Dictionary_Sentence.conll généré par YouDict.sh 
# Param7 : option toujours "1"
python generate_corpus_lang.py "localhost" "youtube" "corpus.youtube.meta" "corpus.youtube.all" "/projets/musk/Youtube/ling_youtube/nltk/folder_ids/xaa" "/projets/musk/Youtube/ling_youtube/nltk/Dictionary_Sentence.conll" "1"
