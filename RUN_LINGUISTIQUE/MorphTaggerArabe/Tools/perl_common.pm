package perl_common;

use strict;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(
  SUM
  STR_IN_LIST
  STR_PIN_LIST
);



#########################################################
sub STR_IN_LIST($$){
	my ($str,$lref) = @_;
	foreach my $elem (@$lref){
		return 1 if ($str eq $elem);
	}
	
	return 0;
}


#########################################################
#string proximity in list
sub STR_PIN_LIST($$){
	my ($str,$lref) = @_;
	foreach my $elem (@$lref){
		return 1 if ($str =~ /\Q$elem\E/);
	}
	
	return 0;
}


###########################################
#sum list
sub SUM{
	my @nums = @_;
	my $sum = 0;
	foreach my $num (@nums){
		$sum+=$num;
	}
	return $sum;
}



1;
