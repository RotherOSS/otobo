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

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::XML::Simple',
);

use Kernel::System::VariableCheck qw( :all );

=head1 NAME

Kernel::System::SysConfig::XML - Manage system configuration settings in XML.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
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
    my ( $Type, %Param ) = @_;

    if ( !IsStringWithData( $Param{XMLInput} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Parameter XMLInput needs to be a string!",
        );
        return;
    }

    my $XMLSimpleObject = $Kernel::OM->Get('Kernel::System::XML::Simple');

    my $XMLContent = $Param{XMLInput};

    # Remove all lines that starts with comment (#).
    $XMLContent =~ s{^#.*?$}{}gm;

    # Remove comments <!-- ... -->.
    $XMLContent =~ s{<!--.*?-->}{}gsm;

    my ($ConfigVersion) = $XMLContent =~ m{otobo_config.*?version="(.*?)"};

    if ( $ConfigVersion ne '2.0' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid XML format found in $Param{XMLFilename} (version must be 2.0)! File skipped.",
        );
        return;
    }

    while ( $XMLContent =~ m{<ConfigItem.*?Name="(.*?)"}smxg ) {

        # Old style ConfigItem detected.
        my $SettingName = $1;

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Old ConfigItem $SettingName detected in $Param{XMLFilename}!"
        );
    }

    # Fetch XML of Setting elements.
    my @ParsedSettings;

    # Note: this is strange. This allows invalid XML to be used as configuration files.
    SETTING:
    while (
        $XMLContent =~ m{(?<RawSetting> <Setting[ ]+ .*? Name="(?<SettingName> .*? )" .*? > .*? </Setting> )}smxg
        )
    {

        my $RawSetting  = $+{RawSetting};
        my $SettingName = $+{SettingName};

        next SETTING if !IsStringWithData($RawSetting);
        next SETTING if !IsStringWithData($SettingName);

        my $PerlStructure = $XMLSimpleObject->XMLIn(
            XMLInput => $RawSetting,
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
