
all:    14x14ja.pcf.gz 7x14.pcf.gz  7x14B.pcf.gz

14x14ja-new.bdf: 14x14ja.ascii
	perl ascii2bdf.pl 14x14ja.ascii  > 14x14ja-new.bdf

7x14-new.bdf: 7x14.ascii
	perl ascii2bdf.pl 7x14.ascii > 7x14-new.bdf

7x14B-new.bdf: 7x14B.ascii
	perl ascii2bdf.pl 7x14B.ascii > 7x14B-new.bdf

14x14ja.pcf.gz : 14x14ja-new.bdf
	bdftopcf 14x14ja-new.bdf | gzip > 14x14ja.pcf.gz

7x14.pcf.gz : 7x14-new.bdf
	bdftopcf 7x14-new.bdf | gzip > 7x14.pcf.gz

7x14B.pcf.gz : 7x14B-new.bdf
	bdftopcf 7x14B-new.bdf | gzip > 7x14B.pcf.gz

install:
	sudo mv -i *.pcf.gz /opt/X11/lib/X11/fonts/misc
	xset fp rehash
	echo please reboot X11

clean:
	rm 14x14ja-new.bdf 7x14-new.bdf

tgz :   all
	tar czf ../14x14ja.tgz 14x14ja.ascii 14x14ja.pcf.gz 7x14.ascii 7x14.pcf.gz Makefile ascii2bdf.pl bdf2ascii.pl findUnicode.pl make14x14ja.pl readme-j.txt readme.txt ucs2jis.pm eaw-xterm.el


