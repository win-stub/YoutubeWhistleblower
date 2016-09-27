#!/usr/bin/perl -w

package CorpusProbabilities;
require Exporter;

use MorphTranslation;
use Storable;
use strict;

our @ISA = qw(Exporter);
our @EXPORT = qw(CountCorpus
                 %GPARSES
                 %GCATS
                 %GPAIRS
                 SetLambda
				 SaveLexicalProbabilitiesToTextFile
				 LoadLexicalProbabilitiesFromTextFile
);

our $VERSION = 1.00;

our %GPARSES = (); 
our %GCATS =(); 
our %GPAIRS =(); 
our %GANALYSES = ();
our %GWORDANALYSISPAIRS = ();
our $ANALYSESCOUNT = 0;
our $PAIRCOUNT = 0;
our %CATCOUNTS =(); 
our %PAIRCOUNTS =(); 
our %PAIRS =(); 
our %CATS  =(); 
our %GREVPAIRS =(); 

my $C_N_0=1e5;

my $M_N_0=1e5;

my $lambda = 0.5;

sub SetLambda {
  $lambda = shift;
  print STDERR "Lambda was set to $lambda. (1-lambda)*P(tagged corpus)+lambda*P(ambiguous corpus)\n";
}

#This function updates the followin GLOBAL variables (never use global variables :( )
#GPARSES
#GANALYSES
#GWORDANALYSISPAIRS
#ANALYSESCOUNT
#GCATS
#GPAIRS
#PAIRCOUNTS (using PAIRS)
#CATCOUNTS (using CATS)
#GREVPAIRS
sub CountCorpus {
  my ($corpus_file) = @_;
  open(CF,"<" . $corpus_file) or die "Can't open $corpus_file\n";
  my $scnt=0;
  while (<CF>) {
    chomp;
    my $line= $_;
    # start of next sentence.
    if (/^\s*\{sentence( #\d+)?\}\s*$/) {
      $scnt++;
      next;
    } 
    # validity tests 
#    next unless (/^ +(\S+)( ([\(\)\-A-Z0-9a-z\*\_\<\> ]+))?$/);
    /^\s*(\S+)\s+(\S.+)\s*$/;
    die "No parse available in $scnt for $1\n" unless defined($2);
 
    my ($word,$parse)=($1,$2); 
    #$word =~ s/yy//g;
    #$parse =~ s/yy//g; 
    #print STDERR "word=$word parse=$parse\n"; 
    $parse =~ s/\s+$//; $parse =~ s/^\s+//;
    #  increment  C(word) and C(word,parse)
  
#    $PARSES{$word}{$parse}++;
#    $PARSES{$word}{'**COUNT**''}++;
    
    my $gparse = $parse; 
#    $gparse = RemoveFeaturesFromParse($parse);    
    $GPARSES{$word}{$gparse}++;

    my $analysis = ParseToTagSequence($gparse);
    #$analysis =~ s/ /_/g;
    $GANALYSES{$analysis}++;
    $GWORDANALYSISPAIRS{$analysis}{$word}++;
    $ANALYSESCOUNT++;
	#9.12.07
    #my @parse=split(/\)/,$parse);
	$parse = " $parse ";
	my @parse=split(/\)\s/,$parse);
	#end

    #iterate over the morphemes. 
    #for each morpheme m, full analysis(cartegory) c, and pos-tag p:
    # increment C(c),C(c,m),C(p),C(p,m) 
  
    foreach (@parse) {
		#9.12.07
		#s/\(//go; s/\)//go; 
		s/\((\S)/$1/;
		s/^\s+//; s/\s+$//;
		#s/\((\S+) (\S+)\)/$1 $2/;
		  #end
      if (/\S+/) {
	/^\s*(\S+)\s+(\S+)\s*$/;
        my ($tag,$morph)=($1,$2);
        print STDERR "!! $_ !!! $line $scnt \n" unless defined($morph);   

        $GCATS{$tag}++;
        $GPAIRS{$tag}{$morph}++;
        $PAIRCOUNT++;
      }
    }
  }
  close(CF);

  # count how many categories appeared X times
  while (my ($cat,$count)=each(%CATS)) {
    $CATCOUNTS{$count}++;
  }

  # smoothing - giving a non-zero probability for non-occuring categories
  $CATCOUNTS{0}=$C_N_0;

  # count how many (morpheme,category) pairs appeared X times
  foreach my $cat (keys %PAIRS) {
    while (my ($morph,$count)=each(%{$PAIRS{$cat}})) {
      $PAIRCOUNTS{$count}++;
    } 
  }

  ReversePairs(\%GPAIRS,\%GREVPAIRS);

  # smoothing for non-occuring pairs.
  $PAIRCOUNTS{0}=$M_N_0;

}



sub ReversePairs {
  my ($pairhash,$revpairhash) = @_;
  foreach my $p1 (keys %$pairhash) {
      foreach my $p2 (keys %{$$pairhash{$p1}}) {
	  #$$revpairhash{$p2}{$p1} = $$pairhsh{$p1}{$p2};
	  $$revpairhash{$p2}{$p1} = $$pairhash{$p1}{$p2};	#new by saib!
      }
  }
}



sub LoadLexicalProbabilitiesFromTextFile{
	my $lexprobfile = shift @_;
	
	open(IN,"<$lexprobfile") or die "can't open $lexprobfile for reading: $!";
	
	local $/;
	$/ = ""; # paragraph read mode

	#read GCATS
	$_ = <IN>;
	my @fields = split /^([^\t]+)\t\s*/m;
	shift @fields; # for leading null field
	%GCATS = map /(.*)/, @fields; #no idea how this works :)
	
	#read GPAIRS
	$_ = <IN>;
	@fields   = split /^([^\t]+)\t\s*/m;
	shift @fields; # for leading null field
	while (@fields){
		my $tag = shift @fields;
		my $morph_count = shift @fields;
		$morph_count =~ /(\S+)\t(\S+)/;		
		my $morph = $1;
		my $count = $2;
		#print STDERR "t=$tag,m=$morph,c=$count\n";
		if ($count){
		  $GPAIRS{$tag}{$morph} = $count;
		}
	}
	
	#read GPARSES
	$_ = <IN>;
	@fields   = split /^([^\t]+)\t\s*/m;
	shift @fields; # for leading null field
	while (@fields){
		my $word = shift @fields;
		my $parse_count = shift @fields;
		$parse_count =~ /(.+)\t(\d+)/;		
		my $parse = $1;
		my $count = $2;
		#print STDERR "t=$word,m=$parse,c=$count\n";
		if ($count){
		  $GPARSES{$word}{$parse} = $count;
		}
	}
}

sub SaveLexicalProbabilitiesToTextFile{
	my $outputlexprob = shift @_;
	open(OUTPUT,">$outputlexprob") or die "can't create $outputlexprob: $!";
	
	foreach my $key (keys %GCATS) {
	  print OUTPUT "$key\t$GCATS{$key}\n";
	}
	print OUTPUT "\n";
	
	foreach my $tag (keys %GPAIRS) {
		foreach my $morph ( keys %{ $GPAIRS{$tag} } ){
		  print OUTPUT "$tag\t$morph\t$GPAIRS{$tag}{$morph}\n";
		}
	}
	print OUTPUT "\n";
	
	foreach my $word (keys %GPARSES) {
		foreach my $parse ( keys %{ $GPARSES{$word} } ){
		  print OUTPUT "$word\t$parse\t$GPARSES{$word}{$parse}\n";
		}
	}
	print OUTPUT "\n";
	
	#$hash{"PROBGPAIRS"} = \%PROBGPAIRS; 
	#$hash{"PROBGCATS"} = \%PROBGCATS;
	close(OUTPUT);
}

1;
