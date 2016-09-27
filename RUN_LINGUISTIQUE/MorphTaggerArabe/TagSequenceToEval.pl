#!/usr/bin/perl -w

#../Arabic/data/8.8.08/mtout+l-v+c/.tagging ../Arabic/data/8.8.08/mtout+l-v+c/.sentrevmap ../Arabic/data/8.8.08/mtout+l-v+c/.sentmap
# nbest are now broken


$tagseqfile = $ARGV[0];
$revmapfile = $ARGV[1];

open(TH,"<" . $tagseqfile) or die "Can't open $tagseqfile\n";
open(RH,"<" . $revmapfile) or die "Can't open $revmapfile\n";

if ( -s $tagseqfile == 0 ) {
  print STDERR "empty tagging! aborting...\n";
  exit 1;
}

#-----------------
# REUT 24-10-2005
#-----------------
#
# get probabilities file
$probfile = $ARGV[2];

# get sentence number
if ($#ARGV > 2) { 
$sentnumber = $ARGV[3];
}
else {
$sentnumber = 1;
print STDERR "sentence number undefined, set to 1\n";
}
# get printprob (yes|no)
if ($#ARGV > 3) {
$printprob = $ARGV[4];
}
else {
$printprob = 0;
print STDERR "printprob number undefined, set to 0\n";
}
#-----------------

#-----------------
# REUT 24-10-2005
#-----------------
#get the next line
while ($tagSeq = <TH>)
{

#get the next tag sequence
while($tagSeq !~ /\[/) {
  $tagSeq = <TH>;
}
#------------------

#-----------------
# REUT 24-10-2005
#-----------------
# get nbest-count number
# get the probability value from the input line
if ($tagSeq =~ s/^NBEST\_(\w+)(\s+)(\-\S+)//) {
$printprob = 2;
$prob = $3;
}
# get the probability value from a .probs file
elsif ($printprob > 0) {
  $prob = 0;
  open(PH,"<" . $probfile) or die "Can't open $probfile\n";
  $line = <PH>;
  if ($line =~ s/^(\S+)//) {
     $prob = $1;
  }
}
#-----------------

while ($tagSeq =~ s/\[.+?\]//) {
  $analysis = $&;

  #translate the analysis back to parse, using the reverse mapping file
  $revMapLine = <RH>;
  while ($revMapLine !~ /\[/) {
    $revMapLine = <RH>;   
  }
  $analysis1 = $analysis;
  $analysis1 =~ s/([\[\]])//g;
  #saib 3.9.07
  #added quotation \Q,\E, so now can support tags with special characters
  $revMapLine =~ /\[\Q$analysis1\E\]/;
  $rest = $';
  #add a space to the end
  $rest .= " ";
  $rest =~ /\s\{(.+?)\}\s/;
  $parse = $1;
  if ($parse){
    $parse =~ s/\) \(/\)\(/g 
  }
  else{
    $parse = "emptyline";
  }
  #saib 3.9.07
  #remove lemmas if present
  #if ($parse =~ /[a-z0-9FNK~]\+/){
  if ($parse =~ /\+/){
	  $parse =~ s/\(\S+?\+(\S+)\s(\S+?)\)/\($1 $2\)/g;
  }
  print "[$parse]";
}

if ( $printprob > 0 ) {
print "\t$prob";
}
print "\n";

#-----------------
# REUT 24-10-2005
#-----------------
# read the reverse map again
# very slow implementation
# nbest will be broken
#close(RH);
#open(RH,"<" . $revmapfile) or die "Can't open $revmapfile\n";
}
# mark end of nbest analyses
if ( $printprob > 1 ) {
print "#\n";
}
#----------------
