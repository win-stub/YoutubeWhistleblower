#!/bin/bash
# Param1 : le nom du serveur de MongoDB              (par exemple localhost)
# Param2 : le nom de la base de données de MongoDB   (par exemple youtube)
# Param3 : le nom de la collection des méta données  (par exemple corpus.youtube.meta)
python generate_dictionary_corpus.py "localhost" "youtube" "corpus.youtube.meta" > "Chemin vers le dossier RUN_LINGUISTIQUE"/Dictionary_Sentence.conll  
