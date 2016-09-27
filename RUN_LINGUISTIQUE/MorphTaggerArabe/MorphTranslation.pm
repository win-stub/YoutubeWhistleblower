#!/usr/bin/perl 

package MorphTranslation;
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(ParseToTagSequence
				 ParseToMorphTagPairs
               );
               
our @EXPORT_OK =qw();
our $VERSION = 1.00;

sub ParseToMorphTagPairs {
    my $p = $_[0];
	#10.12.07
	#$p =~ s/[\(\)]//g;
	$p =~ s/\((\S+) (\S+)\)/$1 $2/g;
    return split(" ",$p);
}

sub ParseToTagSequence {
  my $parse = $_[0];
  $parse =~ s/\((\S+)\s+\S+\)/$1 /g;
  $parse =~ s/\s+$//;
  $parse =~ s/^\s+//;
  return "[ " . $parse . " ]"; 
}

1;
