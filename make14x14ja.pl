#!/usr/bin/perl

use ucs2jis;

# printf "%04x\n",&to_ucs(eval($ARGV[0]));

my $ucs_bdf = "/Users/kono/Desktop/Archives/12x13ja.bdf";
my $jis_bdf = "/Users/kono/Desktop/Archives/k14.bdf";
my $ucs14_bdf = "14x14ja.bdf";

my %jischar;
my $debug = 0;

my $header = <<'EOFEOF';
STARTFONT 2.1
COMMENT JIS X208 glyphs donated by T.Maebashi <maebashi@mcs.meitetsu.co.jp>
COMMENT Adapted and extended for ISO 10646-1 by Markus Kuhn <mkuhn@acm.org>
COMMENT Hangul glyphs prepared by Won-kyu Park <wkpark@chem.skku.ac.kr>
COMMENT from BAEKMUK font.
COMMENT Id: 14x14ja.bdf,v 1.23 2000-12-07 21:56:41+00 mgk25 Exp mgk25 $
FONT -misc-fixed-medium-r-normal-ja-14-130-75-75-c-140-iso10646-1
SIZE 14 75 75
FONTBOUNDINGBOX 14 14 0 -2
STARTPROPERTIES 22
FONTNAME_REGISTRY ""
FOUNDRY "Misc"
FAMILY_NAME "Fixed"
WEIGHT_NAME "Medium"
SLANT "R"
SETWIDTH_NAME "Normal"
ADD_STYLE_NAME "ja"
PIXEL_SIZE 14
POINT_SIZE 130
RESOLUTION_X 75
RESOLUTION_Y 75
SPACING "C"
AVERAGE_WIDTH 140
CHARSET_REGISTRY "ISO10646"
CHARSET_ENCODING "1"
DEFAULT_CHAR 0
FONT_DESCENT 2
FONT_ASCENT 12
COPYRIGHT "Public domain font.  Share and enjoy."
_XMBDFED_INFO "Edited with xmbdfed 4.3."
CAP_HEIGHT 9
X_HEIGHT 7
ENDPROPERTIES
EOFEOF


open(JIS,"<$jis_bdf");
my $jis = 0;
my $jis0;
my $char;
while(<JIS>) {
    if ($jis) {
	$char .= $_;
    }
    if (/^STARTCHAR ([\da-z]+)/) {
	$char = '';
	$jis0 = hex($1);
    } elsif (/^ENCODING/) {
	$jis = $jis0;
    } elsif (/^ENDCHAR/) {
	if ($jis) {
	    $jischar{$jis} = $char;
	}
	$jis = $jis0 = 0;
    }
}


my $uid;
open(U14,">$ucs14_bdf");
open(UNICODE,"<$ucs_bdf");
$jis = '';
print U14 $header;
while(<UNICODE>) {
    last if (/ENDPROPERTIES/);
}
while(<UNICODE>) {
    $jis = 0 if (/^STARTCHAR/);
    next if ($jis);  # skipping replacement
    if (/^ENCODING (\d+)/) {
	my $id = $1;
printf "ucs 0x%x ",$id if ($debug);
	if (defined($jis = to_jis($id))
	    && defined($jischar{$jis})) {
printf "defined 0x%x\n",$jis if ($debug);
	    print U14;
	    print U14 $jischar{$jis};
	    $jis = 1;
	} else {
	    $jis = 0;
print "not defined\n" if ($debug);
	    print U14;
	}
    } elsif (/^ENDCHAR/) {
	if (!$jis) {
	    print U14 "0000\n";
	    # print U14 "0000\n";
	}
	print U14;
    } else {
	s/^DWIDTH 12 0/DWIDTH 14 0/;
	s/^BBX 12 13 0 -2/BBX 14 14 0 -2/;
	print U14;
    }
}

# end
