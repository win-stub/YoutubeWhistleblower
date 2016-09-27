#!/usr/bin/perl -w

#Training phase for MorphTagger
#will produce corpus.lm and corpus.lex.prob files

use strict;
use File::Spec;
use File::Basename;
use Getopt::Long;

#get the directory of this script
my $MORPHTAGGERDIR = dirname( File::Spec->rel2abs( __FILE__ ) );

#SRILM directory
my $SRILM = "~/src/srilm/bin/i686";

############ setting the defaults
my $LMORDER = 3;
my $CORPUSFILE = "";

my $LMFILE = "";
my $LEXPROBFILE = "";
my $WORKINGDIR = ".MorphTaggerWorkDir";

sub helpMessage{
	print STDERR <<"EOF";

MorphTagger *Light* Version 1.0. Copyright 2005, Roy Bar-Haim. 2010 Saab Mansour

Usage: MTLearn.pl [options] corpusfile

corpusfile      a tagged training corpus. See software documentation 
                for further details on the required format for this
                file.

OPTIONS:
--lmfile        specifies the name of the language model file to be
                generated. If not specified, corpus.lm is generated in
                the working directory.
				
--lexprobfile   specifies the name of the lexical probabilities file
                to be generated. If not specified, corpus.lex.prob 
                is generated in	the working directory.

--n ngram-order ngram-order should be an integer between 1 and 5. Sets the order
                of the ngram model used for the HMM model for tagging.
		
--dir|d workdirname
                a directory into which all the temporary files will be 
                written. If the directory does not exist, it will be created.
                The default value is .MorphTaggerWorkDir.
				
--srilm dir     SRILM directory

--help          print this message
EOF
  exit;
}

######################## parse command line #####################
my $result = GetOptions ("n:i" => \$LMORDER,
					  	 "lmfile|lm:s" => \$LMFILE,
					  	 "lexprobfile|lex:s" => \$LEXPROBFILE,
					  	 "d|dir:s" => \$WORKINGDIR,
					  	 "srilm:s" => \$SRILM,
					  	 "h|help" => sub { helpMessage } );

if (! $result) {
	print STDERR "something went wrong with reading the command line parameters!\n";
}

if (@ARGV == 1){
	$CORPUSFILE = shift @ARGV;
}
die "$CORPUSFILE was not found\n" unless -e $CORPUSFILE;

mkdir($WORKINGDIR) unless -d $WORKINGDIR;

if ( ! -e $LMFILE ) {
	$LMFILE = "$WORKINGDIR/corpus.lm";
}

if ( ! -e $LEXPROBFILE ) {
	$LEXPROBFILE = "$WORKINGDIR/corpus.lex.prob"
}

##### create language model for morphemes
print STDERR "CREATING THE PROBABILISTIC MODEL:\n";
print STDERR "creating a backoff language model over morpheme tags:\n";

# convert the corpus to tag sequence format
if ( -e "$WORKINGDIR/corpus.tagseq" ){
	unlink "$WORKINGDIR/corpus.tagseq" or warn "Could not unlink $WORKINGDIR/corpus.tagseq: $!";
}
`perl -I$MORPHTAGGERDIR $MORPHTAGGERDIR/CorpusToTagSequence.pl < $CORPUSFILE > $WORKINGDIR/corpus.tagseq`;
CheckStat("Conversion to tag sequence");

# create a backoff language model over morpheme tags
if ( -e $LMFILE ) {
	unlink "$LMFILE" or warn "Could not unlink $LMFILE: $!";
}
`$SRILM/ngram-count -order $LMORDER -text $WORKINGDIR/corpus.tagseq -lm $LMFILE -gt1max 0`;
CheckStat("Generatoin of LM");

##### create the tagging model
print STDERR "Converting the morpheme-level model into a word-level HMM:\n";
unlink("$WORKINGDIR/analyses.morph.map","$WORKINGDIR/analyses.revmap", "$WORKINGDIR/corpus.morph.lm");
`perl -I$MORPHTAGGERDIR $MORPHTAGGERDIR/CountCorpus.pl $LEXPROBFILE $CORPUSFILE`;
CheckStat("HMM model creation");


####################### Adjust the output ########################

print STDERR "\nDONE!\n";

sub CheckStat {
  my $status = $?;
  if ($status) {
     printf STDERR "%s failed (exit status %d)\nMorphTagger terminated\n",$_[0],$status; 
     exit $status; 
  }
}
