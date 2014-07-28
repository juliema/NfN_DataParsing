#!usr/bin/env perl

use strict;
use warnings;

my %transcriberhash=();
my @transcriberarray=();
my $total=0;
my $totaltranscriptions=0;

system "ls -l *.txt >filenames";

open OUT, ">Master.Transcriber.info.txt";
open FH, "<filenames"; 
while (<FH>) {
    if (/(\S+).CollectorData.txt/) {
	my $collection=$1;
	print "$collection";
	open FH1, "<$collection.CollectorData.txt";
	while (<FH1>) {
	    if (/(\S+)\s+(\d+)$/) {
		my $transcriber=$1;
		my $numtranscriptions=$2;
		$totaltranscriptions=$totaltranscriptions+$numtranscriptions;
		if (! exists $transcriberhash{$transcriber}) {
		    $transcriberhash{$transcriber}=$numtranscriptions;
		    push @transcriberarray, $transcriber;
		    $total++;
		}
		elsif ( exists $transcriberhash{$transcriber}) {
#		    print "$transcriber\t$transcriberhash{$transcriber}\t$numtranscriptions\t";
		    $transcriberhash{$transcriber}=$transcriberhash{$transcriber}+$numtranscriptions;
#		    print "$transcriberhash{$transcriber}\n";
		}

	    }
	}
    }
}

for my $transcriber(@transcriberarray) {
    print OUT "$transcriber\t$transcriberhash{$transcriber}\n";
    print  "$transcriber\t$transcriberhash{$transcriber}\n";
}

print "There are $total transcribers and $totaltranscriptions transcriptions\n";
