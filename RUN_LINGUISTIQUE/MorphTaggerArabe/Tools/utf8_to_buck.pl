
use atb_common;

my $englishalphabet = 0;
my $reverse = 0;
if ($ARGV[0] eq '-eab'){
	$englishalphabet = 1;
	shift @ARGV;
}
elsif ($ARGV[0] eq '-r'){
	$reverse = 1;
	shift @ARGV;
}

if ($reverse){
	binmode(STDOUT, ":utf8");
}
else {
	binmode(STDIN, ":utf8");
}

while(<>){
	chomp;
	if ( /^\s*$/ ) {
 	  print "\@emptyline\@\n";
	  next;
	}
	my $toprint = "";
	if ($reverse) {
		$toprint = BUCK_TO_UTF8($_);
	}
	else {
		$toprint = ($englishalphabet)?UTF8_TO_BUCK_EAB($_):UTF8_TO_BUCK($_);
	}
	print $toprint;
	print "\n";
}
