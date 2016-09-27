#!/bin/bash
#SBATCH --job-name=YouCraw
#SBATCH --mail-type=END
#SBATCH --mail-user=nouioua.saber@gmail.com
#SBATCH --output=YouCraw2016.out
date
# Param0  : chemin vers les scripts et le fichier jar
# Param1  : option de recherche :
#	    1- search_youtube-dl : pour récupérer les méta données par le biais de Youtube-Dl (maximum 800)limité par la bibliothèque Youtube-Dl
#	    2- generate          : un generateur des meta données à partir d'un dossier qui contient des fichier texte
#           3- search_year       : récupérer toutes les meta données d'une année donnée
#           4- search_month_year : récupérer toutes les meta données d'une année donnée et un mois
# Param2  : un dossier qui contient des fichiers texte utilisé juste dans l'option "generate"
# Param3  : chemin vers le script du Youtube-Dl, utilisé juste avec l'option "search_youtube-dl"
# Param4  : mots clés pour la recherche
# Param5  : l'année de la recherche utilisé avec l'option "search_year" ou "search_month_year" par exemple "2016", mais si on utilise l'option "search_youtube-dl" l'année devra comme suit "yyyyMMdd" exemple : "20160408"
# Param6  : le mois de la recherche utilisé avec l'option "search_month_year"
# Param7  : le maximum des résulats à récupérer utilisté juste avec l'option "search_youtube-dl"
# Param8  : le nom du fichier resulat des id video (fichier tmp)
# Param9  : l'adresse du serveur de la base de données MongoDB
# Param10 : le port utilisé par MongoDB "par default 27017"
# Param11 : le port http par default "8080"
# Param12 : le nom de la base de données MONGODB
# Param13 : le nom de la collection MONGODB
# Param14 : clientId de l'API YOUTUBE
# Param15 : clientSecret de l'API YOUTUBE
# Param16 : refreshToken de l'API YOUTUBE
# Pour récupérer les clientID et client Secret voici le lien https://developers.google.com/youtube/v3/getting-started
# Pour récupérer le refreshToken voir le fichier Python "generateRefreshTokens.py" OR "getCredential.py"
CHEMIN="/projets/musk/Youtube/run_youtube"
# RUN
/logiciels/java1.8/bin/java -jar  $CHEMIN/ExtractYoutube.jar "search_month_year" "mondefr" "$CHEMIN/youtube_dl_search.sh" 'whistleblower and vaccine' "2016" "8" "500" "video_id.txt" "co2-nc04.irit.fr" "27017" "8080" "youtube" "corpus_youtube.meta.test" "clientId" "clientSecret" "refreshToken"
date
