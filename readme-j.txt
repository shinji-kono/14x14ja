12x13ja.bdf は k14.bdf から縮小されていて汚いので、k14 に戻した
ものを作りました。

    14x14ja.bdf.gz
    14x14ja.pcf.gz     /usr/X11/lib/X11/fonts/misc に置きます
                mkfontsdir するか、以下の行をfonts.dir に付け加えて下さい
14x14ja.pcf.gz -misc-fixed-medium-r-normal-ja-14-130-75-75-c-140-iso10646-1

    make14x14ja.pl    生成プログラム
    readme.txt
    ucs2jis.pm (need NKF.pm from nkf-utf8)

uxterm の small font あるいは、

 uxterm -fn a14 -fw -misc-fixed-medium-r-normal-ja-14-130-75-75-c-140-iso10646-1

ってな感じで明示して使います。

uxterm の星がとーふになるのは、以下のフォントを使うと治ります。

    7x14.bdf.gz

emacs-25 で、「→」とかがおかしくなるのは、

    eaw.el

を使うと直るようです。
