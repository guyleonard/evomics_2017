#!/usr/bin/perl
while (<>) {
  if (/^>/){ $out = $_ =~ m/length_([5-9]|\d{2})\d{2}.*_cov_\d\d+\./ } 
  print if $out;
}

