#!/usr/bin/perl

use strict;
use utf8;
use open qw(:std :utf8); # input/output default encoding will be UTF-8, it looks like default


use Unicode::GCString;
use Unicode::Normalize;

sub unilength {
    my ($str) = @_;
    return 0 if (! defined $str);
    return Unicode::GCString->new($str)->columns;
}

# my $w = 0;
# 
# for(my $i=1; $i< 0x10000; $i++ ) {
#     my $n = Unicode::GCString->new(chr($i))->columns;
#     if ($n != $w ) {
#         printf "% 8d $n\n", $i;
#         $w = $n ;
#     }
# }

open my $eaw, "<", "$ENV{'HOME'}/.emacs.d/site-lisp/eaw.el" or die("can't open $!");

while(<$eaw>) {
   if (/^\s*\#x([0-9a-zA-Z]+) ;/) {
      my $h = $1;
      my $d = hex($h);
      # print "$h $d: ",chr($d), " w=",unilength(chr($d)),"\n";
      if (unilength(chr($d)) == 2 ) {
          print;
      }
   }
}


