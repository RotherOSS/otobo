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
use Kernel::System::UnitTest::RegisterDriver;    # set up $Kernel::OM and $main::Self

# This setting will be picked up whenever an instance of Kernel::System::Web::Request is created.
local $ENV{SCRIPT_NAME} = 'index.pl';

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Kernel::OM->ObjectParamAdd(
    'Kernel::Output::HTML::Layout' => {
        Lang      => 'de',
        SessionID => 123,
    },
);
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

# Disable global external content blocking.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Frontend::BlockLoadingRemoteContent',
    Value => 0,
);

my @Tests = (
    {
        Line => __LINE__,
        Name => 'cid replacement',
        Data => {
            Content     => '<img src="cid:1234567890ABCDEF">',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<1234567890ABCDEF>',
            },
        },
        Result => {
            ContentType => 'text/html; charset="utf-8"',
            Content     => '<img src="index.pl?Action=SomeAction;FileID=0;SessionID=123">',
        },
    },
    {
        Line => __LINE__,
        Name => 'cid replacement with border attribute',
        Data => {
            Content     => q{<img border="0" src="cid:1234567890ABCDEF">},
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<1234567890ABCDEF>',
            },
        },
        Result => {
            Content     => '<img border="0" src="index.pl?Action=SomeAction;FileID=0;SessionID=123">',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Name => 'cid replacement with newline in start tag',
        Data => {
            Content     => qq{<img border="0" \nsrc="cid:1234567890ABCDEF">},
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<1234567890ABCDEF>',
            },
        },
        Result => {
            Content     => q{<img border="0" src="index.pl?Action=SomeAction;FileID=0;SessionID=123">},
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Name => '',
        Data => {
            Content     => '<img src=cid:1234567890ABCDEF>',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<1234567890ABCDEF>',
            },
        },
        Result => {
            Content =>
                '<img src="index.pl?Action=SomeAction;FileID=0;SessionID=123">',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Name => '',
        Data => {
            Content     => '<img src=cid:1234567890ABCDEF />',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<1234567890ABCDEF>',
            },
        },
        Result => {
            Content     => '<img src="index.pl?Action=SomeAction;FileID=0;SessionID=123" />',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Name => 'cid replacement with single quotes',
        Data => {
            Content     => q{<img src='cid:1234567890ABCDEF' />},
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<1234567890ABCDEF>',
            },
        },
        Result => {
            Content     => q{<img src="index.pl?Action=SomeAction;FileID=0;SessionID=123" />},
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Name => 'mapping via name',
        Data => {
            Content     => q{<img src='Untitled%20Attachment' />},
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<Untitled%20Attachment>',
            },
        },
        Result => {
            Content     => q{<img src="index.pl?Action=SomeAction;FileID=0;SessionID=123" />},
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Name => 'drop script tag',
        Data => {
            Content     => '1<script></script>',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<Untitled%20Attachment>',
            },
        },
        Result => {
            Content     => '1',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Name => 'keep script tag',
        Data => {
            Content     => '1<script></script>',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<Untitled%20Attachment>',
            },
        },
        LoadInlineContent => 1,
        Result            => {
            Content     => '1<script></script>',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Name => 'drop external image',
        Data => {
            Content     => '1<img src="http://google.com"/>',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<Untitled%20Attachment>',
            },
        },
        Result => {
            Content => '

<div style="margin: 5px 0; padding: 0px; border: 1px solid #999; border-radius: 2px; -moz-border-radius: 2px; -webkit-border-radius: 2px;">
    <div style="padding: 5px; background-color: #DDD; font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 11px; text-align: center;">
        Zum Schutz Ihrer Privatsphäre wurden entfernte Inhalte blockiert.
        <a href="index.pl?;LoadExternalImages=1;SessionID=123">Blockierte Inhalte laden.</a>
    </div>
</div>
1',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Name => 'keep external image',
        Data => {
            Content     => 'external images are kept:<img src="http://google.com"/>',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<Untitled%20Attachment>',
            },
        },
        LoadExternalImages => 1,
        Result             => {
            Content     => 'external images are kept:<img src="http://google.com" />',    # space added
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Todo => 'it is not clear how to handle DOCTYPE declarations',
        Name => 'transform content charset',
        Data => {
            Content => <<'EOF',
<!DOCTYPE html SYSTEM "about:legacy-compat">
<html lang="de-de">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
    <p>Some note about UTF8, UTF-8, utf8 and utf-8.</p>
    <p>Some note about ISO-8859-1 and iso-8859-1.</p>
    <p>This line must stay unchanged: charset=iso-8859-1</p>
</body>
</html>
EOF
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<Untitled%20Attachment>',
            },
        },
        LoadExternalImages => 1,
        Result             => {
            Content => <<'EOF',
<!DOCTYPE html SYSTEM "about:legacy-compat">
<html lang="de-de">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
    <p>Some note about UTF8, UTF-8, utf8 and utf-8.</p>
    <p>Some note about ISO-8859-1 and iso-8859-1.</p>
    <p>This line must stay unchanged: charset=iso-8859-1</p>
</body>
</html>
EOF
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Name => 'Charset - iso-8859-1, single quotes translated to &#39;',
        Data => {
            Content     => q{<meta http-equiv="Content-Type" content="text/html; charset='iso-8859-1'">},
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        Attachments => {},
        URL         => 'Action=SomeAction;FileID=',
        Result      => {
            Content     => '<meta http-equiv="Content-Type" content="text/html; charset=&#39;utf-8&#39;">',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Name => 'Charset - Windows-1252',
        Data => {
            Content     => '<meta http-equiv="Content-Type" content="text/html;charset=Windows-1252">',
            ContentType => 'text/html; charset=Windows-1252',
        },
        Attachments => {},
        URL         => 'Action=SomeAction;FileID=',
        Result      => {
            Content     => '<meta http-equiv="Content-Type" content="text/html;charset=utf-8">',
            ContentType => 'text/html; charset=utf-8',
        },
    },
    {
        Line => __LINE__,
        Name => 'Charset - utf-8',
        Data => {
            Content     => '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">',
            ContentType => 'text/html; charset=utf-8',
        },
        Attachments => {},
        URL         => 'Action=SomeAction;FileID=',
        Result      => {
            Content     => '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">',
            ContentType => 'text/html; charset=utf-8',
        },
    },
    {
        Line => __LINE__,
        Name => 'Charset - double quotes translated into &quot;',
        Data => {
            Content     => q{<meta http-equiv='Content-Type' content='text/html; charset="utf-8"'>},
            ContentType => 'text/html; charset="utf-8"',
        },
        Attachments => {},
        URL         => 'Action=SomeAction;FileID=',
        Result      => {
            Content     => q{<meta http-equiv="Content-Type" content="text/html; charset=&quot;utf-8&quot;">},
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Name => 'Charset - no charset defined, see bug#9610',
        Data => {
            Content     => '<meta http-equiv="Content-Type" content="text/html">',
            ContentType => 'text/html',
        },
        Attachments => {},
        URL         => 'Action=SomeAction;FileID=',
        Result      => {
            Content     => '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
    {
        Line => __LINE__,
        Name => 'Empty Content-ID',
        Data => {
            Content     => 'Link <a href="http://test.example">http://test.example</a>',
            ContentType => 'text/html; charset="iso-8859-1"',
        },
        URL         => 'Action=SomeAction;FileID=',
        Attachments => {
            0 => {
                ContentID => '<>',
            },
        },
        LoadExternalImages => 1,
        Result             => {
            Content     => 'Link <a href="http://test.example" target="_blank">http://test.example</a>',
            ContentType => 'text/html; charset="utf-8"',
        },
    },
);

for my $Test (@Tests) {
    subtest "$Test->{Name} (line @{[ $Test->{Line} // '???' ]})" => sub {
        my $ToDo = $Test->{Todo} ? todo( $Test->{Todo} ) : undef;

        my %HTML = $LayoutObject->RichTextDocumentServe(
            $Test->%*,
        );
        is(
            $HTML{Content},
            $Test->{Result}->{Content},
            "Content"
        );
        is(
            $HTML{ContentType},
            $Test->{Result}->{ContentType},
            'ContentType'
        );
    };
}

done_testing;
