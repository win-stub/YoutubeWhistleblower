use strict;
use warnings;
use Encode;
binmode STDIN,":utf8";
while(<>) {
	$_=Encode::encode("utf8",$_);
	Encode::from_to($_,"utf8","cp1256");
	print $_;
}
