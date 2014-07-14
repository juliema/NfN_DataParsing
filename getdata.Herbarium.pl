#!usr/bin/env perl

use strict;
use warnings;

my $inputfile = shift;
my $database = shift;

my $skipped=0;
my $notskipped=0;
my $linenum=0;
my %collectorhash=();
my @collectorarray =();
my $numcollectors=0;
my $numtranscriptions=0;
my %countryhash=();
my $numcountries=0;
my @countryarray=();

#open FH, "<MASTER2014-06-15_notes_from_nature_herbarium_classifications.csv";
open FH, "<$inputfile";
while (<FH>) {
    $linenum++;
    my $line=$_;
    #### remove commas in quotations so can split line by comma
    while ($line =~ /^(.*?)"(.*?)"(.*)$/) {
	my $first=$1;
	    my $temp = $2;
	my $end = $3;
	$temp=~ s/,/_/g; 
	$line = $first . $temp . $end; 
    }
    #skip header row
    if ($line =~ m/id,collection,subject_id/) { 
	# print "$line\n\n"; 
    }
    #### finding skipped entries
    elsif ($line =~ m/,true,/) {
	$skipped++;
    }
    ### finding empty but not skipped lines
    elsif ($line =~ /,,,,,,,,,,,,,.*20\d\d.*/) {
	$notskipped++;
    }
    else {
	$numtranscriptions++;
	my @array = split(/,/,$line);
	my $collector = $array[4];
#	print "$collector\n";
	if (! exists $collectorhash{$collector}) {
	    $collectorhash{$collector}=1; 
	    push @collectorarray, $collector; 
	    $numcollectors++;
	}
	else {  $collectorhash{$collector}++;}
	my $coldate = $array[7];
	my $country = $array[9];
	my $county = $array[10];
	if (! exists $countryhash{$country}) { $countryhash{$country}=1; $numcountries++; push @countryarray, $country; }
	elsif (exists $countryhash{$country}) { $countryhash{$country}++; }
	my $state = $array[15];
	my $startime = $array[18];
	my $endtime = $array[19];
#	print "$collector\t$endtime\n";
    }
}


print "There are $linenum entries in the file\n";
print "There are $skipped skipped records, $notskipped empty records\n";
print "There are $numcollectors unique collectors and $numtranscriptions non-empty transcriptions\n";
print "There are $numcountries countries represented\n";

open OUT, ">$database.CollectorData.txt";
open OUT1, ">$database.CountryData.txt";
for my $collector (@collectorarray) {
    if ($collector ne "") {
#    print "$collector\n";
    print OUT "$collector\t$collectorhash{$collector}\n"; 
    }
}
for my $country (@countryarray ) { print OUT1 "$country\t$countryhash{$country}\n"; }
