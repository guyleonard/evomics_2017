#!/usr/bin/perl -w

use strict;
my $usage = "Input SNP comparison file\n";
my $inputfile = shift or die $usage;

open(INFILE, $inputfile) or die "Cannot open $inputfile\n";
my $counter=0;
my $MAX=0;
our %results;
our %ids;
while(<INFILE>){
	if($counter==0 ){
		$counter++;
		next;
	}
	if($counter==1){
		$MAX=samplenumber($_);
		my $x = $MAX-1;
		warn "Detected $x samples\n";
				
	}else{
		my $refbase="error";
		my @entries = split("\t",$_);
		my $silent = $entries[$MAX+2];
		#my $silent_flag = 1;
		
		if(!defined $silent || ($_=~/,non-silent/ || $_=~/,indel/i)){
			next;
			#Skip non-synonymous snps
		}
		for(my $i=2;$i<=$MAX;$i++){
			my $entry = $entries[$i];
			#$entry =~ s/\"//g;
			if($i==2){
				$refbase = $entry;
				my $name=$ids{$i};	
				$results{$name} = "$results{$name}"."$entry";
			}
			#$results{$i} = "$results{$i}"."$entry";
			else{
				
				
				my $name=$ids{$i};
	                        $results{$name} = "$results{$name}"."$entry";

			} 
			#$results{$i-2} = "$results{$i-2}"."$entry";	
		}		
		#print $_;
	}

	$counter++
}
close(INFILE);

foreach my $id (keys %results){
	print ">$id\n";
	my $seq = $results{$id};
	print "$seq\n";
}

sub samplenumber{
	my $sample = shift;
	my @samples = split("\t",$sample);
	my $counter=0;
	my $entries=0;
	foreach my $entry (@samples){
		#print "$entry\n";
		#$entry =~ s/\t//g;
		if($counter<2){
			$counter++;
			next;
		}
		elsif($entry!~/Gene description/){
			
			$results{$entry}="";
			$ids{$counter}=$entry;
			$entries++;
			 $counter++;
		}
		else{
			last;
		}
	}
	return $entries+1;

}

