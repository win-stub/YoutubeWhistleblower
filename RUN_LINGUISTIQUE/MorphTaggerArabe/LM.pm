#!/usr/bin/perl -w

package LM;
require Exporter;

use MorphTranslation;


our @ISA = qw(Exporter);
our @EXPORT = qw(
  ReadLM
  NgramProb
  SequenceProb
  RemoveLast
);

our $VERSION = 1.00;

%LM = ();
$ORDER = 0;

sub RemoveFirst {
  my $ngram = shift;
  $ngram =~ s/^\S+\s*//;
  return $ngram;
}

sub RemoveLast {
  my $ngram = shift;
  $ngram =~ s/\s*\S+$//;
  return $ngram;
}

sub SequenceProb {
  my $sequence = shift;
  my $ngram_order = shift;
  die "SequenceProb: ngram order is greater than lm order\n" 
      if $ngram_order>$ORDER;
  my (@context,$ngram,$seqprob,$prob,$n);

  my @tokens = split(" ",$sequence);  
  @context = @_ ? split(" ",$_[0]) : ();   

  $ngram = shift @tokens;
  
  for($n=1;$n<$ORDER && @context ; $n++) {
    $ngram = (pop @context) . " " . $ngram; 
  }

  $seqprob = 0;
  while() {
    $prob = NgramProb($ngram);
#    print STDERR "$ngram : $prob\n";
    return -999999 if ($prob == -99);
    $seqprob += $prob;
  
    last unless (@tokens);
    if ($n < $ngram_order) {
	$n++;
    }
    else {
      $ngram = RemoveFirst($ngram);
    }
 
    $ngram .= " " . (shift @tokens);
  } 
  return $seqprob;
}

sub NgramProb {
    my $ngram = shift;
    my ($shorterngram,$context,$bow,$prob);

    if (IsNgramInLM($ngram)) {

        # the ngram exists
	return $LM{$ngram}{'prob'};
    }
    else {
        # the ngram does not exist;   
        $shorterngram = RemoveFirst($ngram);
        return -99 unless($shorterngram); # return -99 if the unigram was not found

        $context = RemoveLast($ngram);

        $bow = IsNgramInLM($context) ? $LM{$context}{'bow'} : 0;
        $bow = 0 if $bow == -99;
        $prob = NgramProb($shorterngram);

        return -99 if ($prob == -99);       
        return $bow+$prob;
    }           
}       
sub IsNgramInLM {
  return defined($LM{$_[0]});
}

sub ReadLM {
  my $lmfile = shift;  
  my ($bow,$prob);
  open(LH,"<" . $lmfile) or die "Can't open $lmfile\n";

  
  my $line = <LH>; 
  while($line !~ /^ngram (\d+)=/) {
    $line = <LH>; 
  }
  $ORDER = $1;
  while($line =~ /^ngram (\d+)=/) {
    $ORDER = $1;
    $line = <LH>; 
  }

#  print STDERR "order is:$ORDER\n";

  for (my $n=1;$n<= $ORDER; $n++) {

    #get to the beginning of the next order ngrams
    while($line !~ /^\\(\d+)-grams\:/) {
      $line = <LH>;
    }
    
#    print STDERR "$n-grams:\n";
    $line = <LH>;
    die "unexpected end of file\n" unless ($line);
    while($line =~ /\S+/) {

      @tokens = split(" ",$line);
      $prob = shift @tokens;
      if (defined($tokens[$n])) {
        $bow = pop @tokens;
      }
      else {
        $bow = -99;
      }      
      $ngram = join(" ",@tokens);      
#      print STDERR "{$prob} {$ngram} {$bow}\n"; 
      $LM{$ngram}{'prob'} = $prob;
      $LM{$ngram}{'bow'} = $bow;
      $line = <LH>;
      die "unexpected end of file\n" unless ($line);    
    }            
  }
}
 
1;
