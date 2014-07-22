#!usr/bin/env perl

use strict;
use warnings;

my $inputfile = shift;

my $skipped=0;
my $notskipped=0;
my $linenum=0;
my $numtranscriptions=0;
my $onecell=0;
my $twocells=0;
my $threecells=0;
my $fourcells=0;
my $fivecells=0;
my $countcells=0;
my %hourhash=();
my @hourarray=();
my $countfivecellstime=0;
my $noncountfivecells=0;

#open FH, "<MASTER2014-06-15_notes_from_nature_herbarium_classifications.csv";
open OUT, ">StartHour.Herbarium.txt";
open SINGLECELL, ">OneCellTime.Herbarium.txt";
open FULLRECORD, ">FiveCellsTime.Herbarium.txt";
open FH, "<$inputfile";
while (<FH>) {
    $linenum++;
    #skip header row
    if (/id,collection,subject_id/) {}
    #### finding skipped entries
    elsif (/^.*,TRUE,/) {
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
	### Find out how complete the record is, must have five entries filled in
	my @array = split(/,/,$line);
	my $county = $array[10];
	my $habitat = $array[11];
	my $location = $array[12];
	my $authority = $array[13];
	my $genus_species = $array[14];
	my $state = $array[15];
	my $startime = $array[18];
	my $endtime = $array[19];
	my @recordarray = ($county, $habitat, $location, $authority, $genus_species, $state);
	my $cells=0;
	for my $cell (@recordarray) {
	    if ($cell ne "") { $cells++; }
	}
	$startime =~ m/^(.*)\s+\d\d:/;
	my $Sdate = $1;
	$startime =~ m/(\d\d):(\d\d):(\d\d)/;  
	my $Shour=$1;  
	if (! exists $hourhash{$Shour})  {$hourhash{$Shour}=1; push @hourarray, $Shour;  }
	elsif (exists $hourhash{$Shour}) {$hourhash{$Shour}++;}
	my $Smin=$2; 
	my $Ssec=$3; 
	$endtime =~ m/^(.*)\s+\d\d:/;
	my $Edate = $1;
	$endtime =~ m/(\d\d):(\d\d):(\d\d)/; 
	my $Ehour=$1;
	my $Emin=$2;
	my $Esec=$3;
	if ($cells == 1) {	    
	    $onecell++;  
	    if ($startime ne "" && $endtime ne "") {
		if ($Sdate ne $Edate ) { #print "$startime\t$endtime\n"; 
		}
		if ($Shour == $Ehour) {  my $mintime = abs($Emin - $Smin); my $sectime = abs($Esec - $Emin);  my $time = ($mintime * 60) + $sectime; $countcells++; print SINGLECELL "$time\n";}
		elsif ($Shour == 24) { #print "$Shour\n"; 
		}
		else {
		    my $hourtime = $Ehour - $Shour;
		    if ($hourtime > 0) {
#			print "hourtime $hourtime, start $Ehour end $Shour\n";
		    }
		    if ($hourtime > 1) {
			my $mintime =  abs($Emin - $Smin); 
			my $sectime = abs($Esec - $Emin); 
			my $time = ($hourtime * 3600) + ($mintime * 60) + $sectime; 
			$countcells++; 
			print SINGLECELL "$time\n";
#			print "$time\n"; 
		    }
		    else {
			my $mintime =  abs($Emin - $Smin); 
			my $sectime = abs($Esec - $Emin); 
			my $time = ($mintime * 60) + $sectime; 
			$countcells++;
			print SINGLECELL "$time\n";
#			print "$time\n"; 
		    }
		}
	    }
	}
	elsif ($cells == 2) {
	    $twocells++;
	}
	elsif ($cells == 3) {
	    $threecells++;
	}
	elsif ($cells == 4) {
	    $fourcells++;
	}
	elsif ($cells == 5) {	    
	    if ($startime ne "" && $endtime ne "") {
		$fivecells++;
		my $hourtime = $Ehour - $Shour;
		if ($hourtime < 0) {  
		    if ($Shour == 24 && $Ehour == 0) { my $mintime = abs($Emin - $Smin); my $sectime = abs($Esec - $Emin);  my $time = ($mintime * 60) + $sectime; $countfivecellstime++;
						       print FULLRECORD "$time\n";
						       #print "five cells start min $Smin end min $Emin $mintime $sectime $time\n";
		    }
		    elsif ($Shour == 23 && $Ehour == 0) { my $hourseconds = 3600; my $mintime = abs($Emin - $Smin); my $sectime = abs($Esec - $Emin);  my $time = $hourseconds + ($mintime * 60) + $sectime; $countfivecellstime++; 
							  print FULLRECORD "$time\n";
							  #print "five cells start min $Smin end min $Emin $mintime $sectime $time\n";
		    }
		    elsif ($Shour == 24 && $Ehour == 1) { my $hourseconds = 3600; my $mintime = abs($Emin - $Smin); my $sectime = abs($Esec - $Emin);  my $time = $hourseconds + ($mintime * 60) + $sectime; $countfivecellstime++; 
							  print FULLRECORD "$time\n";
							  #print "five cells start min $Smin end min $Emin $mintime $sectime $time\n";
		    }
		    else { $noncountfivecells++; }
		}
		elsif ($hourtime == 0) {
		    my $mintime =  abs($Emin - $Smin); 
		    my $sectime = abs($Esec - $Emin); 
		    my $time = ($mintime * 60) + $sectime; 
#		    print "five cells $time\n";
		    print FULLRECORD "$time\n";
		    $countfivecellstime++;
		}
		elsif ($hourtime == 1) {
		    my $mintime =  abs($Emin - $Smin); 
		    my $sectime = abs($Esec - $Emin); 
		    my $time = ($mintime * 60) + $sectime; 
#		    print "five cells $time\n";
		    print FULLRECORD "$time\n";
		    $countfivecellstime++;
		}
		elsif ($hourtime > 1) {
		    my $mintime =  abs($Emin - $Smin); 
		    my $sectime = abs($Esec - $Emin); 
		    my $time = ($hourtime * 3600) + ($mintime * 60) + $sectime; 
#		    print "five cells $time\n";
		    $countfivecellstime++;
		    print FULLRECORD "$time\n";
		}
		else {
		    print "Other conditions $hourtime\t$Shour\t$Ehour\n";
		    $noncountfivecells++;
		}
	    }
	}
    }
}

print "There are $linenum entries in the file\n";
print "There are $skipped skipped records, $notskipped empty records\n";
my $nonemptycells = $linenum - $skipped - $notskipped;
print "$nonemptycells\n";

print "one cell $onecell\n";
print "two cells $twocells\n";
print "three cells $threecells\n";
print "four cells $fourcells\n";
print "five cells $fivecells. and $countfivecellstime counted and there are $noncountfivecells that were < 0 but not 24 or 23\n";

my $total=$onecell+$twocells+$threecells+$fourcells+$fivecells;
print "total $total\n";

print "there are $onecell onecells and $countcells calculated\n";

for my $hour (@hourarray) {
    print OUT  "$hour\t$hourhash{$hour}\n";
}
