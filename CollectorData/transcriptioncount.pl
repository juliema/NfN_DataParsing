#!usr/bin/env perl

use strict;
use warnings;

my $upperlimit=10;

my %transcriptionhash=();
my @transcriptionarray=();
my $total=0;
my $totaltranscriptions=0;


open FH, "<Master.Transcriber.info.txt";
while (<FH>) {
    if (/.*\s+(\d+)/) {
	my $numtranscriptions=$1;
	$totaltranscriptions=$totaltranscriptions+$numtranscriptions;
	if (! exists $transcriptionhash{$numtranscriptions}) { $transcriptionhash{$numtranscriptions}=1; push @transcriptionarray, $numtranscriptions; }
	elsif (exists $transcriptionhash{$numtranscriptions}) { $transcriptionhash{$numtranscriptions}++; }
    }
}

open OUT, ">TranscribersperNumberofTranscriptions.txt";
print OUT "NumTranscriptions\tNumTranscribers\n";

for (1..$upperlimit) {
    my $num=$_;

    if ($transcriptionhash{$num} != "") {
	print OUT "$num\t$transcriptionhash{$num}\n";
	print  "$num\t$transcriptionhash{$num}\n";
	$total=$total+$transcriptionhash{$num};
    }
    else {
	print OUT "$num\t0\n";
	print  "$num\t0\n";
    }
}

print "$total in $upperlimit\n";
print "$totaltranscriptions\n";
