#!/bin/sh
# les paramettres d entree
# $1 : le chemin vers les scripts de MorphTagger
# $2 : le chemin de sortie
# generer le fichier d entree
rm -r $2/result1
rm file_ara1.txt
echo "$3" >> file_ara1.txt
# passer le fichier comme paramettre au MorphTagger
export SRILMDIR=/logiciels/srilm/bin/i686-m64
# run MorphTagger
# 
$1/MTSeg.sh -srilm $SRILMDIR -dir $2/result1 -lm $1/model_atb1v3/corpus.lm -lex $1/model_atb1v3/corpus.lex.prob file_ara1.txt
