#!/bin/bash
# Param1  : le script ./generate_conll1.sh
# Param2  : le fichier input_conll1.conll
# Param3  : le fichier output_conll1.conll
# Param4  : le nom du fichier vers les IDs récupérer auparavant avec getIDS par exemple xaa
# Param5  : le chemin vers  MorphTaggerArabe
# Param6  : le chemin vers  treetagger/cmd
# Param7  : le chemin vers  french-abbreviations
# Param8  : le chemin vers  le dossier stanford_ner qui contient les modèles de StanfordNER
# Param9  : le chemin vers  les bin de java                 par exemple java1.8/bin/java"
# Param10 : le nom du serveur de MongoDB                    par exemple localhost
# Param11 : le nom de la base de donénes                    par exemple youtube
# Param12 : le nom de la collection généré par YouCorpus.sh par exemple corpus.youtube.all
# Param13 : le nom de la nouvelle collection                par exemple corpus.youtube.ling
python save_mongo.py "./generate_conll1.sh" "input_conll1.conll" "output_conll1.conll" "/projets/musk/Youtube/ling_youtube/nltk/folder_ids/xaa" "/projets/musk/Youtube/ling_youtube/nltk/MorphTaggerArabe" "/projets/musk/Youtube/ling_youtube/treetagger/cmd" "/projets/musk/Youtube/ling_youtube/treetagger/lib/french-abbreviations" "/projets/musk/Youtube/ling_youtube/stanford_ner/" "/logiciels/java1.8/bin/java" "localhost" "youtube" "corpus.youtube.all" "corpus.youtube.ling"
