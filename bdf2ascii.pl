#!/usr/bin/perl
use strict;

my ($name,$encoding,@bitmap);

while(<>) {
    last if (/^ENDPROP/);
}

my $dum = <>; # skip CHARS

while(<>) {
    if(/^STARTCHAR\s+(.*)/) { &init(); $name=$1; print;
    } elsif (/^ENCODING\s+(\d+)/) {    $encoding=$1; print;
    } elsif (/^SWIDTH (\d+) (\d+)/) { print;
    } elsif (/^DWIDTH (\d+) (\d+)/) { print;
    } elsif (/^BBX ([-+\d]+) ([-+\d]+) ([-+\d]+) ([-+\d]+)/) { print;
    } elsif (/^BITMAP/) { print;
    } elsif (/^ENDCHAR/) {  &display(); print "ENDCHAR\n";
    } elsif (/^[0-9a-zA-Z]/) {  chop; push(@bitmap,$_);
    }
}

sub display {
    for my $hex (@bitmap) {
        my $h =  pack("H*",$hex);
        my $b = unpack("B*",$h);
        $b =~ s/./$&$&/g;
        $b =~ tr/01/ */;
        print "$b\n";
    }
    print "\n";
}

sub init {
    $name = '';
    $encoding = 0;
    @bitmap= ();
}
