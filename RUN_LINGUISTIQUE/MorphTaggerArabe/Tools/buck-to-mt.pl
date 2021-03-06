# gets buckwalter analysis as input and generates analyses in MorphTagger's format using
# ATB collapse

#################################
# 02.03.2010
# added two options:
# -normy        normalize y: Elyhm -> ElY + hm
# -normp        normalize p: xTthm -> xTp + hm
# this makes more sense to machine translation, so that morphemes
# will be treated "similarly"
#################################
# 1.10.05
# buck-to-mt takes a buckwalter analyses file and sgm file, and generates
# word and analysis output in MorphTagger format after collapse.
#################################
use strict;

use atb_common;
use perl_common;

use File::Spec;
use File::Basename;

#get the directory of this script
my $TOOLSDIR = dirname( File::Spec->rel2abs( __FILE__ ) );

#################################



######################### parse command line #####################
if ($#ARGV < 0 || $ARGV[0] eq "-help") {
  print STDERR <<"EOF";

Usage: $0 [options] buckout [output]
buckout       amibuous file generated by buckwalter morpho analyzer v1.0
output        the name of the output file, if not specified
              will be written to buckout-roy..., including errors files
OPTIONS:
-s scheme     which segmentation scheme [atb(def), pre, en]
-l            with lemmas
-v            with vowels
-oov          print oov instead of NNP for oov words
-ct           with collapse tags
-cc           with collapse chars
-rp						replace puncs with pp... so that MT wont go crazy
-help         print this message
-normy        normalize y: Elyhm -> ElY + hm
-normp        normalize p: xTthm -> xTp + hm
-log          output log file

EOF
  exit;
}



############ setting the defaults

my $outfile = "";
my $include_lemmas = 0;
my $include_vowels = 0;
my $do_collapse_tags = 0;
my $do_collapse_chars = 0;
my $do_replace_puncs = 0;
my $use_nnp_heur = 1;
my $include_patterns = 0;
my $buckout = "";
my $norm_y = 0;
my $norm_p = 0;
my $DOLOG = 0;
my $scheme = "atb";

#not sure about its usage!
my $whichatb = 2;

############## parsing parameters
my $ok =0;

while (@ARGV) {
  my $arg = shift @ARGV;

  ### -l
  if ($arg eq "-l") {
    $include_lemmas = 1;
  }
  ### -a
  elsif ($arg eq "-s") {
    $scheme = shift @ARGV;
  }
  ### -v
  elsif ($arg eq "-v") {
    $include_vowels = 1;
  }
  ### -oov
  elsif ($arg eq "-oov") {
    $use_nnp_heur = 0;
  }
  ### -cc
  elsif ($arg eq "-cc") {
    $do_collapse_chars = 1;
  }
  ### -ct
  elsif ($arg eq "-ct") {
    $do_collapse_tags = 1;
  }
  elsif ($arg eq "-rp") {
    $do_replace_puncs = 1;
  }
  ### -p
  elsif ($arg eq "-p") {
    $include_patterns = 1;
  }
  ### -normy
  elsif ($arg eq "-normy") {
    $norm_y = 1;
  }
  ### -normp
  elsif ($arg eq "-normp") {
    $norm_p = 1;
  }
  ### -log
  elsif ($arg eq "-log") {
    $DOLOG = 1;
  }
  ### not an option - we got to the required parameters
  else {
    die "Unknown option '$arg'; type $0 -help for information\n"
      if ($arg =~ /^-/);
    $buckout = $arg;
    die "$buckout was not found\n" unless -e $buckout;
	
	if (@ARGV == 1){
		$outfile = shift @ARGV;
		#die "$outfile was not found\n" unless -e $outfile;
	}
	else{
		$outfile = "$buckout-roy_";
		if ($include_lemmas){
			#$outfile.="+l";
		}
		else{
			#$outfile.="-l";
		}
		if ($include_vowels){
			#$outfile.="+v";
		}
		else{
			#$outfile.="-v";
		}
		if ($do_collapse_tags){
			$outfile.="+ct";
		}
		else{
			$outfile.="-ct";
		}
		if ($do_collapse_chars){
			$outfile.="+cc";
		}
		else{
			$outfile.="-cc";
		}
		if ($include_patterns){
			#$outfile.="+p";
		}
		else{
			#$outfile.="-p";
		}
	}
	
  } 
}

if (not @ARGV){
	$ok = 1;
}

unless ($ok) {
  die "wrong arguments ;  type $0 -help for information\n"; 
}

open(BUCKBT, "perl -I$TOOLSDIR $TOOLSDIR/splitTXT.pl < $buckout |") or die "can't open $buckout: $!";
print STDERR "DOLOG=$DOLOG\n";
$DOLOG and ( open(LOG, ">$outfile\.log") or die "can't create $outfile\.log: $!" );
open(OUT, ">$outfile") or die "can't open file $outfile: $!";

#statistics variables
my $numanalyses = 0;			#number of different solutions of the words after the collapse
my $numuncollapsed = 0;		#number of uncollapsed solutions/analyses
my $numambiguouswords = 0;	#number of words that has ambiguous solutions in the sense that MT can't map tags to morphs
my $numstrings = 0;			  #number of strings
my $numarabicstrings = 0;				#number of arabic words
my $numotherstrings = 0;				#number of arabic words
my $numunknown = 0;				#unanalyzed words
my $sentencenum = 0;			#numbe of sentence currently being analyzed
my $numnotchosensol = 0;		#number of words with solutions but no one was chosen
my %numanalyses_numwords = ();	#how many words had n collapsed analyses
my %numsegments_numanal = ();	#how many analyses had n given number of segments
my %numsegments_numwords = ();	#how many different segments a word had

my $PRINTPROGRESSEVERY = 1000; #every # progress message printed
my $BIGPRINTPROGRESSEVERY = 50*$PRINTPROGRESSEVERY;

#my %tags = ();
my %morphtags = ();
my %tagmorphs = ();


my $NUMTAG = "NUM";
if ($do_collapse_tags){
	$NUMTAG = "CD";
}

	while(!eof(BUCKBT)){
		$_ = <BUCKBT>;
		chop;
		
		if (/^#\s*$/){
            if (++$sentencenum % $PRINTPROGRESSEVERY == 0) {
                print STDERR ".";
           }
           if ($sentencenum % $BIGPRINTPROGRESSEVERY == 0) {
                        print STDERR "[$sentencenum]\n";
           }
			
			print OUT "</sentence>\n";			
		}
		elsif (/INPUT STRING:\s*(.+)/){
		
		my $arword = $1;
		$arword =~ s/\s//g;
		
		#read next, should be lookup word, or comment
		$_ = <BUCKBT>;
		chop;
		
		$numstrings++;		#this is total number
		my ($isarabic, $word) = (0,"");
		
		if (/LOOK-UP WORD:\s+(.+)$/) {	
				$word = $1;
				$word =~ s/\s//g;
				#read comment
				$_ = <BUCKBT>;
				if (!/Comment:/){
					print STDERR "didnt find Comment: after $_\n";
				}
				$isarabic = 1;
		}
		else{	$word = $arword	};
		
		
		my $worddf = $word;
		if ($do_collapse_chars){
			$worddf = DEF_FORMAT($word); #word with defualt format
		}
		
		
		#push(@bucktokens,$word);
		
		#$bucklength+=length $word;
		#$bucktokennum++;	#this is current line of buck
		my $isokfornewline = 0;
		
	
		if ($isarabic) {
			if ($do_collapse_chars){ 
			 	print OUT REMOVEMARKSWORD($word),"\n";
			}else{
			 		print OUT $word,"\n";
			}
			$numarabicstrings++;
		}
		#print OUT $word,"\n";	$numarabicwords++;}
		else {
			print OUT HEX_TO_CHAR($word),"\n";
			$numotherstrings++;
		}
		
		my @solutions = (); my ($num_sol,$ischosensol) = (0,0);
		my $isendsen = 0;
		#2.6.08 added handling of alternatives in BAMA. reason: GALE Y-y confusion.
		#alternatives are not marked. maybe they should?
		while(($_=<BUCKBT>)=~/^\s*\*?\s*SOLUTION \d+:\s*(\S+)\s+(\S+\s+)?(\S+)\s*$/ 
		    or $_=~/^\s*ALTERNATIVE:\s*\S+\s*$/ ) {
                        #print STDERR "$_";
			next if ($_=~/^\s*ALTERNATIVE:\s*\S+\s*$/);
			my ($vword, $lemma, $analysis) = ($1,$2,$3);
			$analysis =~ s/\s//g;
			if ($analysis =~ /\/((NUM)|(PUNC))/ and $analysis !~ /[A-Za-z][^\/]*\/NUM/){
				$analysis =~ /^(.+)\/(.+)$/;
				my ($morph,$tag) = ($1,$2);
				#print STDERR "$analysis --- $morph --- $tag\n";
				if ($tag eq "PUNC"){
					#print OUT "\t\t\(PUNC $morph)\n";
					if ($do_replace_puncs){
						$solutions[$num_sol] .= "(PUNC ".REMOVEMARKSPUNC($morph).")";
					}
					else{
						$solutions[$num_sol] .= "(PUNC $morph)";
					}
					$tagmorphs{"PUNC"}{$morph} =1;
				}			
				
				if ($tag eq "PUNC" and $morph =~ [0-9]){
					print STDERR "unexpected: $tag --- $morph\n";
				}
				
				if ($tag eq "NUM"){
					#print OUT "\t\t($NUMTAG $morph)\n";
					$solutions[$num_sol] .= "($NUMTAG $morph)";
					$tagmorphs{$NUMTAG}{$morph} =1;			
				}
				goto AFTERSEP;		
			}
			
			
			#if ($whichatb != 1){
			#7.12.07.11.40
			#always do this
            #02.03.2010, added a flag
            if (! $norm_p){
				$analysis=~s/(.+\+)ap(\/NSUFF_FEM_SG\+.+\/POSS_PRON.+)$/$1at$2/;
            }
			#}
			#remove trailing space
			$lemma =~ s/\s+$//;
            if ($norm_y){
                if ($lemma =~ /Y_\d+/ and $analysis =~ /y\/\S+?\+\S+?\/[^\/]*PRON/){
                    $analysis =~ s/y\//Y\//;
                }
            }
			
			$ischosensol=1 if $_=~/\*\s*SOLUTION/;			
						
			#do automatic seperation taken from processClitics
			my @tagmorphs = ();
			
			$analysis = MATCH_ANALYSIS($analysis);
			
			#whichatb is not used anymore in PERFORM_AUTO_SEP
			PERFORM_AUTO_SEP($analysis,\@tagmorphs,$scheme);
			
			my $lastl = "";
			my $lemma_assigned = 0;
			foreach my $tagmorph (@tagmorphs){
				$tagmorph =~ /^\((.+) (.+)\)$/;
				my ($tag,$morph) = ($1,$2);
				$morph =~ s/\(nll\)//;
				$morph =~ s/\(null\)//;
				if ($morph=~/^~[aiueo~`FNK+]+$/){
                    $lastl =~ s/Y/y/;
					$morph =~ s/\~/\Q$lastl\E/;
					#print LOG "Exchanged ~ at sentence #$sentencenum: $tagmorph\n";
				}
				
				my $pattern = "";
				if ($tag ne "CD" and $tag ne "NUM"){
					$pattern = GET_VOWELS_PATTERN($morph);
				}
				
				my $mtag = MATCH_TAG($tag);
				
				if (!$include_vowels and $mtag ne 'NON_ARABIC' and $mtag ne "LATIN" and $mtag ne 'PUNC' and $morph!~/\d/ ){
					#remove vowels
					$morph =~ s/[aiueo~`FNK+]//g;
				}
				
				my $cmtag = $mtag;
				if ($do_collapse_tags){
					$cmtag = $COLLAPSEHASH{$mtag};
					if (length($cmtag)==0){
						$DOLOG && print LOG "NOCOLLAPSE\t$tagmorph\n";
						$numuncollapsed++;
					}
				}
			
				if ( ( ($do_collapse_tags and STR_PIN_LIST($cmtag,\@SIGTAGSCOLL) )
						or (!$do_collapse_tags and STR_PIN_LIST($cmtag,\@SIGTAGS) ) )
					and $morph!~/\d/ ){
					
					if ($include_lemmas and $lemma){
						$lemma =~ s/\[|\]//g;
						$lemma =~ s/_//g;
						#$lemma =~ s/[aiueo~`FNK+_]//g;
						$cmtag = $lemma."+".$cmtag;
						$lemma_assigned = 1;
					}
					if ($include_patterns and $pattern){
						$cmtag = $pattern."+".$cmtag;
					}
					
				}
							
				if (length($morph)==0 or length($cmtag)==0){
					$DOLOG && print LOG "EMPTY MORPH/TAG\tsentence #$sentencenum: $tagmorph\n";
					$cmtag = $mtag;
				}
				
				#if (!$isarabic){
				#	$morph = REMOVEMARKSPUNC($morph);
				#}
				
				if ($do_collapse_chars){
					$morph = REMOVEMARKS($morph,$isarabic);
				}
				
				$solutions[$num_sol] .= "($cmtag $morph) ";
				$tagmorphs{$cmtag}{$morph} =1;
				$lastl = substr($morph,-1);
				
			}
			
			
AFTERSEP:
			$num_sol++;
			#eat the glossary line
			$_ = <BUCKBT>;
			last if (/^s*$/);
			if (!/\(GLOSS\)/ and $isarabic){
				print STDERR "GLOSS missing\n";
			}
		}
		
		if ($_ =~ /^\s*#\s*$/){
			$isendsen = 1;
		}
		
		#$numnotchosensol++,print ERROR "NO CHOSEN SOL $word\n" if !$ischosensol and $num_sol>0 ;
		
		#remove duplicates
		my %saw = ();
		@solutions = grep(!$saw{$_}++, @solutions);
		
		#check is there is ambigious solutions in @solutions in the sense of MT
		if (!$include_vowels and check_ambig_sol(@solutions)){
			$numambiguouswords++;
			$DOLOG && print LOG "AMBIGSOL\tword: ($word), solutions: ". join("\t",@solutions) . "\n";
		}
			
		
		#print the solutions
		foreach my $solution (@solutions) {			
			if ($solution!~/\(.+?\s+\)\s*$/){
				#update the number of words with the current number of segments
				my @morphs = ($solution =~ /\(.+? (.+?)\)/g);
				$numsegments_numanal{@morphs}++ if $isarabic;
				#chop $solution;
				#remove trailing spaces if present
				$solution =~ s/\s+$//;
				print OUT "\t";
				printAnalyses($solution);
			}
			else{
				$DOLOG && print LOG "EMPTY_MORPHEME_SOLUTION\t#$sentencenum: word - [$word], solution [$solution]\n";
			}
		}
		
		$numanalyses+=@solutions;
		
		#update number of words with the current number of solutions 
		$numanalyses_numwords{@solutions}++ if $isarabic;
		
		#update number of words with the current number of different segmentations
		$numsegments_numwords{num_diff_seg(@solutions)}++ if $isarabic;
		
		#assume words without solutions as NNP or PUNC sometimes
		#changed to XXX
                #print STDERR "found $num_sol for $worddf\n";
                if ($num_sol==0) {
                    $DOLOG && print LOG "0 solutions for $worddf\n";
			$numsegments_numanal{1}++ if $isarabic;
			if (   $worddf =~ /[\?\"\.\,\!\:\;\+\%\(\)\[\]\_]/
				or $worddf =~ /^\s*\*\s*$/
				or $worddf =~ /^\s*\>\s*$/
				or $worddf =~ /^\s*\<\s*$/
				or $worddf =~ /^\s*\{\s*$/
				or $worddf =~ /^\s*\}\s*$/
				or $worddf =~ /^\s*\&\s*$/ ){
				#print OUT "\t(PUNC ".REMOVEMARKSPUNC($worddf).")\n";
				print OUT "\t";
				printAnalyses("(PUNC $worddf)");
				
				$DOLOG && print LOG "NOSOL\tPUNC $worddf\n";
				$tagmorphs{"PUNC"}{$worddf} =1;
				
			}
			else{
				$numunknown++;
				#print OUT "\t(NNP ".REMOVEMARKSWORD($word).")\n";
				#print LOG "NOSOL\t", REMOVEMARKSWORD($word),"\n";
				if ($use_nnp_heur){
					print OUT "\t";
					printAnalyses("(NNP $word)");
				}
				else{
					print OUT "\t";
					printAnalyses("(OOV $word)");
				}
				$DOLOG && print LOG "NOSOL\t", $word,"\n";
				$tagmorphs{"OOV"}{$word} =1;
			}
		}
		
		if ($isendsen){
            if (++$sentencenum % $PRINTPROGRESSEVERY == 0) {
                print STDERR ".";
           }
           if ($sentencenum % $BIGPRINTPROGRESSEVERY == 0) {
                        print STDERR "[$sentencenum]\n";
           }
		#	if ($sentencenum % $PRINTPROGRESSEVERY == 0){
		#		print STDERR "[$sentencenum]"; 
  		#	}			
			#print STDERR "Finished processing sentence: $sentencenum\r";
			print OUT "</sentence>\n";
			$sentencenum++;
		}
			
		}#end if INPUT
		
	}

print STDERR "\n";
#print the statistics
if ($DOLOG){
print LOG	"#Strings   : $numstrings\n",
          "#Arabic    : $numarabicstrings\n",
          "#Other     : $numotherstrings\n",
			    "#OOV       : $numunknown\n",			
			    "Ambig Words: ",$numambiguouswords/$numarabicstrings,"\n",
			    "Uncollapsed: ",$numuncollapsed/$numanalyses,"\n",
			    "No Correct : $numnotchosensol\n";

foreach my $tag (sort keys %tagmorphs){
	print LOG "$tag ";
}
print LOG "\n\n";


print LOG "##################TAGMORPHS###############\n";
foreach my $tag (sort keys %tagmorphs){
	print LOG "$tag\n";
	print LOG "\t";
	if (length keys %{ $tagmorphs{$tag} } > 500){
		print LOG ">100";
		next;
	}
	foreach my $morph (keys %{ $tagmorphs{$tag} } ){
		print LOG "$morph ";
	}
	print LOG "\n";
}


my ($sum,$msum)=(0,0);
foreach my $numanal (sort keys %numanalyses_numwords){
	$sum+=max(1,$numanal)*$numanalyses_numwords{$numanal};$msum+=$numanalyses_numwords{$numanal};
	print LOG "$numanal anlyses: $numanalyses_numwords{$numanal}\n";
}
print LOG "average analyses:",$sum/$msum,"\n";


my ($sum,$msum) = (0,0);
foreach my $numseg (sort keys %numsegments_numwords){
	$sum+=$numseg*$numsegments_numwords{$numseg};$msum+=$numsegments_numwords{$numseg};
	print LOG "words with $numseg different segments: $numsegments_numwords{$numseg}\n";
}
print LOG "average number of different segments per word:",$sum/$msum,"\n";


my $sum = 0, $msum=0;
foreach my $numseg (sort keys %numsegments_numanal){
	$sum+=max(1,$numseg)*$numsegments_numanal{$numseg};$msum+=$numsegments_numanal{$numseg};
	print LOG "$numseg segments: $numsegments_numanal{$numseg}\n";
}
print LOG "average segments:",$sum/$msum,"\n";
close(LOG);
}


close(OUT);
close(BUCKBT);

##########################################################
sub max{
	my ($a,$b) = @_;
	return ($a>$b)?$a:$b;
}

##########################################################
sub num_diff_seg{
	my @solutions = @_;
	return 1 if @solutions==0;
	my %hash = ();
	foreach my $solution (@solutions){
		my @morphs = ($solution =~ /\(.+? (.+?)\)/g);
		my $morphs = join(" ",@morphs);
		$hash{$morphs} = 1;
	}
	my @hash = keys %hash;
	return @hash;
}

#################################################################

sub REMOVEMARKS{
	my ($word,$isarabic) = @_;
	
	if ($isarabic) {
		return REMOVEMARKSWORD($word);
	}
	else {
		return REMOVEMARKSPUNC($word);
	}
}



#################################################################

#make all the formats the same so we can match
sub def_format{
	my ($word) = @_;
#	$word =~ s/\{/A/g;	
#	$word =~ s/Y/y/g;	
#	$word =~ s/p/t/g;	
#	$word =~ s/\</A/g;	
#	$word =~ s/\>/A/g;	
#	$word =~ s/Y'/\}/g;	
#	$word =~ s/y'/\}/g;	
#	$word =~ s/w'/\&/g;
	
	$word =~ s/\xA1/\,/g;	
	$word =~ s/\xD8\x8C/\,/g;
	$word =~ s/\xBF/\?/g;
	#$word =~ s/\x1F\x06/\?/g;
	$word =~ s/\xD8\x9F/\?/g;
	$word =~ s/\xDC/\_/g;
	$word =~ s/\xF6/\_/g;	#atb2
	$word =~ s/\xD9\x80/\_/g;
	$word =~ s/\xD9\x8B/\_/g;
	return $word;
}
#################################################################


sub hextopunc {
	my $word = shift;	
	
	$word =~ s/\xA1/\,/g;	#atb3
	$word =~ s/\xBF/\?/g;	#atb3
	$word =~ s/\xDC/\_/g;
	$word =~ s/\xF0/r/g;	#atb3, F0 is a noncharacter in utf8
	return $word;
}


#################################################################

sub check_ambig_sol{
	my @solutions = @_;
	my $isambig = 0;
	for(my $i=0;$i<@solutions;$i++){
		for(my $j=$i+1;$j<@solutions;$j++){
			my @tagsi = ($solutions[$i] =~ /\((.+?) .+?\)/g);
			my $tagsi = join(" ",@tagsi);
			my @tagsj = ($solutions[$j] =~ /\((.+?) .+?\)/g);
			my $tagsj = join(" ",@tagsj);
			if ($tagsi eq $tagsj){
				#print ERROR "ambiguity with tags: $solutions[$i] -- $solutions[$j]\n";
				$isambig = 1;
			}
		}
	}
	
	return $isambig;
}


###################################################
sub printAnalyses{
	my $anal = shift;
	if ($anal =~ /PUNC|FW|NON_ARABIC|LATIN|CD|NUM/){
		$anal =~ /\((\S+) (\S+)\)/;
		my ($tag,$morph) = ($1,$2);
		if ($do_replace_puncs){			
			print OUT "($tag ".REMOVEMARKSPUNC($morph).")\n";
		}
		else{
			print OUT "($tag $morph)\n";
		}
	}
	else{
		my @morphs = ($anal =~ /\(\S+ (\S+)\)/g);
		my @tags = ($anal =~ /\((\S+) \S+\)/g);
		
		my $toprint = "";
		for(my $i=0; $i<@tags; $i++){
			if ($do_collapse_chars){
				$toprint .= "(" . $tags[$i] . " " . REMOVEMARKSWORD($morphs[$i]) .") ";
			}
			else{
				$toprint .= "(" . $tags[$i] . " " . $morphs[$i] . ") ";
			}
		}
		chop $toprint;
		print OUT "$toprint\n";
	}
}

