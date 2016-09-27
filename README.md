# RUN_YOUTUBE, RUN_LINGUISTIQUE et RUN_CLASSIFICATION
# RUN_YOUTUBE
# YouCraw
YouCraw est un outils OpenSource pour récupérer les méta-données YouTube, basé sur l'API "YouTube Data API (v3)", et la sauvegarde de ces méta-données dans une base de donénes MongoDB.
# Code Sources
Dans le dossier ExtractYoutube, vous trouvriez le code source en java, développé avec l'IDE NetBeans 8.1

# Les méta-données disponibles
1. _id : l’identifiant de la vidéo
2. title : le titre de la vidéo
3. channelid : l’identifiant du canal
4. channeltitle : le titre du canal
5. datepub : la date de publication de la vidéo
6. description : la description de la vidéo
7. tags : une liste des mots liés à la vidéo
8. kind : le type par exemple youtube#video
9. defaultaudiolang : la langue par défaut de la vidéo
10. viewcount : le nombre du vue de la vidéo
11. likecount : le nombre des utilisateurs qui ont aimés la vidéo
12. dislikecount : le nombre des utilisateurs qui n’ont pas aimés la vidéo
13. commentscount : le nombre des commentaires
14. comments : une liste des commentaires :
  * author  : l’auteur du commentaire
  * like    : le nombre des utilisateurs qui ont aimés le commentaire
  * message : le contenu du commentaire
15. transcription : la transcription de la vidéo

# Prérequis
1. OS Linux
2. MongoDB    https://www.mongodb.com/download-center?filter=enterprise#enterprise
3. Youtube-DL https://rg3.github.io/youtube-dl/
4. JAVA 1.8 ou supérieur
5. Python 2.7 ou supérieur

# Utilisation
1. Copier le dossier RUN_YOUTUBE dans votre machine
2. Création d'un compte Google sur le site https://developers.google.com/youtube/v3/getting-started
3. Récupération de fichier JSON qui contient le "clientId", "clientSecret"
4. Exécuter le script python "generateRefreshTokens.py" ou "getCredential.py" pour récupérer "refreshToken" 
5. Modifier les paramètres dans le fichier "YouCraw.sh"

# Lancer le Crawler
$ ./YouCraw.sh

# RUN_LINGUISTIQUE
Le dossier RUN_LINGUISTIQUE contient des scripts en python et des modèles pour MaltParser (la construction des arbres syntaxique en dépendance), StanforNER (l'extraction des entités nommées).Ces scripts utilisent la base de données MongoDB et particulièrement la collection des méta-données pour construire d'autres collections linguistiques

# Prérequis logiciel
1.  OS Linux
2.  MongoDB        https://www.mongodb.com/download-center?filter=enterprise#enterprise
3.  JAVA 1.8 ou supérieur
4.  Python 2.7 ou supérieur
5.  Maltparser     http://www.maltparser.org/download.html
6.  Stanford NER   http://nlp.stanford.edu/software/CRF-NER.shtml
7.  TreeTagger     http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/
8.  SRILM          http://www.speech.sri.com/projects/srilm/download.html
9.  MorphSegmenter https://www-i6.informatik.rwth-aachen.de/~mansour/MorphSegmenter/

# Prérequis librairies python
1.  langdetect-1.0.6       https://pypi.python.org/pypi/langdetect?
1.  Morfessor-2.0.2alpha3  https://pypi.python.org/pypi/Morfessor/2.0.2alpha3
2.  nltk-3.2.1             https://pypi.python.org/pypi/nltk/3.2.1
3.  numpy-1.9.3            https://pypi.python.org/pypi/numpy/1.11.2rc1
4.  polyglot-master        https://pypi.python.org/pypi/polyglot/16.7.4
5.  pycld2-0.31            https://pypi.python.org/pypi/pycld2/0.31
6.  PyICU-1.9.3            https://pypi.python.org/pypi/PyICU/1.9.3
7.  pymongo-3.3.0          https://pypi.python.org/pypi/pymongo/3.3.0
8.  six-1.10.0             https://pypi.python.org/pypi/six/1.10.0
9.  wheel-0.29.0           https://pypi.python.org/pypi/wheel/0.30.0a0
10. JEIBA                  https://pypi.python.org/pypi/jieba/

# Lancer les scripts
1. Copier tous les modèles de MaltParser (arabic1.3.mco, chinese1.3.mco, english1.3.mco, french1.3.mco, russian1.3.mco, german1.3.mco) dans le dossier RUN_LINGUISTIQUE
2. Lancer le script ./YouDict.sh pour générer un dictionnaire (Dictionary_Sentence.conll) pour aider faire la segmentation de la transcription, sinon on crée un fichier vide et la segmentation devra des sauts des lignes. Avant de lancer le script modifier les paramètres (nom du serveur de MongoDB, nom de la base de données, le nom de la collection des méta données)
3. Lancer le script getIDS.py pour récupérer les IDs des vidéos dans un fichier par exemple xaa (voir le script getIDS)
4. Modifier les parametres dans le script YouCorpus.sh puis lancer le avec ./YouCorpus.sh
5. Modifier les paramètres dans le script YiuLing1.sh puis lancer le avec  ./YiuLing1.sh

# RUN_CLASSIFICATION
Ce dossier contient tous les scripts pour faire la classification non supervisé et supervisé
# Prérequis
1. Installer R
2. Installer Kmeans et CAH sous R
3. Installer tm et topicmodels pour la méthode LDA

# Les données d'apprentissage
Modifier les paramètres DataTrain.sh et lancer le, pour générer les données d'apprentissage
# Tester les scripts R
Tester les scripts de classfication non supervisé et supervisé avec les données d'appretissage

# Author 
Saber.N
# Mail
saber.lisis@gmail.com

# Licence
OpenSource
