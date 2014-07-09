#!usr/bin/env perl

use strict;
use warnings;

my $inputfile = shift;
#######################################################
#   1. skip columms with TRUE in skip 
#   2. Skip columns with nothing filled in
#    1. Records with at least one column in
#    1. Number of unique users
#    2. New file with users and num transcriptions
#   3. Get columns with KLMNOP Filled in
##
#######################################################


my $skipped=0;
my $notskipped=0;
my $linenum=0;
my %collectorhash=();
my @collectorarray =();
my $numcollectors=0;
my $numtranscriptions=0;
#open FH, "<MASTER2014-06-15_notes_from_nature_herbarium_classifications.csv";
open FH, "<$inputfile";
while (<FH>) {
    $linenum++;
    #### finding skipped lines
    if (/^.*,TRUE,/) {
	$skipped++;
    }
    ### finding empty but not skipped lines
    elsif (/,,,,,,,,,,,,,\".*20\d\d.*\",\".*20\d\d.*\",,$/) {
	$notskipped++;
    }
    else {
	my $line = $_;
	$numtranscriptions++;
	#### remove commas in quotations so can split line by comma
	while ($line =~ /^(.*?)"(.*?)"(.*)$/) {
	    my $first=$1;
	    my $temp = $2;
	    my $end = $3;
#	    print "$temp\n";
	    $temp=~ s/,/_/g; 
#	    print "$temp\n";
	    $line = $first . $temp . $end; 
	}
	my @array = split(/,/,$line);
	my $collector = $array[4];
	if (! exists $collectorhash{$collector}) {  $collectorhash{$collector}=1; push @collectorarray, $collector; $numcollectors++;}
	else {  $collectorhash{$collector}++;}
	my $coldate = $array[7];
	my $country = $array[9];
	my $county = $array[10];
	my $state = $array[15];
	my $startime = $array[18];
	my $endtime = $array[19];
#	print "$collector\t$endtime\n";
    }
}


print "There are $linenum entries in the file\n";
print "There are $skipped skipped records, $notskipped empty records\n";
print "There are $numcollectors unique collectors and $numtranscriptions non-empty transcriptions\n";

open OUT, ">Numberoftranscription.per.collector.txt";
for my $collector (@collectorarray) { print OUT "$collector\t$collectorhash{$collector}\n"; }
