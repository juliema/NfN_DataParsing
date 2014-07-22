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
    if ($line =~ m/id,collection,subject_id/) {}
    #### finding skipped entries
    elsif ($line =~ m/^.*,true,/) {
	$skipped++;
    }
    ### finding empty but not skipped lines
    elsif (/,,,,,,,,,,,,,.*20\d\d.*,/) {
	$notskipped++;
    }
    else {
	$numtranscriptions++;
	my @array = split(/,/,$line);
	my $collector = $array[4];
	if (! exists $collectorhash{$collector}) {  $collectorhash{$collector}=1; push @collectorarray, $collector; $numcollectors++;}
	else {  $collectorhash{$collector}++;}
	my $coldate = $array[7];
	my $startime = $array[13];
	my $endtime = $array[14];
    }
}


print "There are $linenum entries in the file\n";
print "There are $skipped skipped records, $notskipped empty records\n";
print "There are $numcollectors unique collectors and $numtranscriptions non-empty transcriptions\n";

open OUT, ">$database.Transcriptions.txt";
for my $collector (@collectorarray) { print OUT "$collector\t$collectorhash{$collector}\n"; }
