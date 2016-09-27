#!/usr/local/bin/perl 

require "getopts.pl";
require "ctime.pl";

use lib "..";

use atb_common;

$p = 1;

while (<>) {
    chop;

		if (/^\s*\#\s*$/) {
			print "#\n";
			next;
		}
    elsif (/^INPUT STRING: (.*)/) {
		#s/\xd8\x8c/ZZZ/g;
		#s/\xA1/,/g;
		#s/\xBF/?/g;
		$_ = HEX_TO_CHAR($_);
        if (/[\xa0-\xfe]/) {
			#s/ZZZ/\xd8\x8c/g;
			$p = 1;
		}
		else {
			$p = 0;
			$tmp = $_;
			$tmp =~ s/^INPUT STRING: //g;
			#7.12.07.11.35
			#added ".," here, and commented out the lines below
			$tmp =~ s/([\!\@\#\$\%\^\&\*\(\)\-\+\_\=\|\\\;\:\"\'\{\}\[\]\~\`\<\>\?\/\.,])/ $1 /g;
			$tmp =~ s/^\s+//g;
			$tmp =~ s/\s+$//g;
			#$tmp =~ s/ZZZ$/ ZZZ/g;
			#$tmp =~ s/(\d+)\.\s+/$1 . /g;
			#$tmp =~ s/(\d+)\.$/$1 ./g;
			#$tmp =~ s/\.(\d+)/.$1 /g;
			#$tmp =~ s/\s+$//g;
			#$tmp =~ s/([a-zA-Z])\./$1 ./g;
			#$tmp =~ s/\.([a-zA-Z])/. $1/g;
			#$tmp =~ s/\s\.\.(\d+)/ . .$1/g;
			#$tmp =~ s/\s\.\.\.(\d+)/ ... $1/g;
			#$tmp =~ s/\,\./, ./g;
			#$tmp =~ s/(\w+)\,\s+/$1 , /g;
			#$tmp =~ s/ZZZ/\xd8\x8c/g;
			$tmp =~ s/\s+/ /g;
			foreach $i (split(" ", $tmp)) {
				# print "token: $i to be considered\n";
				print "INPUT STRING: $i\n";
				$_ = $i;
				if ((/^\d+$/) or (/^\d+[\,\.]\d+$/) or (/^\d+\xd8\x8c\d+$/) or (/^\.\d+$/)) {
					print "     Comment: NUMERICAL\n";
					$i =~ s/\xd8\x8c/:/g;
					print "* SOLUTION 1: () $i/NUM\n";
					print "\n";
				} else {
					if (/[A-Za-z]/) {
					print "     Comment: NON_ALPHABETIC_DATA\n";
					print "* SOLUTION 1: () $i/NON_ARABIC\n";
					print "\n";
					} else {
					print "     Comment: PUNCTUATION\n";
					$i =~ s/\xd8\x8c/,/g;
					print "* SOLUTION 1: () $i/PUNC\n";
					print "\n";
					}
				}
			}
		}
    }
    
    if ($p == 1) {
		print $_, "\n";
    }
}

