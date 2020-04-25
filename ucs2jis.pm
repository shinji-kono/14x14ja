#!/usr/bin/perl
#
#   309  19:56  xfd -fn '-Misc-Fixed-Medium-R-Normal-ja-13-120-75-75-C-120-ISO10646-1'

use NKF;

sub to_ucs
{
# my $jis_no = 0x3126;
my ($jis_no) = @_;

my $jis = chr($jis_no/256+0x80).chr($jis_no%256+0x80);
# print $jis,"\n";

my $ucs = nkf("-E","-w16",$jis);
# print length($ucs),"\n";

my $ucs_no = ord(substr($ucs,0,1))*256+ord(substr($ucs,1,1));

# print "HEX:",unpack("H*",$ucs),"\n";

    return $ucs_no
}

sub to_jis
{
my ($ucs_no) = @_;

my $ucs = chr($ucs_no/256).chr($ucs_no%256);
# print $jis,"\n";

my $jis = nkf("-W16","-e",$ucs);
# print length($ucs),"\n";

my $jis_no = (ord(substr($jis,0,1))-0x80)*256+
	ord(substr($jis,1,1))-0x80;

# print "HEX:",unpack("H*",$ucs),"\n";
    return undef if ($jis_no==-32896);
    return $jis_no
}

# printf "%x\n", &to_ucs(0x3126);
# printf "%x\n", &to_jis(0x53f3);

1;
