#!/usr/bin/perl -w

use MorphTranslation;
use strict;

my $sent = "";
while(<STDIN>) {
  unless (/^\s*\{sentence( #\d+)?\}\s*$/) {
    my $parse = "";
    while (s/(\(\S+ \S+\))//) {
      $parse .= $1;   
    }
    $parse = ParseToTagSequence($parse);
    $parse =~ s/[\[\]]//g ;

    $parse = join(" ",split(" ",$parse));

    $sent .= $parse . " ";
  }  
  else { 
    print "$sent\n" if ($sent);
    $sent = "";
  }
}
print "$sent\n" if ($sent);
