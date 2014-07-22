#!usr/bin/env perl

use strict;
use warnings;

system "ls -l Report-*.txt >filenames";

my %allcountryhash=();
my $totalcountrynumbers=0;
my @allcountryarray=();
open FH, "<filenames";
while (<FH>) {
    if (/Report-(\S+)_Country.txt/) {
	my $collection=$1;
	open FH1, "<Report-$collection\_Country.txt";
	my $numcountries=0;
	my $totalrecords=0;
	my %collectioncountryhash=();
	my @collectionarray=();
	open OUT, ">$collection.Country.Clean.txt";
	print "\n\n$collection\n";
	while (<FH1>) {
	    if (/.*\s+(\d+)\s+(.*)\s+\S\S\s+/ && ! /verbatimcountry/) {
		my $num=$1;
		my $country=$2;
#		print "$country\t$num\n";
		if (! exists  $collectioncountryhash{$country}) { $collectioncountryhash{$country} = $num; $numcountries++; push @collectionarray, $country}
		elsif (exists $collectioncountryhash{$country}) { $collectioncountryhash{$country} = $collectioncountryhash{$country} + $num; }
		if (! exists $allcountryhash{$country}) { $allcountryhash{$country}=$num; $totalcountrynumbers++; push @allcountryarray, $country}
		elsif (exists $allcountryhash{$country}) { $allcountryhash{$country}=$allcountryhash{$country}+$num;}
	    }
	}
	for my $country (@collectionarray) { print OUT "$country\t$collectioncountryhash{$country}\n";}
	print "There are $numcountries in $collection\n";
    }
}

open OUT1, ">AllCollections.Country.txt";
for my $country (@allcountryarray) { print OUT1 "$country\t$allcountryhash{$country}\n";}
print "There are $totalcountrynumbers in the collections\n";
