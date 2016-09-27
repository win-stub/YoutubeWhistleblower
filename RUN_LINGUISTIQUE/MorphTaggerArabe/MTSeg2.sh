#!/bin/bash -e

#MTSeg.sh


if [ $# == 0 ] || [ $1 == "-h" ] || [ $1 == "--help" ]; then
    echo ""
    echo "usage: MTSeg.sh [-dir workdir] file1 file2 ... fileN"
    echo ""
    exit 0
fi

MORPHTAGGERDIR=`dirname $0`/
TOOLSDIR=$MORPHTAGGERDIR/Tools/
ARAMORPHDIR=$MORPHTAGGERDIR/AraMorph/

OUTPUTDIR=`pwd`

#currently i always normalize
NORMP=-normp
NORMY=-normy
SRILM=""
DOCLEAN=0

export LANG=en_US.UTF-8

while [ "${1:0:1}" = "-" ]; do
    case $1 in
	-dir )     OUTPUTDIR=$2
	           shift 2
	           ;;	
	-lm )     CORPUSLM=$2
		   shift 2
		   ;;
	-lex )     CORPUSLEXPROB=$2
		   shift 2
		   ;;
	-srilm )     SRILM="--srilm $2"
		   shift 2
		   ;;
        -cat )     DOCATFLAG=1
                   shift
                   ;;
    -clean ) DOCLEAN=1
    		shift
    		;;
	*)
	echo "unknown option: $1"
	exit 0
    esac
done

if [ ! -d $OUTPUTDIR ]; then
	mkdir $OUTPUTDIR
else
	echo "${OUTPUTDIR} alraedy exists!"
fi

for f in $*; do

    INPUT=`basename $f`
    INPUT=${INPUT%.gz}
    #this is used if you want to run over the files in the outputdir only (not all the train)
    INPUT=${INPUT%.bama}
    OUTPATH=${OUTPUTDIR}/${INPUT}

    if [ ! -e $f ]; then
	echo ""
	echo "$f doesnt exist. skipping..."
	echo ""
    else

    echo "${INPUT}:"

    if [ -e "${OUTPATH}.seg" ]; then
	echo ""
	echo "Already segmented"
	echo ""
    else

    HOLD=""

    if [ ! -e ${OUTPATH}.bama ]; then
    	echo "running BAMA..."
        zcat -f ${f} | perl ${TOOLSDIR}/clean.pl -d | perl ${TOOLSDIR}/utf8_to_cp1256.pl | perl ${ARAMORPHDIR}/AraMorphNF.pl > ${OUTPATH}.bama
    else
    	echo "BAMA already performed. skipping..."
    fi

    if [ ! -e ${OUTPATH}.bama.format ]; then
    	echo "converting BAMA's output to MorphTagger input..."
	    perl -I${TOOLSDIR} ${TOOLSDIR}/buck-to-mt.pl -ct $NORMP $NORMY ${OUTPATH}.bama ${OUTPATH}.bama.format
    else
    	echo "converting BAMA's output already performed. skipping..."
    fi

    if [ ! -e ${OUTPATH}.bama.format.mt ]; then
    	echo "running MorphTagger..."
	    perl -I${MORPHTAGGERDIR} ${MORPHTAGGERDIR}/MTTest.pl ${SRILM} --d ${OUTPUTDIR} --lm $CORPUSLM --lex $CORPUSLEXPROB --o ${OUTPATH}.bama.format.mt ${OUTPATH}.bama.format
    else
    	echo "MorphTagger already performed. skipping..."
    fi

    if [ ! -e ${OUTPATH}.seg ]; then
    	echo "converting MorphTagger output to utf8 segmentation..."
        
	    perl -I${TOOLSDIR} ${TOOLSDIR}/mtout_to_morphs.pl < ${OUTPATH}.bama.format.mt | perl -I${TOOLSDIR} ${TOOLSDIR}/utf8_to_buck.pl -r | sed 's/#/HASHSYMBOL/g' | \
#		perl -pe 's/\xd9\xb1/\xd8\xa7/; s/\xc2\x81//g; s/\xc2\x8D//g; s/\xc2\x90//g; s/\@ emptyline \@/\@emptyline\@/;' | gzip -c > ${OUTPATH}.prep.gz
		perl -pe 's/\xd9\xb1/\xd8\xa7/; s/\xc2\x81//g; s/\xc2\x8D//g; s/\xc2\x90//g; s/\@ emptyline \@/\@emptyline\@/;' > ${OUTPATH}.seg
	    #\xd9\xb1=A Waslah
	    #\xd8\xa7=A
    fi

	#some cleanup
	if [ $DOCLEAN -eq 1 ]; then
    	rm -f ${OUTPATH}.bama*
    fi
	
    fi #if prep.gz already exists
    fi #if file doesnt exist
done

