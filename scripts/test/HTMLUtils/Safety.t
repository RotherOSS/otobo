# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

# get HTMLUtils object
my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

# Safety tests
my @TestsWithDefaultConfig = (
    {
        Input  => 'Some Text',
        Result => {
            Output  => 'Some Text',
            Replace => 0,
        },
        Name => 'simple text',
        Line => __LINE__,
    },
    {
        Input  => '<b>Some Text</b>',
        Result => {
            Output  => '<b>Some Text</b>',
            Replace => 0,
        },
        Name => 'bold text',
        Line => __LINE__,
    },
    {
        Input  => '<a href="javascript:alert(1)">Some Text</a>',
        Result => {
            Output  => '<a href="">Some Text</a>',
            Replace => 1,
        },
        Name => 'href with javascript protocol',
        Line => __LINE__,
    },
    {
        Input => '<a href = " javascript : alert(
            \'Hi!\'
        )" >Some Text</a>',
        Result => {
            Output  => '<a href="">Some Text</a>',
            Replace => 1,
        },
        Name => 'href with javascript protocol, including white space',
        Line => __LINE__,
    },
    {
        Input =>
            '<a href="https://www.yoururl.tld/sub/online-assessment/index.php" target="_blank">https://www.yoururl.tld/sub/online-assessment/index.php</a>',
        Result => {
            Output =>
                '<a href="https://www.yoururl.tld/sub/online-assessment/index.php" target="_blank">https://www.yoururl.tld/sub/online-assessment/index.php</a>',
            Replace => 0,
        },
        Name => 'valid href',
        Line => __LINE__,
    },
    {
        Input =>
            "<a href='https://www.yoururl.tld/sub/online-assessment/index.php' target='_blank'>https://www.yoururl.tld/sub/online-assessment/index.php</a>",
        Result => {
            Output =>
                '<a href="https://www.yoururl.tld/sub/online-assessment/index.php" target="_blank">https://www.yoururl.tld/sub/online-assessment/index.php</a>',
            Replace => 0,
        },
        Name => 'valid href, with single quotes',
        Line => __LINE__,
    },
    {
        Name   => 'tag a with attribute onclock',
        Input  => '<a href="http://example.com/" onclock="alert(1)">Some Text</a>',
        Result => {
            Output  => '<a href="http://example.com/">Some Text</a>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => 'tag a with a made up onEvent handler',
        Input  => '<a href="http://example.com/" onMadeUp="alert(1)">Some Text</a>',
        Result => {
            Output  => '<a href="http://example.com/">Some Text</a>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => 'tag a with onCLocK, img with external source',
        Input  => '<a href="http://example.com/" onCLocK="alert(1)">Some Text <img src="http://example.com/logo.png"/></a>',
        Result => {
            Output  => '<a href="http://example.com/">Some Text </a>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => 'tag a with onCLocK, img with external source',
        Input  => '<a href="http://example.com/" onCLocK="alert(1)">Some Text <img src="http://example.com/logo.png"/></a>',
        Result => {
            Output  => '<a href="http://example.com/">Some Text </a>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => 'tag a with NotonCLocK, img with external source',
        Input  => '<a href="http://example.com/" NotonCLocK="alert(1)">Some Text <img src="http://example.com/logo.png"/></a>',
        Result => {
            Output  => '<a href="http://example.com/" notonclock="alert(1)">Some Text </a>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => 'tag a with onCLocK and a +, img with external source',
        Input  => '<a href="http://example.com/" +onCLocK="alert(1)">Some Text <img src="http://example.com/logo.png"/></a>',
        Result => {
            Output  => '<a href="http://example.com/">Some Text </a>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Input =>
            '<a href="http://example.com/" onclock="alert(1)">Some Text <img src="//example.com/logo.png"/></a>',
        Result => {
            Output  => '<a href="http://example.com/">Some Text </a>',
            Replace => 1,
        },
        Name => 'tag a with onclock, img with protocol relative external source',
        Line => __LINE__,
    },
    {
        Name   => q{link with onclock and img, space before '=', a closed twice},
        Input  => '<a href="http://example.com/" onclock="alert(1)">Some Text <img src ="http://example.com/logo.png"/></a>',
        Result => {
            Output  => '<a href="http://example.com/">Some Text </a>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Input => '<script type="text/javascript" id="topsy_global_settings">
var topsy_style = "big";
</script><script type="text/javascript" id="topsy-js-elem" src="http://example.com/topsy.js?init=topsyWidgetCreator"></script>
<script type="text/javascript" src="/pub/js/podpress.js"></script>
',
        Result => {
            Output => '

',
            Replace => 0,    # changes from HTML::Parser are not reported
        },
        Name => 'script tag',
        Line => __LINE__,
    },
    {
        Input => '<center>
<aPPlet   code="AEHousman.class" width="300" height="150">
Not all browsers can run applets.  If you see this, yours can not.
You should be able to continue reading these lessons, however.
</appLET>
</center>',
        Result => {
            Output => '<center>

Not all browsers can run applets.  If you see this, yours can not.
You should be able to continue reading these lessons, however.

</center>',
            Replace => 0,
        },
        Name => 'applet tag',
        Line => __LINE__,
    },
    {
        Input => '<center>
<object width="384" height="236" align="right" vspace="5" hspace="5"><param name="movie" value="http://www.youtube.com/v/l1JdGPVMYNk&hl=en_US&fs=1&hd=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/l1JdGPVMYNk&hl=en_US&fs=1&hd=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="384" height="236"></embed></object>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 0,
        },
        Name => 'object tag',
        Line => __LINE__,
    },
    {
        Input => '<center>
\'\';!--"<XSS>=&{()}
</center>',
        Result => {
            Output => '<center>
\'\';!--"<xss>=&{()}
</center>',
            Replace => 0,
        },
        Name => 'XSS tag',
        Line => __LINE__,
    },
    {
        Input => '<center>
<SCRIPT SRC=http://ha.ckers.org/xss.js></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 0,    # changes from HTML::Parser are not reported
        },
        Name => 'script/src tag',
        Line => __LINE__,
    },
    {
        Input => '<center>
<SCRIPT SRC=http://ha.ckers.org/xss.js><!-- some comment --></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 0,    # changes from HTML::Parser are not reported
        },
        Name => 'script/src tag',
        Line => __LINE__,
    },
    {
        Input => '<center>
<IMG SRC="javascript:alert(\'XSS\');">
</center>',
        Result => {
            Output => '<center>
<img src="">
</center>',
            Replace => 1,
        },
        Name => 'img tag with javascript:alert',
        Line => __LINE__,
    },
    {
        Input => '<center>
<IMG SRC=" javascript:    alert(
 \'XSS\'    );" >
</center>',
        Result => {
            Output => '<center>
<img src="">
</center>',
            Replace => 1,
        },
        Name => 'img tag with javascript:alert and whitespace',
        Line => __LINE__,
    },
    {
        Input => '<center>
<IMG SRC=javascript:alert(\'XSS\');>
</center>',
        Result => {
            Output => '<center>
<img src="">
</center>',
            Replace => 1,
        },
        Name => 'img tag in center',
        Line => __LINE__,
    },
    {
        Input => '<center>
<IMG SRC=JaVaScRiPt:alert(\'XSS\')>
</center>',
        Result => {
            Output => '<center>
<img src="">
</center>',
            Replace => 1,
        },
        Name => 'img tag with JaVaScRiPt',
        Line => __LINE__,
    },
    {
        Input => '<center>
<IMG SRC=javascript:alert(&quot;XSS&quot;)>
</center>',
        Result => {
            Output => '<center>
<img src="">
</center>',
            Replace => 1,
        },
        Name => 'img tag alert and quote entities',
        Line => __LINE__,
    },
    {
        Input => '<center>
<IMG """><SCRIPT>alert("XSS")</SCRIPT>">
</center>',
        Result => {
            Output => '<center>
<img """>"&gt;
</center>',
            Replace => 0,    # changes from HTML::Parser are not reported
        },
        Name => 'script/img tag',
        Line => __LINE__,
    },
    {
        Input => '<center>
<SCRIPT/XSS SRC="http://ha.ckers.org/xss.js"></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 1,
        },
        Name => 'script tag',
        Line => __LINE__,
    },
    {
        Input => '<center>
<SCRIPT/SRC="http://ha.ckers.org/xss.js"></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 1,
        },
        Name => 'script/src tag',
        Line => __LINE__,
    },
    {
        Input => '<center>
<<SCRIPT>alert("XSS");//<</SCRIPT>
</center>',
        Result => {
            Output => '<center>
&lt;
</center>',
            Replace => 0,    # changes from HTML::Parser are not reported
        },
        Name => 'script tag with end of line comment',
        Line => __LINE__,
    },
    {
        Input => '<center>
<SCRIPT SRC=http://ha.ckers.org/xss.js?<B>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 0,    # changes from HTML::Parser are not reported
        },
        Name => 'script tag <B> in src',
        Line => __LINE__,
    },
    {
        Input => '<center>
<SCRIPT SRC=//ha.ckers.org/.j>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 0,    # changes from HTML::Parser are not reported
        },
        Name => 'script tag with .j in src',
        Line => __LINE__,
    },
    {
        Input => '<center>
<iframe src=http://ha.ckers.org/scriptlet.html >
</center>',
        Result => {
            Output => '<center>

&lt;/center&gt;',
            Replace => 1,
        },
        Name => 'iframe with external src',
        Line => __LINE__,
    },
    {
        Input => '<center>
<BODY ONLOAD=alert(\'XSS\')>
</center>',
        Result => {
            Output => '<center>
<body>
</center>',
            Replace => 1,
        },
        Name => 'onload',
        Line => __LINE__,
    },
    {
        Input => '<center>
<TABLE BACKGROUND="javascript:alert(\'XSS\')">
</center>',
        Result => {
            Output => '<center>
<table background="">
</center>',
            Replace => 1,
        },
        Name => 'background',
        Line => __LINE__,
    },
    {
        Input => '<center>
<TABLE BACKGROUND="   javascript:    alert(
    \'XSS\'
    ) " >
</center>',
        Result => {
            Output => '<center>
<table background="">
</center>',
            Replace => 1,
        },
        Name => 'background',
        Line => __LINE__,
    },
    {
        Input => '<center>
<SCRIPT a=">" SRC="http://ha.ckers.org/xss.js"></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 0,    # changes from HTML::Parser are not reported
        },
        Name => 'script',
        Line => __LINE__,
    },
    {
        Input => '<center>
<SCRIPT =">" SRC="http://ha.ckers.org/xss.js"></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 0,    # changes from HTML::Parser are not reported
        },
        Name => 'script',
        Line => __LINE__,
    },
    {
        Input => '<center>
<SCRIPT "a=\'>\'"
 SRC="http://ha.ckers.org/xss.js"></SCRIPT>
</center>',
        Result => {
            Output => '<center>

</center>',
            Replace => 0,    # changes from HTML::Parser are not reported
        },
        Name => 'script',
        Line => __LINE__,
    },
    {
        Input => '<center>
<SCRIPT>document.write("<SCRI");</SCRIPT>PT
 SRC="http://ha.ckers.org/xss.js"></SCRIPT>
</center>',
        Result => {
            Output => '<center>
PT
 SRC="http://ha.ckers.org/xss.js"&gt;
</center>',
            Replace => 0,    # changes from HTML::Parser are not reported
        },
        Name => 'script with PT',
        Line => __LINE__,
    },
    {
        Input => '<center>
<A
 HREF="javascript:document.location=\'http://www.example.com/\'">XSS</A>
</center>',
        Result => {
            Output => '<center>
<a href="">XSS</a>
</center>',
            Replace => 1,
        },
        Name => 'script with XSS',
        Line => __LINE__,
    },
    {
        Input => '<center>
<A
 HREF="   javascript:   document.location = \'http://www.example.com/\'">XSS</A>
</center>',
        Result => {
            Output => '<center>
<a href="">XSS</a>
</center>',
            Replace => 1,
        },
        Name => 'script with XSS again',
        Line => __LINE__,
    },
    {
        Name  => 'single quotes in style, onmouseover with spaces befor =',
        Input => q{<center>
  <body style="background: #fff; color: #000; dummy: '';" onmouseover     ="var ga = document.createElement(\'script\'); ga.type = \'text/javascript\'; ga.src = (\'https:\' == document.location.protocol ? \'https://\' : \'http://\') + \'ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js\'; document.body.appendChild(ga); setTimeout(function() { jQuery(\'body\').append(jQuery(\'<div />\').attr(\'id\', \'hack-me\').css(\'display\', \'none\')); jQuery(\'#hack-me\').load(\'/otobo/index.pl?Action=AgentPreferences\', null, function() { jQuery.ajax({url: \'/otobo/index.pl\', type: \'POST\', data: ({Action: \'AgentPreferences\', ChallengeToken: jQuery(\'input[name=ChallengeToken]:first\', \'#hack-me\').val(), Group: \'Language\', \'Subaction\': \'Update\', UserLanguage: \'zh_CN\'})}); }); }, 500);">
</center>},
        Result => {
            Output => q{<center>
  <body style="background: #fff; color: #000; dummy: &#39;&#39;;">
</center>},
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name  => 'Test for bug#7972 - Some mails may not present HTML part when using rich viewing.',
        Input =>
            '<html><head><style type="text/css"> #some_css {color: #FF0000} </style><body>Important Text about "javascript"!<style type="text/css"> #some_more_css{ color: #00FF00 } </style> Some more text.</body></html>',
        Result => {
            Output =>
                '<html><head><style type="text/css"> #some_css {color: #FF0000} </style><body>Important Text about "javascript"!<style type="text/css"> #some_more_css{ color: #00FF00 } </style> Some more text.</body></html>',
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name  => q{style with type='text/javascript' is no longer filtered out},
        Input =>
            '<html><head><style type="text/javascript"> alert("some evil stuff!);</style><body>Important Text about "javascript"!<style type="text/css"> #some_more_css{ color: #00FF00 } </style> Some more text.</body></html>',
        Result => {
            Output =>
                '<html><head><style type="text/javascript"> alert("some evil stuff!);</style><body>Important Text about "javascript"!<style type="text/css"> #some_more_css{ color: #00FF00 } </style> Some more text.</body></html>',
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name  => 'UTF7 tags',
        Input => <<'EOF',
script:+ADw-script+AD4-alert(1);+ADw-/script+AD4-
applet:+ADw-applet+AD4-alert(1);+ADw-/applet+AD4-
embed:+ADw-embed src=test+AD4-
object:+ADw-object+AD4-alert(1);+ADw-/object+AD4-
EOF
        Result => {
            Output => <<'EOF',
script:+ADw-script+AD4-alert(1);+ADw-/script+AD4-
applet:+ADw-applet+AD4-alert(1);+ADw-/applet+AD4-
embed:+ADw-embed src=test+AD4-
object:+ADw-object+AD4-alert(1);+ADw-/object+AD4-
EOF
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name  => 'expression() in CSS is no longer a vulnerability',
        Input => <<'EOF',
<div style="width: expression(alert(\'XSS\');); height: 200px;" style="width: 400px">
<div style='width: expression(alert("XSS");); height: 200px;' style='width: 400px'>
EOF
        Result => {
            Output => <<'EOF',
<div style="width: expression(alert(\&#39;XSS\&#39;);); height: 200px;">
<div style="width: expression(alert(&quot;XSS&quot;);); height: 200px;">
EOF
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name  => 'expression() in CSS is no longer a vulnerability, even on invalid tags',
        Input => <<'EOF',
<div><XSS STYLE="xss:expression(alert('XSS'))"></div>
EOF
        Result => {
            Output => <<'EOF',
<div><xss style="xss:expression(alert(&#39;XSS&#39;))"></div>
EOF
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Input => <<'EOF',
<div class="svg"><svg some-attribute evil="true"><someevilsvgcontent></svg></div>
EOF
        Result => {
            Output => <<'EOF',
<div class="svg"><someevilsvgcontent></div>
EOF
            Replace => 0,
        },
        Name => 'Filter out SVG',
        Line => __LINE__,
    },
    {
        Input => <<'EOF',
<div><script ></script ><applet ></applet ></div >
EOF
        Result => {
            Output => <<'EOF',
<div></div>
EOF
            Replace => 0,
        },
        Name => 'Closing tag with space',
        Line => __LINE__,
    },
    {
        Name  => 'Style tags with CSS expressions are no longer filtered out',
        Input => <<'END_INPUT',
<sTYle type =  "    text/css">
div > span {
    width: 200px;
}
</stylE>
<style type=" text/CSS ">
div > span {
    width: expression( FormerlyEvilJS() );
}
</style>
<style type="text/css">
div > span > div {
    width: 200px;
}
</style>
END_INPUT
        Result => {
            Output => <<'END_OUTPUT',
<style type="    text/css">
div &gt; span {
    width: 200px;
}
</style>
<style type=" text/CSS ">
div &gt; span {
    width: expression( FormerlyEvilJS() );
}
</style>
<style type="text/css">
div &gt; span &gt; div {
    width: 200px;
}
</style>
END_OUTPUT
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name  => 'Nested script tags',
        Input => <<'EOF',
<s<script>...</script><script>:::<cript type="text/javascript">
document.write("Hello World!");
</s<script>//<cript>
EOF
        Result => {
            Output => <<'EOF',
...:::<cript type="text/javascript">
document.write("Hello World!");
</s<script>//<cript>
EOF
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Input => <<'EOF',
<img src="/img1.png"/>
<iframe src="  javascript:alert('XSS Exploit');"></iframe>
<img src="/img2.png"/>
EOF
        Result => {
            Output => <<'EOF',
<img src="/img1.png" />
<iframe src=""></iframe>
<img src="/img2.png" />
EOF
            Replace => 1,
        },
        Name => 'iframe src with space',
        Line => __LINE__,
    },
    {
        Input => <<'EOF',
<img src="/img1.png"/>
<iframe src='  javascript:alert(
    "XSS Exploit"
);'></iframe>
<img src="/img2.png"/>
EOF
        Result => {
            Output => <<'EOF',
<img src="/img1.png" />
<iframe src=""></iframe>
<img src="/img2.png" />
EOF
            Replace => 1,
        },
        Name => 'iframe src with space and single quotes',
        Line => __LINE__,
    },
    {
        Input => <<'EOF',
<img src="/img1.png"/>
<iframe src=javascript:alert('XSS_Exploit');></iframe>
<img src="/img2.png"/>
EOF
        Result => {
            Output => <<'EOF',
<img src="/img1.png" />
<iframe src=""></iframe>
<img src="/img2.png" />
EOF
            Replace => 1,
        },
        Name => 'javascript source without delimiters',
        Line => __LINE__,
    },
    {
        Name  => 'javascript source in data-src tag, keep as data-src is just for passing data',
        Input => <<'EOF',
<img src="/img1.png"/>
<iframe src="" data-src="javascript:alert('XSS Exploit');"></iframe>
<img src="/img2.png"/>
EOF
        Result => {
            Output => <<'EOF',
<img src="/img1.png" />
<iframe src="" data-src="javascript:alert(&#39;XSS Exploit&#39;);"></iframe>
<img src="/img2.png" />
EOF
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Input => <<'EOF',
Some
<META HTTP-EQUIV="Refresh" CONTENT="2;
URL=http://www.rbrasileventos.com.br/9asdasd/">
Content
EOF
        Result => {
            Output => <<'EOF',
Some

Content
EOF
            Replace => 1,
        },
        Name => 'meta refresh tag removed',
        Line => __LINE__,
    },
    {
        Name  => 'meta with id and refresh tag',
        Input => <<'EOF',
Some
<META id=">" HTTP-EQUIV="Refresh" CONTENT="2;
URL=http://www.rbrasileventos.com.br/9asdasd/">
Content
EOF
        Result => {
            Output => <<'EOF',
Some

Content
EOF
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name  => 'link tag with javascript somewhere',
        Input => <<'EOF',
Link:<LinK id='SOMEjAVaScRiPtsomewhere'>
EOF
        Result => {
            Output => <<'EOF',
Link:
EOF
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name  => '/ as attribute delimiter should be filtered out',
        Input => <<"EOF",
img/onerror:<img/onerror="alert(\'XSS1\')"src=a>
EOF
        Result => {
            Output => <<'EOF',
img/onerror:
EOF
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Input => <<"EOF",
<iframe src=javasc&#x72ipt:alert(\'XSS2\') >
EOF
        Result => {
            Output => <<'EOF',
<iframe src="">
EOF
            Replace => 1,
        },
        Name => 'entity encoding in javascript attribute',
        Line => __LINE__,
    },
    {
        Name  => 'entity encoding in javascript attribute with / separator',
        Input => <<"EOF",
non-alpha, non-digit tag:<iframe/src=javasc&#x72ipt:alert(\'XSS2\') >
EOF
        Result => {
            Output => <<'EOF',
non-alpha, non-digit tag:
EOF
            Replace => 1,
        },
        Line => __LINE__,
    },
    {

        # HTML::Parser accepts 'with+plus' as a tag name
        Name  => 'tag with a plus:',
        Input => <<"EOF",
tag with a plus:<with+plus>
EOF
        Result => {
            Output => <<'EOF',
tag with a plus:
EOF
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Input => <<'EOF',
<img src="http://example.com/image.png"/>
EOF
        Result => {
            Output => <<'EOF',

EOF
            Replace => 1,
        },
        Name => 'external image',
        Line => __LINE__,
    },
    {
        Name  => 'external image with / in tab name will be filtered',
        Input => <<'EOF',
<img/src="http://example.com/image.png"/>
EOF
        Result => {
            Output => <<'EOF',

EOF
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name  => 'external image with protocol-relative URL',
        Input => <<'END_INPUT',
protocol relative img: '<img src="//example.com/image.png"/>'
END_INPUT
        Result => {
            Output => <<'END_OUTPUT',
protocol relative img: ''
END_OUTPUT
            Replace => 1,
        },
        Line => __LINE__,
    },
);

for my $Test (@TestsWithDefaultConfig) {

    # pass the default config
    my %Result = $HTMLUtilsObject->Safety(
        String       => $Test->{Input},
        NoApplet     => 1,
        NoObject     => 1,
        NoEmbed      => 1,
        NoSVG        => 1,
        NoIntSrcLoad => 0,
        NoExtSrcLoad => 1,
        NoJavaScript => 1,
    );

    subtest "$Test->{Name} (line @{[ $Test->{Line} // '???' ]})" => sub {
        if ( $Test->{Result}->{Replace} ) {
            ok( $Result{Replace}, 'replaced' );
        }
        else {
            ok( !$Result{Replace}, 'not replaced', );
        }
        is( $Result{String}, $Test->{Result}->{Output}, 'output' );
    };
}

my @TestsWithExplicitConfig = (
    {
        Name  => 'tag "img/src" filtered out even when not recognized as image',
        Input => <<'EOF',
img/src:<img/src="http://example.com/image.png"/>filtered out
EOF
        Config => {
            NoImg => 1,
        },
        Result => {

            # note the inserted space befor '/>'
            Output => <<'EOF',
img/src:filtered out
EOF
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name  => 'tag "img/src" is filtered out when NoJavaScript is passed',
        Input => <<'EOF',
line1:<img/src="http://example.com/image.png"/>filtered out
line2:
EOF
        Config => {
            NoJavaScript => 1,
        },
        Result => {
            Output => <<'EOF',
line1:filtered out
line2:
EOF
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name  => 'tag "img/src" is filtered out even without parameters',
        Input => <<'EOF',
line1:<img/src="http://example.com/image.png"/>filtered out without parameters
line2:
EOF
        Config => {
        },
        Result => {
            Output => <<'EOF',
line1:filtered out without parameters
line2:
EOF
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name  => 'Filter out SVG replacement',
        Input => <<'EOF',
<div class="svg"><svg some-attribute evil="true"><someevilsvgcontent></svg></div>
EOF
        Config => {
            NoSVG => 1,
        },
        Result => {
            Output => <<'EOF',
<div class="svg"><someevilsvgcontent></div>
EOF
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name  => 'object tag replacement',
        Input => '<center>
<object width="384" height="236" align="right" vspace="5" hspace="5"><param name="movie" value="http://www.youtube.com/v/l1JdGPVMYNk&hl=en_US&fs=1&hd=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/l1JdGPVMYNk&hl=en_US&fs=1&hd=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="384" height="236"></embed></object>
</center>',
        Config => {
            NoObject => 1,
        },
        Result => {
            Output => '<center>
<embed src="http://www.youtube.com/v/l1JdGPVMYNk&amp;hl=en_US&amp;fs=1&amp;hd=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="384" height="236">
</center>',
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name  => 'embed tag replacement',
        Input => '<center>
<object width="384" height="236" align="right" vspace="5" hspace="5"><param name="movie" value="http://www.youtube.com/v/l1JdGPVMYNk&hl=en_US&fs=1&hd=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/l1JdGPVMYNk&hl=en_US&fs=1&hd=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="384" height="236"></object>
</center>',
        Config => {
            NoEmbed => 1,
        },
        Result => {
            Output => '<center>
<object width="384" height="236" align="right" vspace="5" hspace="5"><param name="movie" value="http://www.youtube.com/v/l1JdGPVMYNk&amp;hl=en_US&amp;fs=1&amp;hd=1"><param name="allowFullScreen" value="true"><param name="allowscriptaccess" value="always"></object>
</center>',
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name  => 'applet tag replacement',
        Input => '<center>
<APPLET code="AEHousman.class" width="300" height="150">
Not all browsers can run applets.  If you see this, yours can not.
You should be able to continue reading these lessons, however.
</appLet   >
</center>',
        Config => {
            NoApplet => 1,
        },
        Result => {
            Output => '<center>

Not all browsers can run applets.  If you see this, yours can not.
You should be able to continue reading these lessons, however.

</center>',
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name   => 'bug 10530 - don\'t destroy URL which looks like an on* JS attribute',
        Input  => '<a href="http://localhost/online/foo/bar.html">www</a>',
        Config => {},
        Result => {
            Output  => '<a href="http://localhost/online/foo/bar.html">www</a>',
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name   => 'bug 13561 - Handling empty strings',
        Input  => '',
        Config => {},
        Result => {
            Output  => '',
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name   => 'remote poster attribute, forbidden',
        Input  => '<video controls poster="http://some.domain/vorschaubild.png"/>',
        Config => {
            NoExtSrcLoad => 1,
        },
        Result => {
            Output  => '',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => q{remote poster attribute, forbidden, with space before '='},
        Input  => '<video controls poster ="http://some.domain/vorschaubild.png"/>',
        Config => {
            NoExtSrcLoad => 1,
        },
        Result => {
            Output  => '',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => q{remote poster attribute, forbidden, with an early '>'},
        Input  => '<video controls id=">" poster="http://some.domain/vorschaubild.png"/>',
        Config => {
            NoExtSrcLoad => 1,
        },
        Result => {
            Output  => '',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => 'remote poster attribute, allowed',
        Input  => '<video controls poster="http://some.domain/vorschaubild.png"/>',
        Config => {
            NoExtSrcLoad => 0,
        },
        Result => {
            Output  => '<video controls poster="http://some.domain/vorschaubild.png" />',
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name   => 'style with remote background image http, NoExtSrcLoad',
        Input  => '<a href="localhost" style="background-image:url(http://localhost:8000/css-background)">localhost</a>',
        Config => {
            NoExtSrcLoad => 1,
        },
        Result => {
            Output  => '<a href="localhost">localhost</a>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => 'style with remote background image hTTp, NoExtSrcLoad',
        Input  => '<a href="localhost" style="background-image:url(hTTp://localhost:8000/css-background)">localhost</a>',
        Config => {
            NoExtSrcLoad => 1,
        },
        Result => {
            Output  => '<a href="localhost">localhost</a>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => 'style with remote background image fTp, NoExtSrcLoad',
        Input  => '<a href="localhost" style="background-image:url(fTp://localhost:8000/css-background)">localhost</a>',
        Config => {
            NoExtSrcLoad => 1,
        },
        Result => {
            Output  => '<a href="localhost">localhost</a>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => 'stype with remote background image protocol-relative URL, NoExtSrcLoad',
        Input  => '<a href="localhost" style="background-image:url(//localhost:8000/css-background)">localhost</a>',
        Config => {
            NoExtSrcLoad => 1,
        },
        Result => {
            Output  => '<a href="localhost">localhost</a>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => 'style with remote background image, allowed',
        Input  => '<a href="localhost" style="background-image:url(http://localhost:8000/css-background)">localhost</a>',
        Config => {
        },
        Result => {
            Output  => '<a href="localhost" style="background-image:url(http://localhost:8000/css-background)">localhost</a>',
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name   => 'style with local background image, NoIntSrcLoad',
        Input  => '<a href="localhost" style="background-image:url(/local/css-background)">localhost</a>',
        Config => {
            NoIntSrcLoad => 1,
        },
        Result => {
            Output  => '<a href="localhost">localhost</a>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => 'style with local background image, allowed',
        Input  => '<a href="localhost" style="background-image:url(/local/css-background)">localhost</a>',
        Config => {
        },
        Result => {
            Output  => '<a href="localhost" style="background-image:url(/local/css-background)">localhost</a>',
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name   => 'style with remote css content, NoExtSrcLoad',
        Input  => q|<p style="content:url('http://localhost:8000/css-content');"></p>|,
        Config => {
            NoExtSrcLoad => 1,
        },
        Result => {
            Output  => '<p></p>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => 'style remote css content, allowed',
        Input  => q|<p style="content:url('http://localhost:8000/css-content');"></p>|,
        Config => {
        },
        Result => {
            Output  => q|<p style="content:url(&#39;http://localhost:8000/css-content&#39;);"></p>|,
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name   => 'style with local css content, NoIntSrcLoad',
        Input  => q|<p style="content:url('/local/css-content');"></p>|,
        Config => {
            NoIntSrcLoad => 1,
        },
        Result => {
            Output  => '<p></p>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        Name   => 'style with local css content, allowed',
        Input  => q|<p style="content:url('/local/css-content');"></p>|,
        Config => {
        },
        Result => {
            Output  => q|<p style="content:url(&#39;/local/css-content&#39;);"></p>|,
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        Name   => 'style with local css content, uppercase URL, allowed',
        Input  => q|<p style="content:URL('/local/css-content');"></p>|,
        Config => {
        },
        Result => {
            Output  => q|<p style="content:URL(&#39;/local/css-content&#39;);"></p>|,
            Replace => 0,
        },
        Line => __LINE__,
    },
    {
        # with tag mismatch div,h6
        Name   => 'style with local css content, uppercase URL, NoIntSrcLoad ',
        Input  => q|<div style="content:URL('/local/css-content');"></h6>|,
        Config => {
            NoIntSrcLoad => 1,
        },
        Result => {
            Output  => '<div></h6>',
            Replace => 1,
        },
        Line => __LINE__,
    },
    {
        # svg attachments might contain XML declaration and DOCTYPE declaration
        Name  => 'svg with XML and DOCTYPE declarations',
        Input => <<'END_SVG',
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg version="1.1" baseProfile="full" xmlns="http://www.w3.org/2000/svg">
<polygon id="triangle" points="0,0 0,50 50,0" fill='#009900' stroke="#004400"/>
</svg>
END_SVG
        Config => {
            NoApplet     => 1,
            NoObject     => 1,
            NoEmbed      => 1,
            NoSVG        => 0,
            NoIntSrcLoad => 0,
            NoExtSrcLoad => 0,
            NoJavaScript => 1,
        },
        Result => {
            Replace => 0,
            Output  => <<'END_SVG',



<svg version="1.1" baseprofile="full" xmlns="http://www.w3.org/2000/svg">
<polygon id="triangle" points="0,0 0,50 50,0" fill="#009900" stroke="#004400" />
</svg>
END_SVG
        },
        Line => __LINE__,
    },
);

for my $Test (@TestsWithExplicitConfig) {

    # pass the explicit config
    my %Result = $HTMLUtilsObject->Safety(
        String => $Test->{Input},
        $Test->{Config}->%*,
    );

    subtest "$Test->{Name} (line @{[ $Test->{Line} // '???' ]})" => sub {

        my $ToDo = $Test->{Todo} ? todo( $Test->{Todo} ) : undef;

        if ( $Test->{Result}->{Replace} ) {
            ok( $Result{Replace}, 'replaced' );
        }
        else {
            ok( !$Result{Replace}, 'not replaced', );
        }
        is( $Result{String}, $Test->{Result}->{Output}, 'output' );
    };
}

done_testing;
