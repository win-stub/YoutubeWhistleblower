#!/bin/bash
# Param1 : la langue par exemple en, fr, de, cn, ar, ru
# Param2 : le nom de la méta données en question par exemple meta_NG, meta_NER, meta_REL, meta_1GRAM
# Param3 : le maximum des vidéos par exemple aumaximum 200 vidéos
# Param4 : la fréquence des unités linguistiques par exemple la vidéo contient au moins 20 unités lexicales de type meta_NG (groupe nominal)
# Param5 : Option 
# Param6 : le nom du serveur de MongoDB
# Param7 : le nom de la base de données
# Param8 : le nom de la collection linguistique par exemple corpus.youtube.ling
# Parma9 : le nom de la collection méta données par exemple corpus.youtube.meta
python getLDA.py "en" "meta_NG" "23" "10" "NG_TEST" "localhost" "youtube" "corpus.youtube.ling" "corpus.youtube.meta" > corpus.test.txt
