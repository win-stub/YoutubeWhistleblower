#!/usr/bin/perl -w

#CountCorpus.pl

use CorpusProbabilities;
use strict;
#runs the CountCorpus function in CorpusProbabilities.pm and saves the results to a file

########################### Main program #####################################
my $outputlexprob = $ARGV[0];	#corpus.lex.prob
my $corpusfile = $ARGV[1]; 

print STDERR "no ambiguous corpus\n";
print STDERR "Counting tagged corpus...\n";

#updates in CorpusProbabilities.pm counts of words and analyses
CountCorpus($corpusfile);

SaveLexicalProbabilitiesToTextFile($outputlexprob);
#saves the global variables 
#$GPARSES{$word}{$gparse}++;				(save)
#$GCATS{$tag}++;
#$GPAIRS{$tag}{$morph}++;
