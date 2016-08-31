#!/usr/bin/perl
while (<>) {
    $x++ if />/; 
    print unless ($x - 7) % 10;
}
