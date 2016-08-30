#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
use Data::Dumper;
use Bio::DB::GFF;
my $usage = "<Min depth> <FASTA file> <GFF file> <VCF4 files to compare...>\n";
my $mindepth = shift or die $usage;
my $fastafile = shift or die $usage;
our $gfffile = shift or die $usage;
my @datasets = @ARGV;

my %seqs; 

my $genes_ref = parse_gff_file($gfffile);
my %genes = %$genes_ref;
my $seq_in  = Bio::SeqIO->new(
                              -format => 'fasta',
                              -file   => $fastafile,
                              );


while( my $seq = $seq_in->next_seq() ) {
	my $id = $seq->id;
	chomp $id;
	#print "$id\n";
	my $seqtxt = $seq->seq;
	#chomp $seqtxt;
	#foreach my $s (@sequence){
	#	print "$s";
	#}
	$seqs{$id}=$seqtxt;
	#print "$seqtxt\n";
	
}


my %results;
my %results_ref;
my %positions;
foreach my $file (@datasets) {
    warn "\nparsing file '$file'\n";
     
    open(FILE,"<$file") or die "Failed to open file '$file'\n$!\n";
    while (<FILE>) {
		if(/^\#/){
			next;
		}
		my @lines = split("\t");
		my $chrom = $lines[0];
		my $pos = $lines[1];
		my $id = $lines[2];
		my $ref = $lines[3];
		my $alt = $lines[4];
		my $qual = $lines[5];
		my $filter = $lines[6];
		my $info = $lines[8];
		my $depth = $lines[7];
		my $depth1=0;
		foreach my $line (@lines){
			#print "$line\t";
		}
		#print "\n";
		if($depth=~/DP\=(\d+)/){
			$depth1 = $1;
		}
		if($depth1<$mindepth){
			#next;
		}
		my $data = $lines[9];
		$results_ref{$chrom}{$pos}=$ref;
		$results{$file}{$chrom}{$pos}=$alt;
		$positions{$chrom}{$pos}=1;	

	}
	close(FILE);

}


print "\## Table of SNP and Indel occurences between these samples. Note that any comma-separated values (e.g. A,C indicate potential heterozygosity and/or sample heterogeneity\n";
print "Chrom\tPos\tRef\t";
foreach my $dataset (@datasets){
	print "$dataset\t";
}
print "Gene description\tStatus\n";


foreach my $chrom (sort(keys %positions)) {
	#print "$chrom\n";
	my $masterpos;
	foreach my $pos (sort(keys %{$positions{$chrom}})){
		print "$chrom\t$pos";	
		$masterpos=$pos;
		#my $ref = getBase($chrom,$pos,\%seqs);
		my $ref	= $results_ref{$chrom}{$pos};	
		print "\t$ref";
		my @status;
		foreach my $file (@datasets){
			if(exists $results{$file}{$chrom}{$pos}){
				my $alt = $results{$file}{$chrom}{$pos};
				my $from = $pos;
				my $to;
				if($alt=~/(\w+),/){
					$to = $from + length($1);
				}
				else{
					$to = $from + length($alt);
				}
				my @genes;
				foreach my $start (sort {$a<=>$b} keys %{$genes{$chrom}}) {
	    				foreach my $end (keys %{$genes{$chrom}{$start}}) {
	

						foreach my $gene_name (keys %{$genes{$chrom}{$start}{$end}}) {
						    #warn "\nIs it in $gene_name $id:$start-$end?\n";
						}

						if ($pos >= $start and
						    $pos <= $end) {
						    foreach my $gene_name (keys %{$genes{$chrom}{$start}{$end}}) {
							my $strand = $genes{$chrom}{$start}{$end}{$gene_name};
							push @genes, [$gene_name, $start, $end, $strand];
		  				  }		    
					}
	    		           }
				}
				if(length($ref)==1 && length($alt)==1){ 
					### Is this mutation silent with-respect to the gene?
					###Only use 1st allele
					my $alternative;
					$alternative=$alt;
					if($alternative=~/(\w+),/){
						$alternative=$1;
					}
					my ($gene2polymorphic_codons_ref, $gene2silent_ref) = 
					    is_it_silent(\@genes,
						 $seqs{$chrom},
						 $chrom,
						 $pos,
						 $ref,	
						 $alternative); 
	
					my %gene2polymorphic_codons = %{$gene2polymorphic_codons_ref};
					my %gene2silent = %{$gene2silent_ref};
					foreach my $gene (keys %gene2polymorphic_codons) {
					    my %polymorphic_codons = %{ $gene2polymorphic_codons{$gene} };
					    my $silent = $gene2silent{$gene};
					    foreach my $wt_codon (keys %polymorphic_codons) {
						if ($silent) {
						    #push @output, "silent: $gene_name ($start-$end $strand)";
						    push @status, "silent  $wt_codon -> $polymorphic_codons{$wt_codon}; ";
			
						} else {
						    #push @output, "non-silent: $gene_name ($start-$end $strand) ($protein_seq  -> 								$mutant_protein_seq) ($gene_seq -> $mutant_gene_seq)";
						    push @status, "non-silent $wt_codon -> $polymorphic_codons{$wt_codon};";
		    
						 }
	    			   

					   }
					}
				}
				else{
					push @status, "Indel";
				}	
					print "\t$alt";
				}else{
					print "\t$ref";
				}
			}
				
		my $gene = getGene($chrom,$masterpos);
		my $statuslistresult="";
		foreach my $statuslist (@status){
			chomp $statuslist;
			$statuslistresult=$statuslistresult.",".$statuslist;
		}
		chomp $statuslistresult;
		print "\t$gene\t$statuslistresult\n";
	}
}


foreach my $file (sort(keys %results)) {
	#print "$file\n";
} 

sub getBase{
	my $chrom = shift;
	my $pos = shift;
	my $seqsref = shift;
	my %seqs=%$seqsref;
	chomp $chrom;
	#print Dumper(%seqs);
	my $seq_txt = $seqs{$chrom};
	#print "\n$chrom\t$pos\n";
	#print "sequence: $seq_txt\n";
	my @s = split(//,$seq_txt);
	 
	return $s[$pos-1];
}

sub getGene{
	my $chrom=shift;
	my $pos = shift;
	my $feature = "CDS";
	#open(FILE,$gfffile);
	my $desc = "";
	foreach my $seqid (keys %genes){
		if($seqid eq $chrom){
			foreach my $mystart (keys %{$genes{$seqid}}){
				foreach my $myend (keys %{$genes{$seqid}{$mystart}}){
					if($pos>=$mystart && $pos<=$myend){
						foreach my $description (keys %{$genes{$seqid}{$mystart}{$myend}}){
							$desc=$desc." ".$description;	
						}
					}
				}
			}
		}
	}	
	chomp $desc;
	return $desc;


}

sub parse_gff_file{
    my $gff_file = shift or die;
    open (FILE, "<$gff_file") and 
	warn "Parsing GFF file '$gff_file'" or
	die "Failed to open $gff_file:$!\n" ;
    my %genes;
    while (<FILE>) {
	my @fields = split /\t/;
	if (@fields == 9) {
	    my ($seq_id, $source, $feature, $start, $end, $score, $strand, $frame, $attributes) = @fields;
	    if ($feature eq 'CDS' or $source eq 'CDS') {
		
		my ($gene_name,$desc);

		if ($attributes =~ /locus_tag=([\d\w]+);/i) {
		    $gene_name = $1;
		}
		elsif ($attributes =~ /ID=fig\|(.*)/i) {
		    $gene_name = $1;
		}
		

		if ($attributes =~ /product=(.*?);/i) {
		    $desc = $1;
		}
		elsif ($attributes =~ /Name=(.*)/i) {
		    $desc = $1;
		}
		elsif ($attributes =~ /Note\s+\"(\S+)\s+(.*)\"/i) {
		    $desc = $2;
		    $gene_name=$1
		}

		unless (defined $seq_id and defined $start and defined $end and defined $desc) {
		    warn "seq_id=$seq_id\n";
		    warn "start=$start\n";
		    warn "end=$end\n";
		    warn "desc=$desc\n";
		    warn "gene_name=$gene_name\n";
		    warn "@fields\n\n\n";
		}
		

		warn "$gene_name $seq_id:$start..$end $desc\n";
		$genes{$seq_id}{$start}{$end}{"$gene_name $desc"} = $strand;
		die "$start > $end\n" if $start > $end;
	    }
	}
	else {
	    #print STDERR "Ignoring line: $_\n" ;
	}
    }
    close FILE;
    return \%genes;
}
sub is_it_silent {
    my $genes_ref = shift or die;
    my $genome_seq = shift or die;
    my $genome_id = shift or die;
    my $position = shift or die;
    my $change_from = shift or die;
    my $change_to = shift or die;

    my @genes = @{$genes_ref};

    my %gene2polymorphic_codons;
    my %gene2silent;

    foreach my $gene_ref (@genes) {
	
	my ($gene_name, $start, $end, $strand) = @$gene_ref;

	### get DNA sequence of gene
	my $gene_seq = substr( $genome_seq, ($start-1), (1+$end-$start) );
	
	### get mutant version of gene sequence
	my $mutant_gene_seq;
		
	my $pos_wrt_gene = 1 + $position - $start;
	my $upstream_seq_length = $pos_wrt_gene - length($change_from);
	if ($gene_seq =~ m/^([ACGTN]{$upstream_seq_length})(.)([ACGTN]*)$/i) {
	    die "$pos_wrt_gene '$2' is not '$change_from's" unless uc($2) eq uc($change_from);
	    if (uc($change_to) eq uc($2)) {
		### It's silent
		$mutant_gene_seq = lc($1).uc($change_to).lc($3);
	    } else {
		### It's not silent
		$mutant_gene_seq = lc($1).uc($change_to).lc($3);
	    }
	    
	} else {
	    die "'$gene_seq'";
	}
	
	
	if ($strand eq '+') {
	    # OK
	} elsif ($strand eq '-') {
	    $gene_seq = reverse_complement_as_string($gene_seq);
	    $mutant_gene_seq = reverse_complement_as_string($mutant_gene_seq);
	} else {
	    die "strand='$strand'";
	}
	
	### Extract the polymorphic codon(s)
	my %polymorphic_codons;
	my @wt_codons = ( $gene_seq =~ m/([ACGTN]{3})/gi);
	my @mut_codons = ( $mutant_gene_seq =~ m/(\S{3})/gi);
	foreach my $wt_codon ( @wt_codons ) {
	    $wt_codon = lc($wt_codon);
	    my $mut_codon = shift @mut_codons or die "\n$gene_seq\n\n$mutant_gene_seq\n\n@wt_codons\n\n@mut_codons\n";
	    unless ( uc($wt_codon) eq uc($mut_codon) ) {
		$polymorphic_codons{$wt_codon} = $mut_codon;
	    }
	}
	
	### Translate DNA -> protein
	use Bio::Perl;
	my $protein_seq = translate_as_string($gene_seq);
	my $mutant_protein_seq = translate_as_string($mutant_gene_seq);
	
	my $silent = 0;
	$silent = 1 if $protein_seq eq $mutant_protein_seq;
	$gene2polymorphic_codons{$gene_ref} = \%polymorphic_codons;
	$gene2silent{$gene_ref} = $silent;
    }
    return (\%gene2polymorphic_codons, \%gene2silent);
}


