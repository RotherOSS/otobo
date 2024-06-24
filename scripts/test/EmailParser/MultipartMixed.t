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
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::EmailParser ();

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my @Tests = (
    {
        Line     => __LINE__,
        Name     => "plain email with ascii and utf-8 part",
        RawEmail => "$Home/scripts/test/sample/EmailParser/MultipartMixedPlain.eml",
        Body     => 'first part



second part äöø',
        Attachments => [

            # Look for the concatenated plain body part that was converted to utf-8.
            {
                'Charset' => 'utf-8',
                'Content' => 'first part



second part äöø',
                'ContentID'       => undef,
                'ContentLocation' => undef,
                'ContentType'     => 'text/plain; charset=utf-8',
                'Disposition'     => undef,
                'Filename'        => 'file-1',
                'Filesize'        => 32,
                'MimeType'        => 'text/plain'
            },

            # Look for the attachment.
            {
                'Charset'            => '',
                'Content'            => "1\n",
                'ContentDisposition' => "attachment; filename=1.txt\n",
                'ContentID'          => undef,
                'ContentLocation'    => undef,
                'ContentType'        => 'text/plain; name="1.txt"',
                'Disposition'        => 'attachment; filename=1.txt',
                'Filename'           => '1.txt',
                'Filesize'           => 2,
                'MimeType'           => 'text/plain'
            }
        ],
    },
    {
        Line     => __LINE__,
        Name     => "HTML email with ascii and utf-8 part",
        RawEmail => "$Home/scripts/test/sample/EmailParser/MultipartMixedHTML.eml",
        Body     => 'first part



second part äöø',
        Attachments => [

            # Look for the plain body part.
            {
                'Charset' => 'utf-8',
                'Content' => 'first part



second part äöø',
                'ContentAlternative' => 1,
                'ContentID'          => undef,
                'ContentLocation'    => undef,
                'ContentType'        => 'text/plain; charset=utf-8',
                'Disposition'        => undef,
                'Filename'           => 'file-1',
                'Filesize'           => 32,
                'MimeType'           => 'text/plain'
            },

            # Look for the concatenated HTML body part that was converted to utf-8.
            {
                'Charset' => 'utf-8',
                'Content' =>
                    '<html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class=""><b class="">first</b> part<div class=""><br class=""></div><div class=""></div></body></html><html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class=""><div class=""></div><div class=""><br class=""></div><div class="">second part äöø</div></body></html>',
                'ContentAlternative' => 1,
                'ContentID'          => undef,
                'ContentLocation'    => undef,
                'ContentType'        => 'text/html; charset=utf-8',
                'Disposition'        => undef,
                'Filename'           => 'file-2',
                'Filesize'           => 590,
                'MimeType'           => 'text/html'
            },

            # Look for the attachment.
            {
                'Charset'            => '',
                'Content'            => "1\n",
                'ContentAlternative' => 1,
                'ContentDisposition' => "attachment; filename=1.txt\n",
                'ContentID'          => undef,
                'ContentLocation'    => undef,
                'ContentType'        => 'text/plain; name="1.txt"',
                'Disposition'        => 'attachment; filename=1.txt',
                'Filename'           => '1.txt',
                'Filesize'           => 2,
                'MimeType'           => 'text/plain'
            }
        ],
    },
    {
        Line     => __LINE__,
        Name     => "mixed email with plain and HTML part",
        RawEmail => "$Home/scripts/test/sample/EmailParser/MultipartMixedPlainHTML.eml",
        Body     => 'Hello,

This is the forwarded message...

--
Met vriendelijke groeten,
Erik Thijs

    Hi,
 
This mail is composed in html format.
 
Cheers,
Erik
',
        Attachments => [
            {
                'Charset' => 'utf-8',
                'Content' => 'Hello,

This is the forwarded message...

--
Met vriendelijke groeten,
Erik Thijs

    Hi,
 
This mail is composed in html format.
 
Cheers,
Erik
',
                'ContentID'       => undef,
                'ContentLocation' => undef,
                'ContentType'     => 'text/plain; charset=utf-8',
                'Disposition'     => 'inline',
                'Filename'        => 'file-1',
                'Filesize'        => 148,
                'MimeType'        => 'text/plain'
            },
        ],
    },
    {
        # For some reason the plain part will be turned
        # into HTML and DocumentComplete() will be called on it.
        # That HTML will concatenated to the HTML part.
        Line     => __LINE__,
        Name     => 'mixed email with HTML and plain part',
        RawEmail => "$Home/scripts/test/sample/EmailParser/MultipartMixedHTMLPlain.eml",
        Body     => '    Hi,
 
This mail is composed in html format.
 
Cheers,
Erik
 Hello,

This is the forwarded message...

--
Met vriendelijke groeten,
Erik Thijs

',
        Attachments => [
            {
                Charset => 'utf-8',
                Content => <<'END_HTML' =~ s/\n$//r,
<html>
<head>
<style><!--
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
font-size: 10pt;
font-family:Tahoma
}
--></style>
</head>
<body class='hmmessage'>
Hi,<BR>
&nbsp;<BR>
This <FONT color=#ff0000>mail </FONT>is <FONT color=#00b050>composed </FONT>in <FONT color=#0070c0>html </FONT>format.<BR>

&nbsp;<BR>
Cheers,<BR>
<FONT style="BACKGROUND-COLOR: #ffff00">Erik</FONT><BR></body></html>
<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><style>:root{--ck-color-image-caption-background:hsl(0,0%,97%);--ck-color-image-caption-text:hsl(0,0%,20%);--ck-color-mention-background:hsla(341,100%,30%,.1);--ck-color-mention-text:hsl(341,100%,30%);--ck-color-selector-caption-background:hsl(0,0%,97%);--ck-color-selector-caption-text:hsl(0,0%,20%);--ck-highlight-marker-blue:hsl(201,97%,72%);--ck-highlight-marker-green:hsl(120,93%,68%);--ck-highlight-marker-pink:hsl(345,96%,73%);--ck-highlight-marker-yellow:hsl(60,97%,73%);--ck-highlight-pen-green:hsl(112,100%,27%);--ck-highlight-pen-red:hsl(0,85%,49%);--ck-image-style-spacing:1.5em;--ck-inline-image-style-spacing:calc(var(--ck-image-style-spacing) / 2);--ck-todo-list-checkmark-size:16px;--otobo-colMainLight:#001bff}.table .ck-table-resized{table-layout:fixed}.table table{overflow:hidden;border-collapse:collapse;border-spacing:0;width:100%;height:100%;border:1px double #b2b2b2}.image img,img.image_resized{height:auto}.table td,.table th{overflow-wrap:break-word;position:relative}.table{margin:.9em auto;display:table;}table{font-size:inherit;}.table table td,.table table th{min-width:2em;padding:.4em;border:1px solid #bfbfbf}.table table th{font-weight:700;background:hsla(0,0%,0%,5%)}.table[dir=rtl] th{text-align:right}.table[dir=ltr] th,pre{text-align:left}.page-break{position:relative;clear:both;padding:5px 0;display:flex;align-items:center;justify-content:center}.image img,.image.image_resized&gt;figcaption,.media,.page-break__label{display:block}.page-break::after{content:'';position:absolute;border-bottom:2px dashed #c4c4c4;width:100%}.page-break__label{position:relative;z-index:1;padding:.3em .6em;text-transform:uppercase;border:1px solid #c4c4c4;border-radius:2px;font-family:Helvetica,Arial,Tahoma,Verdana,Sans-Serif;font-size:.75em;font-weight:700;color:#333;background:#fff;box-shadow:2px 2px 1px hsla(0,0%,0%,.15);-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none}.media{clear:both;margin:.9em 0;min-width:15em}ol{list-style-type:decimal}ol ol{list-style-type:lower-latin}ol ol ol{list-style-type:lower-roman}ol ol ol ol{list-style-type:upper-latin}ol ol ol ol ol{list-style-type:upper-roman}ul{list-style-type:disc}ul ul{list-style-type:circle}ul ul ul,ul ul ul ul{list-style-type:square}.image{display:table;clear:both;text-align:center;margin:.9em auto;min-width:50px}.image img{margin:0 auto;max-width:100%;min-width:100%}.image-inline{display:inline-flex;max-width:100%;align-items:flex-start}.image-inline picture{display:flex}.image-inline img,.image-inline picture{flex-grow:1;flex-shrink:1;max-width:100%}.image.image_resized{max-width:100%;display:block;box-sizing:border-box}.image.image_resized img{width:100%}.image&gt;figcaption{display:table-caption;caption-side:bottom;word-break:break-word;color:var(--ck-color-image-caption-text);background-color:var(--ck-color-image-caption-background);padding:.6em;font-size:.75em;outline-offset:-1px}.image-style-block-align-left,.image-style-block-align-right{max-width:calc(100% - var(--ck-image-style-spacing))}.image-style-align-left,.image-style-align-right{clear:none}.image-style-side{float:right;margin-left:var(--ck-image-style-spacing);max-width:50%}.image-style-align-left{float:left;margin-right:var(--ck-image-style-spacing)}.image-style-align-center{margin-left:auto;margin-right:auto}.image-style-align-right{float:right;margin-left:var(--ck-image-style-spacing)}.image-style-block-align-right{margin-right:0;margin-left:auto}.image-style-block-align-left{margin-left:0;margin-right:auto}p+.image-style-align-left,p+.image-style-align-right,p+.image-style-side{margin-top:0}.image-inline.image-style-align-left,.image-inline.image-style-align-right{margin-top:var(--ck-inline-image-style-spacing);margin-bottom:var(--ck-inline-image-style-spacing)}.image-inline.image-style-align-left{margin-right:var(--ck-inline-image-style-spacing)}.image-inline.image-style-align-right{margin-left:var(--ck-inline-image-style-spacing)}.marker-yellow{background-color:var(--ck-highlight-marker-yellow)}.marker-green{background-color:var(--ck-highlight-marker-green)}.marker-pink{background-color:var(--ck-highlight-marker-pink)}.marker-blue{background-color:var(--ck-highlight-marker-blue)}.pen-green,.pen-red{background-color:transparent}.pen-red{color:var(--ck-highlight-pen-red)}.pen-green{color:var(--ck-highlight-pen-green)}blockquote{overflow:hidden;padding:0 0 0 4pt;margin-left:0;margin-right:0;font-style:normal;border-left:solid var(--otobo-colMainLight) 1.5pt}.ck-content[dir=rtl] blockquote{border-left:0;border-right:solid var(--otobo-colMainLight) 1.5pt}code{background-color:hsla(0,0%,78%,.3);padding:.15em;border-radius:2px}hr{margin:15px 0;height:4px;background:#ddd;border:0}pre{padding:1em;color:hsl(0,0%,20.8%);background:hsla(0,0%,78%,.3);border:1px solid #c4c4c4;border-radius:2px;direction:ltr;tab-size:4;white-space:pre-wrap;font-style:normal;min-width:200px}pre code{background:unset;padding:0;border-radius:0}@media print{.page-break{padding:0}.page-break::after{display:none}}</style></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">Hello,<br/>
<br/>
This is the forwarded message...<br/>
<br/>
--<br/>
Met vriendelijke groeten,<br/>
Erik Thijs<br/>
<br/>
</body></html>
END_HTML
                ContentID       => undef,
                ContentLocation => undef,
                ContentType     => 'text/html; charset=utf-8',
                Disposition     => 'inline',
                Filename        => 'file-1.html',
                Filesize        => 5761,
                MimeType        => 'text/html'
            },
        ],
    },
);

for my $Test (@Tests) {
    my @EmailLines;
    {
        open my $MailFH, '<', $Test->{RawEmail};    ## no critic qw(OTOBO::ProhibitOpen)
        @EmailLines = <$MailFH>;
        close $MailFH;
    }

    # create local object
    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@EmailLines,
    );

    my $Body = $EmailParserObject->GetMessageBody;
    is(
        $Body,
        $Test->{Body},
        "$Test->{Name} - body (line $Test->{Line})",
    );

    my @Attachments = $EmailParserObject->GetAttachments;

    # Turn on utf-8 flag for parts that were not converted but are still utf-8 for correct comparison.
    for my $Attachment (@Attachments) {
        if ( $Attachment->{Charset} eq 'utf-8' ) {
            Encode::_utf8_on( $Attachment->{Content} );
        }
    }

    is(
        \@Attachments,
        $Test->{Attachments},
        "$Test->{Name} - attachments (line $Test->{Line})"
    );
}

done_testing;
