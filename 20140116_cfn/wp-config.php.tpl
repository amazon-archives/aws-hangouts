<?php
define('DB_NAME',          '{{DBName}}');
define('DB_USER',          '{{DBUsername}}');
define('DB_PASSWORD',      '{{DBPassword}}');
define('DB_HOST',          'localhost');
define('DB_CHARSET',       'utf8');
define('DB_COLLATE',       '');
define('AUTH_KEY',         'f@A17vs{ mO0}:&I,6SB.QzV`E?!`/tN5:~GZX%=@ZA%!_T0-]9>g]4ll6~,6G|R');
define('SECURE_AUTH_KEY',  'gTFTI|~rYHY)|mlu:Cv7RN]GQ^3ngyUbw;L0o!12]0c-ispR<-yt3qj]xjquz^&9');
define('LOGGED_IN_KEY',    'Jd:HG9M)1p5t2<v~+R-vd{p-Q*|*RB^&PUI{vIrydAEEiV!{HS{jN:nErCmLv`p}');
define('NONCE_KEY',        '4aMj4KZV;,Gu7(B|qOCve[c5?*J5x1+x93i:Ey6hh/6jXh+V_{V4+hw!qE^d*U,-');
define('AUTH_SALT',        '_Y_&8m)FH)Cns)8}Yb8b88KDSn:p1#p(qBa<~VW&Y1v}P.*9/8S8@P`{mkNxV lC');
define('SECURE_AUTH_SALT', '%nG3Ag41^Lew5c86,#zbN:yPFs.GA5a)z5*:Oce1>v6uF~D`,.o1pzS)F8[bM9i[');
define('LOGGED_IN_SALT',   '~K<y+Ly+_Ww1~dtq>;rSQ^+{P5/k|=!]k%RXAF-Y@XMY6GSp+wJ5{(|rCzaWjZ%/');
define('NONCE_SALT',       ',Bs_*Y9:b/1Z:apVLHtz35uim|okkA,b|Jt[-&Nla=T{<l_#D?~6Tj-.2.]FonI~');
define('WPLANG'            , '');
define('WP_DEBUG'          , false);
$table_prefix  = 'wp_';
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');