rm -r result
# export chemin vers SRLIM
export SRILMDIR=/home/saber/DA_Stage/parser/maltparser/train_arabic/srilm-1.7.1/bin/i686-m64
# run SegmenterMorphTagger
../MTSeg.sh -srilm $SRILMDIR -dir result -lm ../model_atb1v3/corpus.lm -lex ../model_atb1v3/corpus.lex.prob $1
