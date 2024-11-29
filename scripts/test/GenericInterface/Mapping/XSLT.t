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
use Kernel::GenericInterface::Debugger ();
use Kernel::GenericInterface::Mapping  ();

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Provider',
);

my @Tests = (
    {
        Name   => 'Test invalid xml',
        Config => {
            Template => 'this is no xml',
        },
        Data => {
            Key => 'Value',
        },
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test no XSLT',
        Config => {
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<valid-xml-but-no-xslt/>',
        },
        Data => {
            Key => 'Value',
        },
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test invalid XSLT',
        Config => {
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
</xsl:template>
</xsl:stylesheet>',
        },
        Data => {
            Key => 'Value',
        },
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test empty data',
        Config => {
            Template => '',
        },
        Data          => undef,
        ResultData    => {},
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test empty config',
        Config => {},
        Data   => {
            Key => 'Value',
        },
        ResultData => {
            Key => 'Value',
        },
        ResultSuccess => 1,
        ConfigSuccess => 0,
    },
    {
        Name   => 'Test invalid hash key name',
        Config => {
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewKey>NewValue</NewKey>
</xsl:template>
</xsl:stylesheet>',
        },
        Data => {
            '<Key>' => 'Value',
        },
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test invalid replacement',
        Config => {
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<Wrapper><Level1><Level2><Level3>Value</Level1></Level2></Level3></Wrapper>
</xsl:template>
</xsl:stylesheet>',
        },
        Data => {
            Key => 'Value',
        },
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test array as data',
        Config => {
            Template => qq{<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:otobo="http://otobo.org"
 extension-element-prefixes="otobo">
<xsl:import href="$Home/Kernel/GenericInterface/Mapping/OTOBOFunctions.xsl" />
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewRootElement>
    <xsl:for-each select="/RootElement/Array1">
    <FirstLevelArray>
        <xsl:text>Amended</xsl:text>
        <xsl:value-of select="." />
    </FirstLevelArray>
    </xsl:for-each>
</NewRootElement>
</xsl:template>
</xsl:stylesheet>},
        },
        Data => (
            'ArrayPart1',
            'ArrayPart2',
            'ArrayPart3',
        ),
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test simple overwrite',
        Config => {
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewRootElement><NewKey>NewValue</NewKey></NewRootElement>
</xsl:template>
</xsl:stylesheet>',
        },
        Data => {
            Key => 'Value',
        },
        ResultData => {
            NewKey => 'NewValue',
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },

    {
        Name   => 'Test simple overwrite (whitespaces trimmed)',
        Config => {
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewRootElement><NewKey>
        NewValue
</NewKey></NewRootElement>
</xsl:template>
</xsl:stylesheet>',
        },
        Data => {
            Key => 'Value',
        },
        ResultData => {
            NewKey => 'NewValue',
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },

    {
        Name   => 'Test replacement with custom functions',
        Config => {
            Template => qq{<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:otobo="http://otobo.org"
 extension-element-prefixes="otobo">
<xsl:import href="$Home/Kernel/GenericInterface/Mapping/OTOBOFunctions.xsl" />
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewRootElement>
    <xsl:for-each select="/RootElement/Structure1/Array1">
    <FirstLevelArray>
        <xsl:text>Amended</xsl:text>
        <xsl:value-of select="." />
    </FirstLevelArray>
    </xsl:for-each>
    <NewStructure>
        <DateFromISO>
            <xsl:variable name="dateiso" select="/RootElement/DateISO" />
            <xsl:value-of select="otobo:date-iso-to-xsd(\$dateiso)" />
        </DateFromISO>
        <DateToISO>
            <xsl:variable name="datexsd" select="/RootElement/DateXSD" />
            <xsl:value-of select="otobo:date-xsd-to-iso(\$datexsd)" />
        </DateToISO>
        <NewKey1>
            <xsl:value-of select="/RootElement/Key1" />
        </NewKey1>
        <NewKey2>
            <xsl:value-of select="/RootElement/Structure1/Key2" />
        </NewKey2>
    </NewStructure>
</NewRootElement>
</xsl:template>
</xsl:stylesheet>},
        },
        Data => {
            DateISO    => '2010-12-31 23:58:59',
            DateXSD    => '2011-11-30T22:57:58Z',
            Key1       => 'Value1',
            Structure1 => {
                Array1 => [
                    'ArrayPart1',
                    'ArrayPart2',
                    'ArrayPart3',
                ],
                Key2 => 'Value2',
            },
        },
        ResultData => {
            FirstLevelArray => [
                'AmendedArrayPart1',
                'AmendedArrayPart2',
                'AmendedArrayPart3',
            ],
            NewStructure => {
                DateFromISO => '2010-12-31T23:58:59Z',
                DateToISO   => '2011-11-30 22:57:58',
                NewKey1     => 'Value1',
                NewKey2     => 'Value2',
            },
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test DataInclude functionality',
        Config => {
            DataInclude => [
                'RequesterRequestInput',
                'RequesterResponseMapOutput',
            ],
            Template => qq{<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:otobo="http://otobo.org"
 extension-element-prefixes="otobo">
<xsl:import href="$Home/Kernel/GenericInterface/Mapping/OTOBOFunctions.xsl" />
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewRootElement>
    <DataInclude><xsl:value-of select="/RootElement/DataInclude/RequesterResponseMapOutput/Value" /></DataInclude>
    <DataInclude><xsl:value-of select="/RootElement/DataInclude/RequesterRequestInput/Value" /></DataInclude>
</NewRootElement>
</xsl:template>
</xsl:stylesheet>},
        },
        Data => {
            Key => 'Value',
        },
        DataInclude => {
            RequesterRequestInput         => { Value => 1 },
            RequesterRequestPrepareOutput => { Value => 2 },
            RequesterResponseMapOutput    => { Value => 3 }
        },
        ResultData => {
            DataInclude => [
                3,
                1,
            ],
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
);

# test the roundtrip XMLout -> Identity Transform -> XMLin
{
    my $IdentityTransform = <<'END_STYLESHEET';
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:template match="/">
    <xsl:copy-of select="*"/>
  </xsl:template>
</xsl:stylesheet>
END_STYLESHEET

    push @Tests,
        {
            Name   => 'Roundtrip non-empty string',
            Config => {
                Template => $IdentityTransform,
            },
            Data => {
                Key => 'Value',
            },
            ResultData => {
                Key => 'Value',
            },
            ResultSuccess => 1,
            ConfigSuccess => 1,
        },
        {
            Name   => 'Roundtrip empty string, turned into empty string',
            Config => {
                Template => $IdentityTransform,
            },
            Data => {
                Key => q{},
            },
            ResultData => {
                Key => '',
            },
            ResultSuccess => 1,
            ConfigSuccess => 1,
        },
        {
            Name   => 'Roundtrip undef, turned into empty string',
            Config => {
                Template => $IdentityTransform,
            },
            Data => {
                Key => undef,
            },
            ResultData => {
                Key => '',
            },
            ResultSuccess => 1,
            ConfigSuccess => 1,
        },
        {
            Name   => 'Roundtrip number 100',
            Config => {
                Template => $IdentityTransform,
            },
            Data => {
                Key => 100,
            },
            ResultData => {
                Key => 100,
            },
            ResultSuccess => 1,
            ConfigSuccess => 1,
        },
        {
            Name   => 'Roundtrip number 0',
            Config => {
                Template => $IdentityTransform,
            },
            Data => {
                Key => 0,
            },
            ResultData => {
                Key => 0,
            },
            ResultSuccess => 1,
            ConfigSuccess => 1,
        };
}

# add some tests that take the input data from a JSON string
{
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    # show that the mapping works with parsed JSON
    push @Tests,
        {
            Name   => 'ammend simple JSON array',
            Config => {
                Template => << 'END_TEMPLATE',
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:template match="/RootElement/Structure1">
    <NewRootElement>
      <xsl:for-each select="Array1">
        <WeierstrassArray>
          <xsl:text>℘ - U+02118 - WEIERSTRASS ELLIPTIC FUNCTION:</xsl:text>
          <xsl:value-of select="." />
        </WeierstrassArray>
      </xsl:for-each>
    </NewRootElement>
  </xsl:template>
</xsl:stylesheet>
END_TEMPLATE
            },
            Data => $JSONObject->Decode( Data => <<'END_JSON' ),
{
    "Structure1": {
        "Key2": "is ignored",
        "Array1": [ "Element 🅐", "Element 🅑", "Element 🅒" ]
    }
}
END_JSON
            ResultData => {
                WeierstrassArray => [
                    '℘ - U+02118 - WEIERSTRASS ELLIPTIC FUNCTION:Element 🅐',
                    '℘ - U+02118 - WEIERSTRASS ELLIPTIC FUNCTION:Element 🅑',
                    '℘ - U+02118 - WEIERSTRASS ELLIPTIC FUNCTION:Element 🅒',
                ],
            },
            ResultSuccess => 1,
            ConfigSuccess => 1,
        };

    # now with boolean checks,
    # actually string tests as the node values have no type assigned
    push @Tests,
        {
            Name   => 'truthiness',
            Config => {
                Template => << 'END_TEMPLATE',
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:template match="/RootElement/Structure1">
    <NewRootElement>
      <xsl:for-each select="Array1">
        <TrueOrNotTrueArray>
          <xsl:choose>
            <xsl:when test="string() = ''">
              <xsl:text>⊭ NOT TRUE: empty string:</xsl:text>
            </xsl:when>
            <xsl:when test="string() = ''">
              <xsl:text>⊭ NOT TRUE: empty string:</xsl:text>
            </xsl:when>
            <xsl:when test="string() = '0'">
              <xsl:text>⊭ NOT TRUE: integer 0:</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>⊨ TRUE: otherwise:</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="text()" />
          <xsl:text>,</xsl:text>
          <xsl:value-of select="name()" />
        </TrueOrNotTrueArray>
      </xsl:for-each>
    </NewRootElement>
  </xsl:template>
</xsl:stylesheet>
END_TEMPLATE
            },
            Data => $JSONObject->Decode( Data => <<'END_JSON' ),
{
    "Structure1": {
        "Array1": [ "Element 🅐", "Element 🅑", "Element 🅒", 1, "", true, false ]
    }
}
END_JSON
            ResultData => {
                'TrueOrNotTrueArray' => [
                    "\x{22a8} TRUE: otherwise:Element \x{1f150},Array1",
                    "\x{22a8} TRUE: otherwise:Element \x{1f151},Array1",
                    "\x{22a8} TRUE: otherwise:Element \x{1f152},Array1",
                    "\x{22a8} TRUE: otherwise:1,Array1",
                    "\x{22ad} NOT TRUE: empty string:,Array1",
                    "\x{22a8} TRUE: otherwise:1,Array1",
                    "\x{22ad} NOT TRUE: integer 0:0,Array1"
                ]
            },
            ResultSuccess => 1,
            ConfigSuccess => 1,
        };

    # using a number variable
    push @Tests,
        {
            Name   => 'number variable',
            Config => {
                Template => << 'END_TEMPLATE',
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:template match="/RootElement/Structure1">
    <NewRootElement>
      <xsl:for-each select="Array1">
        <TrueOrNotTrueArray>
          <!-- as="xs:integer" does not seem to cast to integer. So call number() explicitly -->
          <xsl:variable name="my_int" select="number(.)"/>
          <xsl:choose>
            <xsl:when test="$my_int">
              <xsl:text>⊨ TRUE:</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>⊭ NOT TRUE:</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="$my_int" />
          <xsl:text>,</xsl:text>
          <xsl:value-of select="$my_int + 100" />
        </TrueOrNotTrueArray>
      </xsl:for-each>
    </NewRootElement>
  </xsl:template>
</xsl:stylesheet>
END_TEMPLATE
            },
            Data => $JSONObject->Decode( Data => <<'END_JSON' ),
{
    "Structure1": {
        "Array1": [ -1, 0, 1, "-1", "0", "1", false, true ]
    }
}
END_JSON
            ResultData => {
                'TrueOrNotTrueArray' => [
                    "\x{22a8} TRUE:-1,99",
                    "\x{22ad} NOT TRUE:0,100",
                    "\x{22a8} TRUE:1,101",
                    "\x{22a8} TRUE:-1,99",
                    "\x{22ad} NOT TRUE:0,100",
                    "\x{22a8} TRUE:1,101",
                    "\x{22ad} NOT TRUE:0,100",
                    "\x{22a8} TRUE:1,101",
                ]
            },
            ResultSuccess => 1,
            ConfigSuccess => 1,
        };
}

for my $Test (@Tests) {

    subtest $Test->{Name} => sub {

        # create a mapping instance
        my $MappingObject = Kernel::GenericInterface::Mapping->new(
            DebuggerObject => $DebuggerObject,
            MappingConfig  => {
                Type   => 'XSLT',
                Config => $Test->{Config},
            },
        );
        if ( $Test->{ConfigSuccess} ) {
            is(
                ref $MappingObject,
                'Kernel::GenericInterface::Mapping',
                'MappingObject was correctly instantiated',
            );

            return unless ref $MappingObject eq 'Kernel::GenericInterface::Mapping';
        }
        else {
            isnt(
                ref $MappingObject,
                'Kernel::GenericInterface::Mapping',
                'MappingObject was not correctly instantiated',
            );

            return;
        }

        my $MappingResult = $MappingObject->Map(
            Data        => $Test->{Data},
            DataInclude => $Test->{DataInclude},
        );

        # check if function return correct status
        is(
            $MappingResult->{Success},
            $Test->{ResultSuccess},
            ( $Test->{ResultSuccess} ? 'Map() was successful' : 'Map() was not successful' ),
        );

        # check if function return correct data
        is(
            $MappingResult->{Data},
            $Test->{ResultData},
            'Data Structure',
        );

        if ( !$Test->{ResultSuccess} ) {
            diag $MappingResult->{ErrorMessage};
            ok(
                $MappingResult->{ErrorMessage},
                'error message found',
            );
        }

        # instantiate another object
        my $SecondMappingObject = Kernel::GenericInterface::Mapping->new(
            DebuggerObject => $DebuggerObject,
            MappingConfig  => {
                Type   => 'XSLT',
                Config => $Test->{Config},
            },
        );

        is(
            ref $SecondMappingObject,
            'Kernel::GenericInterface::Mapping',
            'SecondMappingObject was correctly instantiated',
        );
    };
}

done_testing;
