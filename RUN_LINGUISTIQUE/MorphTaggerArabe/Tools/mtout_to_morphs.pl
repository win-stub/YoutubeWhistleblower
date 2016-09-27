
use atb_common;
use perl_common;
use strict;

#add seperator to clitics
my $addsep = 0;
if ($ARGV[0] eq '-s'){
    $addsep = 1;
    shift @ARGV;
}
elsif ($ARGV[0] eq '-ia') {
    $addsep = 2;
    shift @ARGV;
}

print STDERR "adding sep __\n" if ($addsep);

while(<>){
	chop;
	if ( /^\s*$/ ) {
 	  print "\@emptyline\@\n";
	  next;
	}
	s/(^\s*\[)|(\]\s*$)//g;
	my @out = split(/\]\[/, $_);
	my @segs = ();
	foreach my $lout (@out){
		my @morphs = ($lout=~/\(\S+ (\S+)\)/g);
		my @tags = ($lout=~/\((\S+) \S+\)/g);
        if ($addsep == 1 and @morphs > 1){
            ADDSEP(\@morphs,\@tags);
        }
        elsif ($addsep == 2 and @morphs > 1){
            ADDSEPIA(\@morphs,\@tags);
        }
		foreach my $m (@morphs){
			my $t = shift(@tags);
			my $nm = $m;
			if ( $m ne "," and ($t =~ /PUNC|FW/ or $m =~ /[^\'|>&<}AbptvjHxd\*rzs\$SDTZEg_fqklmnhwYyFNKaui~o\`{PJRVG0-9]/ ) ) {
				#KeeP, dont convert to arabic utf8
				$nm = "<KP>".$nm."</KP>";
			}
			push(@segs, $nm);
		}
	}
	print join(" ", @segs);
	print "\n";
}


sub ADDSEPIA{
    #references to lists
    my $morphs = shift;
    my $tags = shift;
    
    #like transtac
    #my @prem = ('w','l','f','b','Al','s','k','ll');
    my @prem = ('s','k','wlhAl', 'wbhAl',
			  'fbAl', 'wbAl', 'whAl', 'wEAl', 'bhAl', 'lhAl',
			  'wll', 'wlA', 'wAl', 'bAl', 'hAl', 'EAl', 'fAl', 'fmA', 'wmA',
			  'll', 'wl', 'wb', 'w$', 'mw', 'mA', 'Al', 'lA', '$d',
			  'w', 'b', 'l', 'f', '$', 'd', 'E',);

    #my @sufm = ('hA','nA','h','hm','hmA','hn','hw');
    my @sufm = ('kmA', 'hmA',
			  'hn', 'kn', 'km', 'hA', 'hm', 'nA', 'ny',
			  'y', 'h', 'k', );


    for(my $i=0; $i<@$tags; $i++){
        if    ( $i<@$tags-1 and $$tags[$i] =~ /^(FUNC|DET)/ and STR_IN_LIST($$morphs[$i],\@prem) ){
            $$morphs[$i].="__";
        }
        elsif ( $$tags[$i] =~ /^(VB|NN|JJ|ADV)/ ){
            next;
        }
        elsif ( $$tags[$i] =~ /^(PRP)/ and STR_IN_LIST($$morphs[$i],\@sufm) ){
            $$morphs[$i] = "__" . $$morphs[$i];
        }
        else {
            #print STDERR "check this case: $$morphs[$i],$$tags[$i]\n"
        }
    }
    
    return;
}


sub ADDSEP{
    #references to lists
    my $morphs = shift;
    my $tags = shift;

    #'CC','DT','RP','IN','UH','PRP','PRPS'
    my @pret = ('CC','DT','IN','RP','UH',"PREP",
                  "NEG",
                  "SUBCONJ",
                  "DET",
                  "CONJ",
                  "INTERROG",
                  "PROG",
                  "EMPH",
                  "DET",
                  "FUT",);

    my @suft = ('PRP','PRPS',"PRON3P",
                  "PRON3FP",
                  "PRON2FP",
                  "PRON2MP",
                  "PRON3FS",
                  "PRON3MP",
                  "PRON1P",
                  "PRON1S",
                  "PRON3MS",
                  "PRON2FS",
                  "PRON2MS",);
    
    #like transtac
    #my @prem = ('w','l','f','b','Al','s','k','ll');
    my @prem = ('s','k','wlhAl', 'wbhAl',
			  'fbAl', 'wbAl', 'whAl', 'wEAl', 'bhAl', 'lhAl',
			  'wll', 'wlA', 'wAl', 'bAl', 'hAl', 'EAl', 'fAl', 'fmA', 'wmA',
			  'll', 'wl', 'wb', 'w\$', 'mw', 'mA', 'Al', 'lA', '\$d',
			  'w', 'b', 'l', 'f', '\$', 'd', );

    #my @sufm = ('hA','nA','h','hm','hmA','hn','hw');
    my @sufm = ('kmA', 'hmA',
			  'hn', 'kn', 'km', 'hA', 'hm', 'nA', 'ny',
			  'y', 'h', 'k', );


    #locate sigtag
    my $i=0; my @found = ();
    for($i=0; $i<@$tags; $i++){
        if ( STR_IN_LIST($$tags[$i],\@SIGTAGSCOLL) ){
            push @found, $i;
        }
    }
    
    if (@found > 1){
        die "hmm more than one significant tag: morphs=" . join(" ",@$morphs) . " tags=" . 
            join(" ",@$tags);
    }

    if (@found == 0){
        my $change = 0;
        for(my $i=0;$i<@$morphs;$i++){
            if ( STR_IN_LIST($$morphs[$i],\@prem) ){
                $$morphs[$i].= "__";
                $change++;
            }
            elsif ( STR_IN_LIST($$tags[$i],\@suft) ) {
                $$morphs[$i] = "__" . $$morphs[$i];
                $change++;
            }
        }
        if ( ! $change ){
            print STDERR "no change for " . join(" ",@$morphs) . " tags=" . join(" ",@$tags) . "\n";
        }        
        return;
    }

    
    #everything before $found[0] is m__, after __m
    for(my $j=0; $j<$found[0]; $j++){
        if ( ! STR_IN_LIST($$tags[$j],\@pret) ){
            die "hmm unexpected pre in morphs=" . join(" ",@$morphs) . " tags=" . 
            join(" ",@$tags);
        }
        $$morphs[$j] .= "__";
    }
    for (my $j=$found[0]+1; $j<@$morphs; $j++){
        if ( ! STR_IN_LIST($$tags[$j],\@suft) ){
            die "hmm unexpected suf in morphs=" . join(" ",@$morphs) . " tags=" . 
            join(" ",@$tags);
        }
        $$morphs[$j] = "__".$$morphs[$j];
    }
    
    return;
}
