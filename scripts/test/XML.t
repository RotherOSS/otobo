# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self

our $Self;

my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');
my $XMLObject      = $Kernel::OM->Get('Kernel::System::XML');

# get helper object so that the table xml_storage is restored after this script
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# First a simple example that shows that mapping of XML to a Perl data structure
subtest 'XMLParse2XMLHash() simple example' => sub {
    my $String = <<'END_XML';
<?xml version="1.0" encoding="utf-8" ?>
<Root desc="Root element">
    Root content
    <Level1a desc="Level1a first element"/>
    more root content which is discarded
    <Level1a desc="Level1a second element"/>
    <Level1a desc="Level1a third element with content">Level1a third element content</Level1a>
    <Level1a desc="Level1a fourth element with sublevel">
        <Level2a desc="Level2a first element"/>
        <Level2b desc="Level2b first element"/>
        <Level2b desc="Level2b second element"/>
    </Level1a>
    <Level1a desc="Level1a fifth element with content sublevel">
        sublevels follow
        <Level2c desc="Level2c first element"/>
        <Level2c desc="Level2c second element"/>
        <Level2c desc="Level2c third element">
            <Level3a desc='a little bit deeper'/>
        </Level2c>
        <Level2c/>
    </Level1a>
    <Level1b desc="also on first level, but a different name"/>
    <Level1c attr1="first attribute" attr2="second attribute"/>
    <Level1d/>
    <Level1a desc="Level1a after Level1d"/>
</Root>
END_XML

    my @XMLHash = $XMLObject->XMLParse2XMLHash( String => $String );

    my @ExpectedXMLHash = (
        undef,
        {
            'Root' => [
                undef,
                {
                    'Content' => '
    Root content
    ',
                    'Level1a' => [
                        undef,
                        {
                            'Content' => '',
                            'desc'    => 'Level1a first element'
                        },
                        {
                            'Content' => '',
                            'desc'    => 'Level1a second element'
                        },
                        {
                            'Content' => 'Level1a third element content',
                            'desc'    => 'Level1a third element with content'
                        },
                        {
                            'Content' => '
        ',
                            'Level2a' => [
                                undef,
                                {
                                    'Content' => '',
                                    'desc'    => 'Level2a first element'
                                }
                            ],
                            'Level2b' => [
                                undef,
                                {
                                    'Content' => '',
                                    'desc'    => 'Level2b first element'
                                },
                                {
                                    'Content' => '',
                                    'desc'    => 'Level2b second element'
                                }
                            ],
                            'desc' => 'Level1a fourth element with sublevel'
                        },
                        {
                            'Content' => '
        sublevels follow
        ',
                            'Level2c' => [
                                undef,
                                {
                                    'Content' => '',
                                    'desc'    => 'Level2c first element'
                                },
                                {
                                    'Content' => '',
                                    'desc'    => 'Level2c second element'
                                },
                                {
                                    'Content' => '
            ',
                                    'Level3a' => [
                                        undef,
                                        {
                                            'Content' => '',
                                            'desc'    => 'a little bit deeper'
                                        }
                                    ],
                                    'desc' => 'Level2c third element'
                                },
                                {
                                    'Content' => ''
                                }
                            ],
                            'desc' => 'Level1a fifth element with content sublevel'
                        },
                        {
                            'Content' => '',
                            'desc'    => 'Level1a after Level1d'
                        }
                    ],
                    'Level1b' => [
                        undef,
                        {
                            'Content' => '',
                            'desc'    => 'also on first level, but a different name'
                        }
                    ],
                    'Level1c' => [
                        undef,
                        {
                            'Content' => '',
                            'attr1'   => 'first attribute',
                            'attr2'   => 'second attribute'
                        }
                    ],
                    'Level1d' => [
                        undef,
                        {
                            'Content' => ''
                        }
                    ],
                    'desc' => 'Root element'
                }
            ]
        }
    );

    is(
        \@XMLHash,
        \@ExpectedXMLHash,
        'simple example'
    );

    # the method MLHash2D() changes the passed in XMLHash as a side effect
    my %ValueHash = $XMLObject->XMLHash2D( XMLHash => \@XMLHash );

    my @ExpectedChangedXMLHash = (
        undef,
        {
            'Root' => [
                undef,
                {
                    'Content' => '
    Root content
    ',
                    'Level1a' => [
                        undef,
                        {
                            'Content' => '',
                            'TagKey'  => '[1]{\'Root\'}[1]{\'Level1a\'}[1]',
                            'desc'    => 'Level1a first element'
                        },
                        {
                            'Content' => '',
                            'TagKey'  => '[1]{\'Root\'}[1]{\'Level1a\'}[2]',
                            'desc'    => 'Level1a second element'
                        },
                        {
                            'Content' => 'Level1a third element content',
                            'TagKey'  => '[1]{\'Root\'}[1]{\'Level1a\'}[3]',
                            'desc'    => 'Level1a third element with content'
                        },
                        {
                            'Content' => '
        ',
                            'Level2a' => [
                                undef,
                                {
                                    'Content' => '',
                                    'TagKey'  => '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2a\'}[1]',
                                    'desc'    => 'Level2a first element'
                                }
                            ],
                            'Level2b' => [
                                undef,
                                {
                                    'Content' => '',
                                    'TagKey'  => '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2b\'}[1]',
                                    'desc'    => 'Level2b first element'
                                },
                                {
                                    'Content' => '',
                                    'TagKey'  => '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2b\'}[2]',
                                    'desc'    => 'Level2b second element'
                                }
                            ],
                            'TagKey' => '[1]{\'Root\'}[1]{\'Level1a\'}[4]',
                            'desc'   => 'Level1a fourth element with sublevel'
                        },
                        {
                            'Content' => '
        sublevels follow
        ',
                            'Level2c' => [
                                undef,
                                {
                                    'Content' => '',
                                    'TagKey'  => '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[1]',
                                    'desc'    => 'Level2c first element'
                                },
                                {
                                    'Content' => '',
                                    'TagKey'  => '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[2]',
                                    'desc'    => 'Level2c second element'
                                },
                                {
                                    'Content' => '
            ',
                                    'Level3a' => [
                                        undef,
                                        {
                                            'Content' => '',
                                            'TagKey'  => '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[3]{\'Level3a\'}[1]',
                                            'desc'    => 'a little bit deeper'
                                        }
                                    ],
                                    'TagKey' => '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[3]',
                                    'desc'   => 'Level2c third element'
                                },
                                {
                                    'Content' => '',
                                    'TagKey'  => '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[4]'
                                }
                            ],
                            'TagKey' => '[1]{\'Root\'}[1]{\'Level1a\'}[5]',
                            'desc'   => 'Level1a fifth element with content sublevel'
                        },
                        {
                            'Content' => '',
                            'TagKey'  => '[1]{\'Root\'}[1]{\'Level1a\'}[6]',
                            'desc'    => 'Level1a after Level1d'
                        }
                    ],
                    'Level1b' => [
                        undef,
                        {
                            'Content' => '',
                            'TagKey'  => '[1]{\'Root\'}[1]{\'Level1b\'}[1]',
                            'desc'    => 'also on first level, but a different name'
                        }
                    ],
                    'Level1c' => [
                        undef,
                        {
                            'Content' => '',
                            'TagKey'  => '[1]{\'Root\'}[1]{\'Level1c\'}[1]',
                            'attr1'   => 'first attribute',
                            'attr2'   => 'second attribute'
                        }
                    ],
                    'Level1d' => [
                        undef,
                        {
                            'Content' => '',
                            'TagKey'  => '[1]{\'Root\'}[1]{\'Level1d\'}[1]'
                        }
                    ],
                    'TagKey' => '[1]{\'Root\'}[1]',
                    'desc'   => 'Root element'
                }
            ],
            'TagKey' => '[1]'
        }
    );
    is(
        \@XMLHash,
        \@ExpectedChangedXMLHash,
        'XMLHash changed by XMLHash2D()'
    );

    my %ExpectedValueHash = (
        '[1]{\'Root\'}[1]{\'Content\'}' => '
    Root content
    ',
        '[1]{\'Root\'}[1]{\'Level1a\'}[1]{\'Content\'}' => '',
        '[1]{\'Root\'}[1]{\'Level1a\'}[1]{\'TagKey\'}'  => '[1]{\'Root\'}[1]{\'Level1a\'}[1]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[1]{\'desc\'}'    => 'Level1a first element',
        '[1]{\'Root\'}[1]{\'Level1a\'}[2]{\'Content\'}' => '',
        '[1]{\'Root\'}[1]{\'Level1a\'}[2]{\'TagKey\'}'  => '[1]{\'Root\'}[1]{\'Level1a\'}[2]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[2]{\'desc\'}'    => 'Level1a second element',
        '[1]{\'Root\'}[1]{\'Level1a\'}[3]{\'Content\'}' => 'Level1a third element content',
        '[1]{\'Root\'}[1]{\'Level1a\'}[3]{\'TagKey\'}'  => '[1]{\'Root\'}[1]{\'Level1a\'}[3]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[3]{\'desc\'}'    => 'Level1a third element with content',
        '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Content\'}' => '
        ',
        '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2a\'}[1]{\'Content\'}' => '',
        '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2a\'}[1]{\'TagKey\'}'  => '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2a\'}[1]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2a\'}[1]{\'desc\'}'    => 'Level2a first element',
        '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2b\'}[1]{\'Content\'}' => '',
        '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2b\'}[1]{\'TagKey\'}'  => '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2b\'}[1]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2b\'}[1]{\'desc\'}'    => 'Level2b first element',
        '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2b\'}[2]{\'Content\'}' => '',
        '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2b\'}[2]{\'TagKey\'}'  => '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2b\'}[2]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'Level2b\'}[2]{\'desc\'}'    => 'Level2b second element',
        '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'TagKey\'}'                  => '[1]{\'Root\'}[1]{\'Level1a\'}[4]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[4]{\'desc\'}'                    => 'Level1a fourth element with sublevel',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Content\'}'                 => '
        sublevels follow
        ',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[1]{\'Content\'}' => '',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[1]{\'TagKey\'}'  => '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[1]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[1]{\'desc\'}'    => 'Level2c first element',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[2]{\'Content\'}' => '',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[2]{\'TagKey\'}'  => '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[2]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[2]{\'desc\'}'    => 'Level2c second element',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[3]{\'Content\'}' => '
            ',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[3]{\'Level3a\'}[1]{\'Content\'}' => '',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[3]{\'Level3a\'}[1]{\'TagKey\'}'  => '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[3]{\'Level3a\'}[1]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[3]{\'Level3a\'}[1]{\'desc\'}'    => 'a little bit deeper',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[3]{\'TagKey\'}'                  => '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[3]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[3]{\'desc\'}'                    => 'Level2c third element',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[4]{\'Content\'}'                 => '',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[4]{\'TagKey\'}'                  => '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'Level2c\'}[4]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'TagKey\'}'                                  => '[1]{\'Root\'}[1]{\'Level1a\'}[5]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[5]{\'desc\'}'                                    => 'Level1a fifth element with content sublevel',
        '[1]{\'Root\'}[1]{\'Level1a\'}[6]{\'Content\'}'                                 => '',
        '[1]{\'Root\'}[1]{\'Level1a\'}[6]{\'TagKey\'}'                                  => '[1]{\'Root\'}[1]{\'Level1a\'}[6]',
        '[1]{\'Root\'}[1]{\'Level1a\'}[6]{\'desc\'}'                                    => 'Level1a after Level1d',
        '[1]{\'Root\'}[1]{\'Level1b\'}[1]{\'Content\'}'                                 => '',
        '[1]{\'Root\'}[1]{\'Level1b\'}[1]{\'TagKey\'}'                                  => '[1]{\'Root\'}[1]{\'Level1b\'}[1]',
        '[1]{\'Root\'}[1]{\'Level1b\'}[1]{\'desc\'}'                                    => 'also on first level, but a different name',
        '[1]{\'Root\'}[1]{\'Level1c\'}[1]{\'Content\'}'                                 => '',
        '[1]{\'Root\'}[1]{\'Level1c\'}[1]{\'TagKey\'}'                                  => '[1]{\'Root\'}[1]{\'Level1c\'}[1]',
        '[1]{\'Root\'}[1]{\'Level1c\'}[1]{\'attr1\'}'                                   => 'first attribute',
        '[1]{\'Root\'}[1]{\'Level1c\'}[1]{\'attr2\'}'                                   => 'second attribute',
        '[1]{\'Root\'}[1]{\'Level1d\'}[1]{\'Content\'}'                                 => '',
        '[1]{\'Root\'}[1]{\'Level1d\'}[1]{\'TagKey\'}'                                  => '[1]{\'Root\'}[1]{\'Level1d\'}[1]',
        '[1]{\'Root\'}[1]{\'TagKey\'}'                                                  => '[1]{\'Root\'}[1]',
        '[1]{\'Root\'}[1]{\'desc\'}'                                                    => 'Root element',
        '[1]{\'TagKey\'}'                                                               => '[1]'
    );
    is(
        \%ValueHash,
        \%ExpectedValueHash,
        'ValueHash created by XMLHash2D()'
    );
};

subtest 'XMLParse2XMLHash() with an iso-8859-1 encoded XML' => sub {

    my $String = '<?xml version="1.0" encoding="iso-8859-1" ?>
    <Contact>
      <Name type="long">' . "\x{00FC}" . ' Some Test</Name>
    </Contact>
';
    my @XMLHash = $XMLObject->XMLParse2XMLHash( String => $String );
    ok(
        $#XMLHash == 1 && $XMLHash[1]->{Contact},
        'XMLParse2XMLHash()',
    );
    is(
        $XMLHash[1]->{Contact}->[1]->{Name}->[1]->{type} || '',
        'long',
        'Contact->Name->type',
    );

    # test charset specific situations
    is(
        $XMLHash[1]->{Contact}->[1]->{Name}->[1]->{Content} || '',
        "ü Some Test",
        'Contact->Name->Content',
    );
    ok(
        Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{Name}->[1]->{Content} ) || '',
        'Contact->Name->type) Encode::is_utf8',
    );
};

subtest 'XMLParse2XMLHash() with utf-8 encoded xml' => sub {
    my $String = '<?xml version="1.0" encoding="utf-8" ?>
    <Contact role="admin" type="organization">
      <GermanText>German Umlaute öäü ÄÜÖ ß</GermanText>
      <JapanText>Japan カスタ</JapanText>
      <ChineseText>Chinese 用迎使用</ChineseText>
      <BulgarianText>Bulgarian Език</BulgarianText>
    </Contact>
';

    my @XMLHash = $XMLObject->XMLParse2XMLHash( String => $String );
    ok(
        $#XMLHash == 1 && $XMLHash[1]->{Contact},
        'XMLParse2XMLHash()',
    );
    is(
        $XMLHash[1]->{Contact}->[1]->{role} || '',
        'admin',
        'Contact->role',
    );

    # test charset specific situations
    is(
        $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} || '',
        'German Umlaute öäü ÄÜÖ ß',
        'Contact->GermanText',
    );
    ok(
        Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
        'Contact->GermanText Encode::is_utf8',
    );
    is(
        $XMLHash[1]->{Contact}->[1]->{JapanText}->[1]->{Content} || '',
        'Japan カスタ',
        'Contact->JapanText',
    );
    ok(
        Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{JapanText}->[1]->{Content} ) || '',
        'Contact->JapanText Encode::is_utf8',
    );
    is(
        $XMLHash[1]->{Contact}->[1]->{ChineseText}->[1]->{Content} || '',
        'Chinese 用迎使用',
        'Contact->ChineseText',
    );
    ok(
        Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{ChineseText}->[1]->{Content} ) || '',
        'Contact->ChineseText Encode::is_utf8',
    );
    is(
        $XMLHash[1]->{Contact}->[1]->{BulgarianText}->[1]->{Content} || '',
        'Bulgarian Език',
        'Contact->BulgarianText',
    );
    ok(
        Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{BulgarianText}->[1]->{Content} ) || '',
        'Contact->BulgarianText Encode::is_utf8',
    );
};

subtest 'XMLParse2XMLHash() with mixed content' => sub {
    my $String = <<'END_XML';
<?xml version="1.0" encoding="utf-8" ?>
<MixedContent>
      text A (not discarded)
      <Tag>Element 1</Tag>
      text B (discarded)
      text C (discarded)
      <Tag count="2">Element 2</Tag>
      <Tag>Element 3</Tag>
      text D (discarded)
      <Tag>Element 4</Tag>
      text E (discarded)
</MixedContent>
END_XML

    my @XMLHash         = $XMLObject->XMLParse2XMLHash( String => $String );
    my @ExpectedXMLHash = (
        undef,
        {
            'MixedContent' => [
                undef,
                {
                    'Content' => '
      text A (not discarded)
      ',
                    'Tag' => [
                        undef,
                        {
                            'Content' => 'Element 1',
                        },
                        {
                            'Content' => 'Element 2',
                            count     => '2',
                        },
                        {
                            'Content' => 'Element 3'
                        },
                        {
                            'Content' => 'Element 4'
                        }
                    ]
                }
            ]
        }
    );

    is(
        \@XMLHash,
        \@ExpectedXMLHash,
        'mixed content is not handled'
    );
};

subtest 'XMLParse2XMLHash() with Tag "Content" ' => sub {
    my $String = <<'END_XML';
<?xml version="1.0" encoding="utf-8" ?>
<Foo>the real content<Content>the imposter content</Content></Foo>
END_XML
    my $Exception = dies { $XMLObject->XMLParse2XMLHash( String => $String ) };
    ok( $Exception, 'XML can\'t be parsed' );
    like( $Exception, qr/Can't use string/, 'some mixup with the tag Content' );
};

# Serialize a more extravagant data structure.
# Note that not all elements end up in the result. And that
# some values are not strings but hashrefs.
# This behavior is more or less fine, as these cases are not supported.
{
    my @FunnyXMLHash = (
        'ignored',
        ['ignored'],
        {
            key1 => 'val1',
        },
        {
            key2 => 'val2',
        },
        undef,
        undef,
        {
            ignored  => undef,
            hashref  => { a => { b => { c => { d => undef } } } },                                   # nested hashrefs are not handled well
            arrayref => [ 'A', undef, '', 1234, -2, [ ('B') x 5, 'C' x 4 ], { key3 => 'val3' } ],    # all ignored but the hashref
            string   => 'DDDDDDDD',
            number   => -123123_5,
            empty    => '',
            zero     => 0,
        }
    );

    # Note that some content is discarded and some values are hashrefs,
    # which can't be inserted into the database.
    my %ValueHash         = $XMLObject->XMLHash2D( XMLHash => \@FunnyXMLHash );
    my %ExpectedValueHash = (
        '[2]{\'TagKey\'}'                  => '[2]',
        '[2]{\'key1\'}'                    => 'val1',
        '[3]{\'TagKey\'}'                  => '[3]',
        '[3]{\'key2\'}'                    => 'val2',
        '[6]{\'TagKey\'}'                  => '[6]',
        '[6]{\'arrayref\'}[1]{\'TagKey\'}' => '[6]{\'arrayref\'}[1]',
        '[6]{\'arrayref\'}[1]{\'key3\'}'   => 'val3',
        '[6]{\'empty\'}'                   => '',
        '[6]{\'hashref\'}'                 => {
            'TagKey' => '[6]{\'hashref\'}[1]',
            'a'      => {
                'TagKey' => '[6]{\'hashref\'}[1]{\'a\'}[1]',
                'b'      => {
                    'TagKey' => '[6]{\'hashref\'}[1]{\'a\'}[1]{\'b\'}[1]',
                    'c'      => {
                        'TagKey' => '[6]{\'hashref\'}[1]{\'a\'}[1]{\'b\'}[1]{\'c\'}[1]',
                        'd'      => undef
                    }
                }
            }
        },
        '[6]{\'hashref\'}[1]{\'TagKey\'}' => '[6]{\'hashref\'}[1]',
        '[6]{\'hashref\'}[1]{\'a\'}'      => {
            'TagKey' => '[6]{\'hashref\'}[1]{\'a\'}[1]',
            'b'      => {
                'TagKey' => '[6]{\'hashref\'}[1]{\'a\'}[1]{\'b\'}[1]',
                'c'      => {
                    'TagKey' => '[6]{\'hashref\'}[1]{\'a\'}[1]{\'b\'}[1]{\'c\'}[1]',
                    'd'      => undef
                }
            }
        },
        '[6]{\'hashref\'}[1]{\'a\'}[1]{\'TagKey\'}' => '[6]{\'hashref\'}[1]{\'a\'}[1]',
        '[6]{\'hashref\'}[1]{\'a\'}[1]{\'b\'}'      => {
            'TagKey' => '[6]{\'hashref\'}[1]{\'a\'}[1]{\'b\'}[1]',
            'c'      => {
                'TagKey' => '[6]{\'hashref\'}[1]{\'a\'}[1]{\'b\'}[1]{\'c\'}[1]',
                'd'      => undef
            }
        },
        '[6]{\'hashref\'}[1]{\'a\'}[1]{\'b\'}[1]{\'TagKey\'}' => '[6]{\'hashref\'}[1]{\'a\'}[1]{\'b\'}[1]',
        '[6]{\'hashref\'}[1]{\'a\'}[1]{\'b\'}[1]{\'c\'}'      => {
            'TagKey' => '[6]{\'hashref\'}[1]{\'a\'}[1]{\'b\'}[1]{\'c\'}[1]',
            'd'      => undef
        },
        '[6]{\'hashref\'}[1]{\'a\'}[1]{\'b\'}[1]{\'c\'}[1]{\'TagKey\'}' => '[6]{\'hashref\'}[1]{\'a\'}[1]{\'b\'}[1]{\'c\'}[1]',
        '[6]{\'number\'}'                                               => -1231235,
        '[6]{\'string\'}'                                               => 'DDDDDDDD',
        '[6]{\'zero\'}'                                                 => 0
    );
    is( \%ValueHash, \%ExpectedValueHash, 'funny data structure' );
}

my $String = '<?xml version="1.0" encoding="utf-8" ?>
    <Contact role="admin" type="organization">
      <Name type="long">Example Inc.</Name>
      <Email type="primary">info@exampe.com<Domain>1234.com</Domain></Email>
      <Email type="secundary">sales@example.com</Email>
      <Telephone country="germany">+49-999-99999</Telephone>
      <Telephone2 country="" extension="123"></Telephone2>
      <Telephone3 country="" extension="123"/>
      <SpecialCharacters>\'</SpecialCharacters>
      <SpecialCharacters1>\\\'</SpecialCharacters1>
      <SpecialCharacters2>0</SpecialCharacters2>
      <GermanText>German Umlaute öäü ÄÜÖ ß</GermanText>
      <Quote>Test &amp;amp; Test &amp;lt; &amp;&lt;&gt;&quot;</Quote>
      <Quote Name="Test &amp;amp; Test &amp;lt; &amp;&lt;&gt;&quot;">Some Text</Quote>
    </Contact>
';

my @XMLHash = $XMLObject->XMLParse2XMLHash( String => $String );
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact},
    '#3 XMLParse2XMLHash()',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{role} || '',
    'admin',
    '#3 XMLParse2XMLHash() (Contact->role)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{Telephone}->[1]->{country} || '',
    'germany',
    '#3 XMLParse2XMLHash() (Contact->Telephone->country)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{Telephone2}->[1]->{Content},
    '',
    '#3 XMLParse2XMLHash() (Contact->Telephone2)',
);
my $CountryDefined = $XMLHash[1]->{Contact}->[1]->{Telephone2}->[1]->{country};
$Self->Is(
    $CountryDefined,
    '',
    '#3 XMLParse2XMLHash() (Contact->Telephone2->country)',
);
my $CountryUndefined = $XMLHash[1]->{Contact}->[1]->{Telephone2}->[1]->{country2};
$Self->Is(
    $CountryUndefined,
    undef,
    '#3 XMLParse2XMLHash() (Contact->Telephone2->country2) - undef',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{Telephone3}->[1]->{Content},
    '',
    '#3 XMLParse2XMLHash() (Contact->Telephone3)',
);
$CountryDefined = $XMLHash[1]->{Contact}->[1]->{Telephone3}->[1]->{country};
$Self->Is(
    $CountryDefined,
    '',
    '#3 XMLParse2XMLHash() (Contact->Telephone3->country)',
);
$CountryUndefined = $XMLHash[1]->{Contact}->[1]->{Telephone3}->[1]->{country2};
$Self->Is(
    $CountryUndefined,
    undef,
    '#3 XMLParse2XMLHash() (Contact->Telephone3->country2) - undef',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{SpecialCharacters}->[1]->{Content} || '',
    '\'',
    '#3 XMLParse2XMLHash() (Contact->SpecialCharacters)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{SpecialCharacters1}->[1]->{Content} || '',
    '\\\'',
    '#3 XMLParse2XMLHash() (Contact->SpecialCharacters1)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{SpecialCharacters2}->[1]->{Content},
    0,
    '#3 XMLParse2XMLHash() (Contact->SpecialCharacters2)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{Quote}->[1]->{Content},
    'Test &amp; Test &lt; &<>"',
    '#3 XMLParse2XMLHash() (Contact->Quote)',
);
$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{Quote}->[2]->{Name},
    'Test &amp; Test &lt; &<>"',
    '#3 XMLParse2XMLHash() (Contact->Quote->Name)',
);

$Self->Is(
    $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} || '',
    'German Umlaute öäü ÄÜÖ ß',
    '#3 XMLParse2XMLHash() (Contact->GermanText)',
);
$Self->True(
    Encode::is_utf8( $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
    '#3 XMLParse2XMLHash() (Contact->GermanText) Encode::is_utf8',
);

# enter the @XMLHash into the database, retrieve and delete it
for my $Key ( 'Some\'Key', '123' ) {
    my $XMLHashAdd = $XMLObject->XMLHashAdd(
        Type    => 'SomeType',
        Key     => $Key,
        XMLHash => \@XMLHash,
    );
    $Self->Is(
        $XMLHashAdd || '',
        $Key,
        "#3 ($Key) XMLHashAdd() (Key=$Key)",
    );
    my @XMLHashGet = $XMLObject->XMLHashGet(
        Type => 'SomeType',
        Key  => $Key,
    );

    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{role} eq 'admin',
        "#3 ($Key) XMLHashGet() (admin) - from db",
    );
    $Self->True(
        $#XMLHashGet == 1
            && $XMLHashGet[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
        "#3 ($Key) XMLHashGet() (Telephone->country)",
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
        "#3 ($Key) XMLHashGet() (Telephone2)",
    );

    $Self->Is(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
        'German Umlaute öäü ÄÜÖ ß',
        "#3 ($Key) XMLHashGet() (GermanText)",
    );
    $Self->True(
        Encode::is_utf8( $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
        "#3 ($Key) XMLHashGet() (GermanText) - Encode::is_utf8",
    );

    @XMLHashGet = $XMLObject->XMLHashGet(
        Type  => 'SomeType',
        Key   => $Key,
        Cache => 1,
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{role} eq 'admin',
        "#3 ($Key) XMLHashGet() (admin) - with cache",
    );
    $Self->True(
        $#XMLHashGet == 1
            && $XMLHashGet[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
        "#3 ($Key) XMLHashGet() (Telephone->country)",
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
        "#3 ($Key) XMLHashGet() (Telephone2)",
    );

    $Self->Is(
        $#XMLHashGet == 1 && $XMLHash[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
        'German Umlaute öäü ÄÜÖ ß',
        "#3 utf8($Key) XMLHashGet() (GermanText)",
    );
    $Self->True(
        Encode::is_utf8( $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
        "#3 ($Key) XMLHashGet() (GermanText) - Encode::is_utf8",
    );

    @XMLHashGet = $XMLObject->XMLHashGet(
        Type  => 'SomeType',
        Key   => $Key,
        Cache => 0,
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{role} eq 'admin',
        "#3 ($Key) XMLHashGet() (admin) - without cache",
    );
    $Self->True(
        $#XMLHashGet == 1
            && $XMLHashGet[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
        "#3 ($Key) XMLHashGet() (Telephone->country)",
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
        "#3 ($Key) XMLHashGet() (Telephone2)",
    );

    $Self->Is(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
        'German Umlaute öäü ÄÜÖ ß',
        "#3 ($Key) XMLHashGet() (GermanText)",
    );

    my $XMLHashUpdateTrue = $XMLObject->XMLHashUpdate(
        Type    => 'SomeType',
        Key     => $Key,
        XMLHash => \@XMLHash,
    );
    $Self->True(
        $XMLHashUpdateTrue,
        "#3 ($Key) XMLHashUpdate() (admin)",
    );

    @XMLHashGet = $XMLObject->XMLHashGet(
        Type  => 'SomeType',
        Key   => $Key,
        Cache => 0,
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{role} eq 'admin',
        "#3 ($Key) XMLHashGet() (admin) - from db",
    );
    $Self->True(
        $#XMLHashGet == 1
            && $XMLHashGet[1]->{Contact}->[1]->{Telephone}->[1]->{country} eq 'germany',
        "#3 ($Key) XMLHashGet() (Telephone->country)",
    );
    $Self->True(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{Telephone2}->[1]->{Content} eq '',
        "#3 ($Key) XMLHashGet() (Telephone2)",
    );

    $Self->Is(
        $#XMLHashGet == 1 && $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content},
        'German Umlaute öäü ÄÜÖ ß',
        "utf8#3 ($Key) XMLHashGet() (GermanText)",
    );
    $Self->True(
        Encode::is_utf8( $XMLHashGet[1]->{Contact}->[1]->{GermanText}->[1]->{Content} ) || '',
        "#3 ($Key) XMLHashGet() (GermanText) - Encode::is_utf8",
    );

    my $XMLHashDelete = $XMLObject->XMLHashDelete(
        Type => 'SomeType',
        Key  => $Key,
    );
    $Self->True(
        $XMLHashDelete,
        "#3 ($Key) XMLHashDelete()",
    );
}

# add another XMLHash with the key '123'
my @XMLHashAdd;
$XMLHashAdd[1]->{Contact}->[1]->{role} = 'admin1';
$XMLHashAdd[1]->{Contact}->[1]->{Name}->[1]->{Content} = 'Example Inc. 2';
my $XMLHashUpdateAdd = $XMLObject->XMLHashAdd(
    Type    => 'SomeType',
    Key     => '123',
    XMLHash => \@XMLHashAdd,
);
$Self->True(
    $XMLHashUpdateAdd,
    '#4 XMLHashAdd() (admin1) # 1',
);

@XMLHash = $XMLObject->XMLHashGet(
    Type => 'SomeType',
    Key  => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin1',
    '#4 XMLHashGet() (admin1) # 2',
);

@XMLHash = $XMLObject->XMLHashGet(
    Type => 'SomeType',
    Key  => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin1',
    '#4 XMLHashGet() (admin1)',
);

my @XMLHashUpdate;
$XMLHashUpdate[1]->{Contact}->[1]->{role} = 'admin';
$XMLHashUpdate[1]->{Contact}->[1]->{Name}->[1]->{Content} = 'Example Inc.';
my $XMLHashUpdateTrue = $XMLObject->XMLHashUpdate(
    Type    => 'SomeType',
    Key     => '123',
    XMLHash => \@XMLHashUpdate,
);
$Self->True(
    $XMLHashUpdateTrue,
    '#4 XMLHashUpdate() (admin)',
);

@XMLHash = $XMLObject->XMLHashGet(
    Type => 'SomeType',
    Key  => '123',
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    '#4 XMLHashGet() (admin)',
);

@XMLHash = $XMLObject->XMLHashGet(
    Type  => 'SomeType',
    Key   => '123',
    Cache => 0,
);
$Self->True(
    $#XMLHash == 1 && $XMLHash[1]->{Contact}->[1]->{role} eq 'admin',
    '#4 XMLHashGet() (admin) - without cache',
);

# Search for an XMLHash
{
    my @Keys = $XMLObject->XMLHashSearch(
        Type => 'SomeType',
        What => [
            {
                "[%]{'Contact'}[%]{'role'}" => 'admin',
            }
        ]
    );
    $Self->True(
        scalar @Keys == 1 && $Keys[0] eq '123',
        "#1 XMLHashSearch() single matching condition",
    );

    @Keys = $XMLObject->XMLHashSearch(
        Type => 'SomeType',
        What => [
            {
                "[%]{'Contact'}[%]{'role'}" => 'superuser',
            },
        ]
    );
    $Self->False(
        scalar @Keys,
        "#1 XMLHashSearch() single non-matching condition",
    );

    @Keys = $XMLObject->XMLHashSearch(
        Type => 'SomeType',
        What => [
            {
                "[%]{'Contact'}[%]{'role'}" => 'superuser',
                "[%]{'Contact'}[%]{'role'}" => 'admin',
            },
        ]
    );
    $Self->True(
        scalar @Keys == 1 && $Keys[0] eq '123',
        "#1 XMLHashSearch() matching or non-matching condition",
    );

    @Keys = $XMLObject->XMLHashSearch(
        Type => 'SomeType',
        What => [
            {
                "[%]{'Contact'}[%]{'role'}" => 'superuser',
            },
            {
                "[%]{'Contact'}[%]{'role'}" => 'admin',
            },
        ]
    );
    $Self->False(
        scalar @Keys,
        "#1 XMLHashSearch() matching and non-matching condition",
    );
}

my $XML = $XMLObject->XMLHash2XML(@XMLHash);
@XMLHash = $XMLObject->XMLParse2XMLHash( String => $XML );
my $XML2 = $XMLObject->XMLHash2XML(@XMLHash);
$Self->True(
    $XML eq $XML2,
    '#4 XMLHash2XML() -> XMLParse2XMLHash() -> XMLHash2XML()',
);

my $XML3 = $XMLObject->XMLHash2XML(@XMLHash);
@XMLHash = $XMLObject->XMLParse2XMLHash( String => $XML );
my $XML4 = $XMLObject->XMLHash2XML(@XMLHash);
$Self->True(
    ( $XML2 eq $XML3 && $XML3 eq $XML4 ),
    '#4 XMLHash2XML() -> XMLHash2XML() -> XMLParse2XMLHash() -> XMLHash2XML()',
);

my @Keys = $XMLObject->XMLHashList( Type => 'SomeType' );
$Self->True(
    ( $Keys[0] == 123 ),
    '#4 XMLHashList() ([0] == 123)',
);

@Keys = $XMLObject->XMLHashList( Type => 'SomeType' );
for my $Key (@Keys) {
    my $XMLHashMove = $XMLObject->XMLHashMove(
        OldType => 'SomeType',
        OldKey  => $Key,
        NewType => 'SomeTypeNew',
        NewKey  => $Key,
    );
    $Self->True(
        $XMLHashMove,
        "#4 XMLHashMove() (Key=$Key)",
    );
}

@Keys = $XMLObject->XMLHashList( Type => 'SomeTypeNew' );
for my $Key (@Keys) {
    my $XMLHashDelete = $XMLObject->XMLHashDelete(
        Type => 'SomeTypeNew',
        Key  => $Key,
    );
    $Self->True(
        $XMLHashDelete,
        "#4 XMLHashDelete() (Key=$Key)",
    );
}

for my $KeyShould ( 1 .. 12 ) {
    my $XMLHashAdd = $XMLObject->XMLHashAdd(
        Type             => 'SomeType',
        KeyAutoIncrement => 1,
        XMLHash          => \@XMLHash,
    );
    $Self->Is(
        $XMLHashAdd || '',
        $KeyShould,
        "#4 XMLHashAdd() ($KeyShould KeyAutoIncrement)",
    );
}

@Keys = $XMLObject->XMLHashList( Type => 'SomeType' );
for my $Key (@Keys) {
    my $XMLHashMove = $XMLObject->XMLHashMove(
        OldType => 'SomeType',
        OldKey  => $Key,
        NewType => 'SomeTypeNew',
        NewKey  => $Key . 'New',
    );
    $Self->True(
        $XMLHashMove,
        "#4 XMLHashMove() 2 (Key=$Key)",
    );
}

@Keys = $XMLObject->XMLHashList( Type => 'SomeTypeNew' );
for my $Key (@Keys) {
    my $XMLHashDelete = $XMLObject->XMLHashDelete(
        Type => 'SomeTypeNew',
        Key  => $Key,
    );
    $Self->True(
        $XMLHashDelete,
        "#4 XMLHashDelete() 2 (Key=$Key)",
    );
}

#------------------------------------------------#
# a test to find charset problems with XML files
#------------------------------------------------#

my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

# get the example XML
my $Path = $ConfigObject->Get('Home');
$Path .= "/scripts/test/sample/XML/";
my $File = 'XML-Test-file.xml';
$String = '';
if ( open( my $DATA, "<", "$Path/$File" ) ) {    ## no critic qw(OTOBO::ProhibitOpen)
    while ( my $s = <$DATA> ) {
        $String .= $s;
    }
    close $DATA;

    # charset test - use file from the filesystem and parse it
    @XMLHash = $XMLObject->XMLParse2XMLHash( String => $String );
    $Self->True(
        $#XMLHash == 1
            && $XMLHash[1]->{'EISPP-Advisory'}->[1]->{System_Information}->[1]->{information},
        'XMLParse2XMLHash() - charset test - use file from the filesystem and parse it',
    );

    # charset test - use file from the article attachment and parse it
    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Some Ticket Title',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    $Self->True(
        $TicketID,
        'XMLParse2XMLHash() - charset test - create ticket',
    );

    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        IsVisibleForCustomer => 0,
        SenderType           => 'agent',
        From                 => 'Some Agent <email@example.com>',
        To                   => 'Some Customer <customer-a@example.com>',
        Cc                   => 'Some Customer <customer-b@example.com>',
        ReplyTo              => 'Some Customer <customer-b@example.com>',
        Subject              => 'some short description',
        Body                 =>
            'the message text Perl modules provide a range of featurheel, and can be downloaded',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify  => 1,                                   # if you don't want to send agent notifications
    );

    $Self->True(
        $ArticleID,
        'XMLParse2XMLHash() - charset test - create article',
    );

    my $Feedback = $ArticleBackendObject->ArticleWriteAttachment(
        Content     => $String,
        ContentType => 'text/html; charset="iso-8859-15"',
        Filename    => $File,
        ArticleID   => $ArticleID,
        UserID      => 1,
    );
    $Self->True(
        $Feedback,
        'XMLParse2XMLHash() - charset test - write an article attachment to storage',
    );

    my %Attachment = $ArticleBackendObject->ArticleAttachment(
        ArticleID => $ArticleID,
        FileID    => 1,
    );

    @XMLHash = $XMLObject->XMLParse2XMLHash( String => $Attachment{Content} );
    $Self->True(
        $#XMLHash == 1
            && $XMLHash[1]->{'EISPP-Advisory'}->[1]->{System_Information}->[1]->{information},
        'XMLParse2XMLHash() - charset test - use file from the article attachment and parse it',
    );

}
else {
    $Self->True(
        0,
        "XMLParse2XMLHash() - charset test - failed because example file not found",
    );
}

# test bug#[12761]
# (https://bugs.otrs.org/show_bug.cgi?id=12761) - Cache values can be modified from the outside in function XMLParse().
{
    my $XML      = '<Test Name="test123" />';
    my @XMLARRAY = $XMLObject->XMLParse( String => $XML );

    # make a copy of the XMLArray (deep clone it),
    # it will be needed for a later comparison
    my @XMLARRAYCopy = $StorableObject->Clone( Data => \@XMLARRAY )->@*;

    # check that the copy is the same as the original
    is(
        \@XMLARRAY,
        \@XMLARRAYCopy,
        'Clone: @XMLARRAY equals @XMLARRAYCopy',
    );

    # modify the original, this should not influence the cache of XMLParse()
    $XMLARRAY[0]->{Hello} = 'World';

    # create a new xml array from the same xml string than the first
    my @XMLARRAY2 = $XMLObject->XMLParse( String => $XML );

    # check that the new array is the same as the original copy
    is(
        \@XMLARRAY2,
        \@XMLARRAYCopy,
        '@XMLARRAY2 equals @XMLARRAYCopy',
    );
}

# testing XMLParse
{
    my @Cases = (
        {
            XML => <<'END_XML',
<Test1 Name="name for Test1" />
END_XML
            XMLArray =>
                [
                    {
                        'Tag'          => 'Test1',
                        'TagLevel'     => '1',
                        'TagType'      => 'Start',
                        'Name'         => 'name for Test1',
                        'TagLastLevel' => undef,
                        'Content'      => undef,
                        'TagCount'     => '1'
                    },
                    {
                        'TagLevel' => '1',
                        'Tag'      => 'Test1',
                        'TagCount' => '2',
                        'TagType'  => 'End'
                    }
                ],
            Description => 'basic, without content'
        },
        {
            XML => <<'END_XML',
<Test2 Name="name for Test2">Content for Test2</Test2>
END_XML
            XMLArray =>
                [
                    {
                        'Tag'          => 'Test2',
                        'TagLevel'     => '1',
                        'TagType'      => 'Start',
                        'Name'         => 'name for Test2',
                        'TagLastLevel' => undef,
                        'Content'      => 'Content for Test2',
                        'TagCount'     => '1'
                    },
                    {
                        'TagLevel' => '1',
                        'Tag'      => 'Test2',
                        'TagCount' => '2',
                        'TagType'  => 'End'
                    }
                ],
            Description => 'basic, with content'
        },
        {
            XML => <<'END_XML',
<Level1 Name="name for Level1">
    <Level2 Name="name for Level2a">Content for Level2a</Level2>
    <Level2 Name="name for Level2b">Content for Level2b</Level2>
    <Level2 Name="name for Level2c">Content for Level2c</Level2>
</Level1>
END_XML
            XMLArray =>
                [
                    {
                        'Content'      => "\n    ",
                        'Name'         => 'name for Level1',
                        'Tag'          => 'Level1',
                        'TagCount'     => 1,
                        'TagLastLevel' => undef,
                        'TagLevel'     => 1,
                        'TagType'      => 'Start'
                    },
                    {
                        'Content'      => 'Content for Level2a',
                        'Name'         => 'name for Level2a',
                        'Tag'          => 'Level2',
                        'TagCount'     => 2,
                        'TagLastLevel' => 'Level1',
                        'TagLevel'     => 2,
                        'TagType'      => 'Start'
                    },
                    {
                        'Tag'      => 'Level2',
                        'TagCount' => 3,
                        'TagLevel' => 2,
                        'TagType'  => 'End'
                    },
                    {
                        'Content'      => 'Content for Level2b',
                        'Name'         => 'name for Level2b',
                        'Tag'          => 'Level2',
                        'TagCount'     => 4,
                        'TagLastLevel' => 'Level1',
                        'TagLevel'     => 2,
                        'TagType'      => 'Start'
                    },
                    {
                        'Tag'      => 'Level2',
                        'TagCount' => 5,
                        'TagLevel' => 2,
                        'TagType'  => 'End'
                    },
                    {
                        'Content'      => 'Content for Level2c',
                        'Name'         => 'name for Level2c',
                        'Tag'          => 'Level2',
                        'TagCount'     => 6,
                        'TagLastLevel' => 'Level1',
                        'TagLevel'     => 2,
                        'TagType'      => 'Start'
                    },
                    {
                        'Tag'      => 'Level2',
                        'TagCount' => 7,
                        'TagLevel' => 2,
                        'TagType'  => 'End'
                    },
                    {
                        'Tag'      => 'Level1',
                        'TagCount' => 8,
                        'TagLevel' => 1,
                        'TagType'  => 'End'
                    }
                ],
            Description => 'single nesting level'
        },
    );

    for my $Case (@Cases) {

        my @ParsedXML = $XMLObject->XMLParse( String => $Case->{XML} );
        is(
            \@ParsedXML,
            $Case->{XMLArray},
            $Case->{Description},
        );
    }
}

done_testing;
