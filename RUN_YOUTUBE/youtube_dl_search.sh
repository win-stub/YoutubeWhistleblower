#!/bin/bash
# les paramètres
# Param1 : les mots clées de recherche
# Param2 : la date de recherche de type yyyyMMdd mais avec "ytsearchdate"
# Param3 : le max des résulats
# Param4 : le fichier de sortie qui contient les ID des vidéos YouTube
# Utiliser juste une seule option de recherche soit par date et mots clés ou date du jour et mots clés, ou par mots clés
# Pour utiliser le parametre DATE_SEARCH avec l'option search_youtube-dl, l'année devra une date de format "yyyyMMdd"
rm     $4
touch  $4
# Critere de recherche
CRITERE_SEARCH=$1
DATE_SEARCH=$2
# -------------------------------------  Recherche par date fournie en parametres et mots clés -----------------------------------
#youtube-dl --get-id -i --ignore-errors --youtube-skip-dash-manifest --date "$DATE_SEARCH" ytsearchdate$3:"$CRITERE_SEARCH" >> $4
# --------------------------------------------------------------------------------------------------------------------------------
#
#
# -------------------------------------- Recherche par la date courante (date du sytème) en parametres et mots clés --------------
#DATESEARCH=$(date +%Y%m%d)
#youtube-dl --get-id -i --ignore-errors --youtube-skip-dash-manifest --date "$DATE_SEARCH" ytsearchdate$3:"$CRITERE_SEARCH" >> $4
#---------------------------------------------------------------------------------------------------------------------------------
#
#
#
#-------------------------------------  Recherche par mots clés ------------------------------------------------------------------
youtube-dl --get-id -i --ignore-errors --youtube-skip-dash-manifest ytsearch$3:"$CRITERE_SEARCH" >> $4
#---------------------------------------------------------------------------------------------------------------------------------
