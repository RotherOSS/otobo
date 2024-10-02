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
<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><style>/**
 * @license Copyright (c) 2003-2024, CKSource Holding sp. z o.o. All rights reserved.
 * For licensing, see LICENSE.md or https://ckeditor.com/legal/ckeditor-oss-license
 */:root{--ck-color-mention-background:rgba(153,0,48,.1);--ck-color-mention-text:#990030;--ck-highlight-marker-yellow:#fdfd77;--ck-highlight-marker-green:#62f962;--ck-highlight-marker-pink:#fc7899;--ck-highlight-marker-blue:#72ccfd;--ck-highlight-pen-red:#e71313;--ck-highlight-pen-green:#128a00;--ck-color-image-caption-background:#f7f7f7;--ck-color-image-caption-text:#333;--ck-image-style-spacing:1.5em;--ck-inline-image-style-spacing:calc(var(--ck-image-style-spacing)/2);--ck-todo-list-checkmark-size:16px}.ck-content .mention{background:var(--ck-color-mention-background);color:var(--ck-color-mention-text)}.ck-content code{background-color:hsla(0,0%,78%,.3);border-radius:2px;padding:.15em}.ck-content blockquote{border-left:5px solid #ccc;font-style:italic;margin-left:0;margin-right:0;overflow:hidden;padding-left:1.5em;padding-right:1.5em}.ck-content[dir=rtl] blockquote{border-left:0;border-right:5px solid #ccc}.ck-content pre{background:hsla(0,0%,78%,.3);border:1px solid #c4c4c4;border-radius:2px;color:#353535;direction:ltr;font-style:normal;min-width:200px;padding:1em;tab-size:4;text-align:left;white-space:pre-wrap}.ck-content pre code{background:unset;border-radius:0;padding:0}.ck-content .text-tiny{font-size:.7em}.ck-content .text-small{font-size:.85em}.ck-content .text-big{font-size:1.4em}.ck-content .text-huge{font-size:1.8em}.ck-content .marker-yellow{background-color:var(--ck-highlight-marker-yellow)}.ck-content .marker-green{background-color:var(--ck-highlight-marker-green)}.ck-content .marker-pink{background-color:var(--ck-highlight-marker-pink)}.ck-content .marker-blue{background-color:var(--ck-highlight-marker-blue)}.ck-content .pen-red{background-color:transparent;color:var(--ck-highlight-pen-red)}.ck-content .pen-green{background-color:transparent;color:var(--ck-highlight-pen-green)}.ck-content hr{background:#dedede;border:0;height:4px;margin:15px 0}.ck-content .image>figcaption{background-color:var(--ck-color-image-caption-background);caption-side:bottom;color:var(--ck-color-image-caption-text);display:table-caption;font-size:.75em;outline-offset:-1px;padding:.6em;word-break:break-word}.ck-content img.image_resized{height:auto}.ck-content .image.image_resized{box-sizing:border-box;display:block;max-width:100%}.ck-content .image.image_resized img{width:100%}.ck-content .image.image_resized>figcaption{display:block}.ck-content .image.image-style-block-align-left{max-width:calc(100% - var(--ck-image-style-spacing))}.ck-content .image.image-style-align-left{clear:none}.ck-content .image.image-style-side{float:right;margin-left:var(--ck-image-style-spacing);max-width:50%}.ck-content .image.image-style-align-left{float:left;margin-right:var(--ck-image-style-spacing)}.ck-content .image.image-style-align-right{float:right;margin-left:var(--ck-image-style-spacing)}.ck-content .image.image-style-block-align-right{margin-left:auto;margin-right:0}.ck-content .image.image-style-block-align-left{margin-left:0;margin-right:auto}.ck-content .image-style-align-center{margin-left:auto;margin-right:auto}.ck-content .image-style-align-left{float:left;margin-right:var(--ck-image-style-spacing)}.ck-content .image-style-align-right{float:right;margin-left:var(--ck-image-style-spacing)}.ck-content p+.image.image-style-align-left{margin-top:0}.ck-content .image-inline.image-style-align-left{margin-bottom:var(--ck-inline-image-style-spacing);margin-right:var(--ck-inline-image-style-spacing);margin-top:var(--ck-inline-image-style-spacing)}.ck-content .image-inline.image-style-align-right{margin-left:var(--ck-inline-image-style-spacing)}.ck-content .image{clear:both;display:table;margin:.9em auto;min-width:50px;text-align:center}.ck-content .image img{display:block;height:auto;margin:0 auto;max-width:100%;min-width:100%}.ck-content .image-inline{align-items:flex-start;display:inline-flex;max-width:100%}.ck-content .image-inline picture{display:flex}.ck-content .image-inline img{flex-grow:1;flex-shrink:1;max-width:100%}.ck-content ol{list-style-type:decimal}.ck-content ol ol{list-style-type:lower-latin}.ck-content ol ol ol{list-style-type:lower-roman}.ck-content ol ol ol ol{list-style-type:upper-latin}.ck-content ol ol ol ol ol{list-style-type:upper-roman}.ck-content ul{list-style-type:disc}.ck-content ul ul{list-style-type:circle}.ck-content ul ul ul{list-style-type:square}.ck-content .todo-list{list-style:none}.ck-content .todo-list li{margin-bottom:5px;position:relative}.ck-content .todo-list li .todo-list{margin-top:5px}.ck-content .todo-list .todo-list__label>input{-webkit-appearance:none;border:0;display:inline-block;height:var(--ck-todo-list-checkmark-size);left:-25px;margin-left:0;margin-right:-15px;position:relative;right:0;vertical-align:middle;width:var(--ck-todo-list-checkmark-size)}.ck-content[dir=rtl] .todo-list .todo-list__label>input{left:0;margin-left:-15px;margin-right:0;right:-25px}.ck-content .todo-list .todo-list__label>input:before{border:1px solid #333;border-radius:2px;box-sizing:border-box;content:"";display:block;height:100%;position:absolute;transition:box-shadow .25s ease-in-out;width:100%}.ck-content .todo-list .todo-list__label>input:after{border-color:transparent;border-style:solid;border-width:0 calc(var(--ck-todo-list-checkmark-size)/8) calc(var(--ck-todo-list-checkmark-size)/8) 0;box-sizing:content-box;content:"";display:block;height:calc(var(--ck-todo-list-checkmark-size)/2.6);left:calc(var(--ck-todo-list-checkmark-size)/3);pointer-events:none;position:absolute;top:calc(var(--ck-todo-list-checkmark-size)/5.3);transform:rotate(45deg);width:calc(var(--ck-todo-list-checkmark-size)/5.3)}.ck-content .todo-list .todo-list__label>input[checked]:before{background:#26ab33;border-color:#26ab33}.ck-content .todo-list .todo-list__label>input[checked]:after{border-color:#fff}.ck-content .todo-list .todo-list__label .todo-list__label__description{vertical-align:middle}.ck-content .todo-list .todo-list__label.todo-list__label_without-description input[type=checkbox]{position:absolute}.ck-content .media{clear:both;display:block;margin:.9em 0;min-width:15em}.ck-content .page-break{align-items:center;clear:both;display:flex;justify-content:center;padding:5px 0;position:relative}.ck-content .page-break:after{border-bottom:2px dashed #c4c4c4;content:"";position:absolute;width:100%}.ck-content .page-break__label{background:#fff;border:1px solid #c4c4c4;border-radius:2px;box-shadow:2px 2px 1px rgba(0,0,0,.15);color:#333;display:block;font-family:Helvetica,Arial,Tahoma,Verdana,Sans-Serif;font-size:.75em;font-weight:700;padding:.3em .6em;position:relative;text-transform:uppercase;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;z-index:1}
/* OTOBO is a web-based ticketing system for service organisations.

Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
*/.ck-content{text-wrap:wrap;white-space:pre-wrap;font-family:"Helvetica Neue",Helvetica,Arial,sans-serif;font-size:12px;line-height:1.6}.ck-content.ck-editor__editable_inline{padding:15px}.ck-content figure.table{float:left;margin:0 0 0 0}.ck-content p{margin-top:.8em;margin-bottom:.8em}.ck-content h1{font-size:2em}.ck-content h2{font-size:1.5em}.ck-content h3{font-size:1.17em}.ck-content h5{font-size:.83em}.ck-content h6{font-size:.67em}.ck-content blockquote{font-style:normal!important;border-left:solid #000099 1.5pt!important;padding:0 0 0 4pt!important}.ck-content ul,.ck-content ol{padding:0 50px}
.ck-content {}</style></head><body class="ck-content">Hello,<br/>
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
                Filesize        => 8965,
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
