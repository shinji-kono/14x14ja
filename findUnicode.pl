#!/usr/bin/perl

# find used unicode 
use strict;
use utf8;
use open qw(:std :utf8); # input/output default encoding will be UTF-8, it looks like default

my %used;
# my @fonts = <[0-9]*.bdf> ;
my @fonts = @ARGV; 

use Getopt::Std;
our ($opt_f);
our ($opt_d);

getopts('f:d');
my $fd;
if ($opt_f) {
    open $fd,"<",$opt_f or die "can't open $opt_f";
} else {
    print "$0 -f file *.bdf\n";
    exit 0;
}

while(<$fd>) {
    for my $ch ( /(.)/g ) {
        next if (ord($ch)<128);
        # next if (ord($ch)>=12288);  # ignore CJKV
        $used{ord($ch)}++;
    }
}

my %has;
for my $bdf ( @fonts ) {
   open(my $f,"<",$bdf);
   while(<$f>) {
       if (/^ENCODING\s+(\d+)/) {    
          my $encoding=$1;
          $has{$encoding} = [];
          push @{$has{$encoding}} , $bdf;
       }
   }
}


my %no;

for my $ch ( sort {$a<=>$b} (keys %used )) {
   if (! defined $has{$ch}) {
       my $hex = sprintf("%x",$ch);
       print chr($ch)," $ch 0x$hex is not found\n";
   } else {
       for my $f ( @{$has{$ch}} ) {
           if ($f eq "14x14ja-new.bdf" or $f eq "7x14-new.bdf" or $f eq "7x14B-new.bdf") {
               # already defined
              if ($opt_d) {
                  my $hex = sprintf("%x",$ch);
                  print chr($ch)," $ch 0x$hex is in $f\n";
              }
           } else {
              my $hex = sprintf("%x",$ch);
              print chr($ch)," $ch 0x$hex is in $f\n";
          }
      }
  }
}

