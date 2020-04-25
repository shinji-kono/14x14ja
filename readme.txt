12x13ja.bdf is an ungly shrinked font from good looking k14.bdf.
14x14ja.bdf is almost same as 12x13ja.bdf but it is not scaled.

    14x14ja.bdf.gz
    14x14ja.pcf.gz    should be put in /usr/X11/lib/X11/fonts/misc
                        don't forget to mkfontsdir or add next line by hand.
14x14ja.pcf.gz -misc-fixed-medium-r-normal-ja-14-130-75-75-c-140-iso10646-1

    make14x14ja.pl    generator
    readme.txt
    ucs2jis.pm (need NKF.pm from nkf-utf8)

Use it as uxterm small font, or

 uxterm -fn a14 -fw -misc-fixed-medium-r-normal-ja-14-130-75-75-c-140-iso10646-1

use font below to fix star in uxterm.

   7x14.pcf.gz

use eaw.el to fix char-width of → etc of emacs-25.
