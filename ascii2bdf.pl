#!/usr/bin/perl
use strict;

my ($name,$encoding,@bitmap);

my ($lineno,$line);
my $width;
my $height;
my @header;
my $char;
my @bytes;
my %chars;

my $fix7 = 1;

while(<>) {
    if(/^STARTFONT\s+(.*)/) {   
        @header = (); # use the last one
        push(@header,$_);
        while(<>) {
            push(@header,$_);
            last if(/^ENDPROPERTIES/);
        }
    } elsif(/^CHARS/) { 
    } elsif(/^STARTCHAR\s+(.*)/) { &init(); $name=$1; 
# print STDERR "$1\n";
    } elsif (/^ENCODING\s+(\d+)/) {    $encoding=$1; $char={name=>$name,encoding=>$_}; $chars{$encoding} = $char;
    } elsif (/^SWIDTH (\d+) (\d+)/) { $char->{swidth} = $_;
        if ($fix7 && $1 == 497) { s/497/960/; $char->{swidth} = $_; }
    } elsif (/^DWIDTH (\d+) (\d+)/) { $width = $1; $char->{dwidth} = $_;
    } elsif (/^BBX ([-+\d]+) ([-+\d]+) ([-+\d]+) ([-+\d]+)/) { $height = $2; 
        $char->{bh} = $2;
        if ($fix7 && $2==13) { $height = 14; $_ =~ s/ 13 / 14 /; $char->{bh} = 14; }
        $char->{bbx} = $_;
    } elsif (/^BITMAP/) { $line = $lineno+2; # error line must start 1
    } elsif (/^ENDCHAR/) {  
        &display() if (@bitmap) ; 
# print STDERR "end\n" if (@bitmap);
    } elsif (/^[0-9A-Fa-f]+$/) {  push(@{$char->{byte}},$_);
    } elsif (/^[ *]*$/) {  chop; push(@bitmap,$_);
    }
    $lineno++;
    $lineno = 0 if (eof);
}

print @header if (@header);
print "CHARS ",scalar(keys %chars),"\n\n";
for my $k ( sort {$a <=> $b} keys %chars) {
    my $ch = $chars{$k};
    print "STARTCHAR $ch->{name}\n";
    print $ch->{encoding};
    print $ch->{swidth};
    print $ch->{dwidth};
    print $ch->{bbx};
    print "BITMAP\n";
    while ($#{$ch->{byte}} < $ch->{bh}-1) {
        unshift(@{$ch->{byte}},"00\n");
    }
    for my $byte (@{$ch->{byte}}) {
        print $byte;
    }
    print "ENDCHAR\n\n";
}
print "ENDFONT\n";

sub showchar {
    my ($ch) = @_;
    for my $k ( keys %{$ch} ) {
        print "$k => $ch->{$k}\n";
    }
}

sub display {
    my $hwidth = int((($width+7)&(~7))/4);
# print "hwdith $hwidth\n";
    my $i = 0;
    for my $hex (@bitmap) {
        my $bin;
        my $orig = $hex;
        my $j = 0;
        while($hex =~ s/..//) {
            if ($& eq "  ") {
                $bin .= "0";
            } elsif ($& eq "**") {
                $bin .= "1";
            } else {
                print STDERR $line+$i,": Error Bad Alignment ","| "x$width,"\n";
                print STDERR $line+$i,": Error Bad Alignment ","$orig\n";
                last;
            }
            if ($j++ > $width) {
                print STDERR $line+$i,": Error Too long",substr($orig,$j),
                        "|$hex too long \n" if ($hex =~ /[^ ]/);
                last;
            }
        }
# print "bitmap $bin -- $i\n";
        my $h =  pack("B*",$bin . "0"x$width);
        my $b = unpack("H*",$h);
        $b = substr($b,0,$hwidth);
        push(@{$char->{byte}},$b."\n");
        last if ($i++ > $height-2);
    }
    # print "hhhh $height-$i = ",$height-$i,"\n";
    # print (("0"x$hwidth."\n")x($height-$i)) if ($height-$i > 0);
    while ($height-$i > 0) {
        push(@{$char->{byte}},("0"x$hwidth."\n"));
        $i++;
    }
}

sub init {
    $name = '';
    $encoding = 0;
    @bitmap= ();
    @bytes= ();
}

=head1 NAME

ascii2bdf -- convert readable bdf to bdf and merge

=head1 AUTHORS

Shinji KONO <kono@ie.u-ryukyu.ac.jp>

=head1 SYNOPSIS

    perl ascii2bdf.pl orignal.bdf fix.bdf fix1.bdf

=head1 DESCRIPTION

this script converts

    STARTCHAR uni2163
    ENCODING 8547
    SWIDTH 960 0
    DWIDTH 14 0
    BBX 14 14 0 -2
    BITMAP

        **  **          **            
        **  **          **            
        **  **          **            
        **    **      **              
        **    **      **              
        **    **      **              
        **      **  **                
        **      **  **                
        **      **  **                
        **        **          
        **        **          
                                  
                                    
    ENDCHAR

to bdf and merge it to the orignal one.

=cut


# end
