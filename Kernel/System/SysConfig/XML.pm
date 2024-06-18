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

package Kernel::System::SysConfig::XML;

use strict;
use warnings;

# core modules

# CPAN modules
use XML::LibXML;

# OTOBO modules
use Kernel::System::VariableCheck qw( :all );

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::XML::Simple',
);

=head1 NAME

Kernel::System::SysConfig::XML - Manage system configuration settings in XML files

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');

=cut

sub new {
    my ($Type) = @_;

    # allocate new hash for object
    return bless {}, $Type;
}

=head2 SettingListParse()

Parses XML files into a list of perl structures and meta data.

    my $PerlStructure = $SysConfigXMLObject->SettingListParse(
        XMLInput => '
            <?xml version="1.0" encoding="utf-8"?>
            <otobo_config version="2.0" init="Application">
                <Setting Name="Test1" Required="1" Valid="1">
                    <Description Translatable="1">Test 1.</Description>
                    <Navigation>Core::Ticket</Navigation>
                    <Value>
                        <Item ValueType="String" ValueRegex=".*">123</Item>
                    </Value>
                </Setting>
                <Setting Name="Test2" Required="1" Valid="1">
                    <Description Translatable="1">Test 2.</Description>
                    <Navigation>Core::Ticket</Navigation>
                    <Value>
                        <Item ValueType="File">/usr/bin/gpg</Item>
                    </Value>
                </Setting>
            </otobo_config>
        ',
        XMLFilename => 'Test.xml'
    );

Returns:

    [
        {
            XMLContentParsed => {
                Description => [
                    {
                        Content      => 'Test.',
                        Translatable => '1',
                    },
                ],
                Name  => 'Test',
                Required => '1',
                Value => [
                    {
                        Item => [
                            {
                                ValueRegex => '.*',
                                ValueType  => 'String',
                                Content    => '123',
                            },
                        ],
                    },
                ],
                Navigation => [
                    {
                        Content => 'Core::Ticket',
                    },
                ],
                Valid => '1',
            },
            XMLContentRaw => '<Setting Name="Test1" Required="1" Valid="1">
                <Description Translatable="1">Test 1.</Description>
                <Navigation>Core::Ticket</Navigation>
                <Value>
                    <Item ValueType="String" ValueRegex=".*">123</Item>
                </Value>
            </Setting>',
            XMLFilename => 'Test.xml'
        },
    ]

=cut

sub SettingListParse {
    my ( $Self, %Param ) = @_;

    my $XMLContent  = $Param{XMLInput};
    my $XMLFilename = $Param{XMLFilename} // '';

    # check sanity by looking whether we have data
    if ( !IsStringWithData($XMLContent) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Parameter XMLInput needs to be a string!",
        );

        return;
    }

    # try to parse the XML
    my $Document = eval {
        my $Parser = XML::LibXML->new();

        return $Parser->parse_string($XMLContent);
    };
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid XML format found in $XMLFilename: $@",
        );

        return;
    }

    # Don't require that 'otobo_config' is the root in order to be compatible older behavior
    my $ConfigNode;
    {
        ( $ConfigNode, my @OtherConfigNodes ) = $Document->findnodes('descendant-or-self::otobo_config');

        if ( !$ConfigNode ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid XML format found in $XMLFilename: node 'otobo_config' not found",
            );

            return;
        }

        if (@OtherConfigNodes) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid XML format found in $XMLFilename: multiple 'otobo_config' nodes found",
            );

            return;
        }
    }

    # check the config version
    {
        my $ConfigVersion = $ConfigNode->getAttribute('version') // '';
        if ( $ConfigVersion ne '2.0' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid XML format found in $XMLFilename: version must be 2.0",
            );

            return;
        }
    }

    # check sanity by looking for old-style settings
    {
        my (@OldStyleNodes) = $ConfigNode->findnodes('ConfigItem');

        for my $Node (@OldStyleNodes) {
            my $SettingName = $Node->getAttribute('Name') // '';

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Old ConfigItem $SettingName detected in $XMLFilename!"
            );
        }
    }

    # needed for creating a Perl data structure per Setting node
    my $XMLSimpleObject = $Kernel::OM->Get('Kernel::System::XML::Simple');

    # Fetch XML of Setting elements.
    my @ParsedSettings;

    # Use libxml for finding the Nodes with the name 'Setting'
    my @SettingNodes = eval {
        my $Parser   = XML::LibXML->new();
        my $Document = $Parser->parse_string($XMLContent);

        return $Document->findnodes('descendant-or-self::Setting[@Name]');
    };

    SETTING:
    for my $SettingNode (@SettingNodes) {
        my $RawSetting  = $SettingNode->toString(0);            # the original content
        my $SettingName = $SettingNode->getAttribute('Name');

        next SETTING if !IsStringWithData($RawSetting);
        next SETTING if !IsStringWithData($SettingName);

        # no need need to parse XML again, we already have a parse tree
        my $PerlStructure = $XMLSimpleObject->XMLIn(
            XMLInput => $SettingNode,
            Options  => {
                KeepRoot     => 1,
                ForceArray   => 1,
                ForceContent => 1,
                ContentKey   => 'Content',
            },
        );

        if ( !IsHashRefWithData($PerlStructure) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Resulting Perl structure must be a hash reference with data!",
            );

            next SETTING;
        }

        if ( !IsArrayRefWithData( $PerlStructure->{Setting} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Resulting Perl structure must have Setting elements!",
            );

            next SETTING;
        }

        push @ParsedSettings, {
            XMLContentParsed => $PerlStructure->{Setting}->[0],
            XMLContentRaw    => $RawSetting,
            XMLFilename      => $Param{XMLFilename},
        };
    }

    return @ParsedSettings;
}

1;
