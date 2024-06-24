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
use List::AllUtils qw(none);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

=head1 DESCRIPTION

This test verifies that the settings defined in Defaults.pm match those in ZZZAAuto.pm (XML default config cache).

This test will only operate if no custom/unknown configuration files are present, because these might alter the default
settings and cause unexpected test failures.

=cut

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
my $Home       = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# Checksum file content as an array ref.
my $ChecksumFileArrayRef = $MainObject->FileRead(
    Location        => "$Home/ARCHIVE",
    Mode            => 'utf8',
    Type            => 'Local',
    Result          => 'ARRAY',
    DisableWarnings => 1,
);

skip_all(
    'Default configuration unit test requires the checksum file (ARCHIVE) to be present and valid. Please first call the following command to create it: bin/otobo.CheckSum.pl -a create'
) if !$ChecksumFileArrayRef || !@{$ChecksumFileArrayRef};

# Get list of present config XML files.
my $Directory   = "$Home/Kernel/Config/Files/XML";
my @ConfigFiles = $MainObject->DirectoryRead(
    Directory => $Directory,
    Filter    => '*.xml',
);

# Skip test when there non-standard XML files in the directory
for my $ConfigFile (@ConfigFiles) {

    $ConfigFile =~ s{^${Home}/(.*/[^/]+.xml)$}{$1}xmsg;

    # This check also works for Kernel/Config/Files/XML/DockerConfig.xml
    # as in Docker builds the DockerConfig,xml.dist is copied before ARCHIVE is generated.
    if ( none { $_ =~ $ConfigFile } $ChecksumFileArrayRef->@* ) {
        skip_all("Custom configuration file found ($ConfigFile), skipping test...");
    }
}

my $DefaultConfig = bless {}, 'Kernel::Config::Defaults';
$DefaultConfig->Kernel::Config::Defaults::LoadDefaults();

# Kernel::Config::Files::ZZZAAuto should be available as a Kernel::Config object had been created.
my $ZZZAAutoConfig = bless {}, 'Kernel::Config::Files::ZZZAAuto';
$ZZZAAutoConfig->Load($ZZZAAutoConfig);

# These entries are hashes
my %CheckSubEntries = (
    'Frontend::Module'                   => 1,
    'Frontend::NotifyModule'             => 1,
    'Frontend::Navigation'               => 1,
    'Frontend::NavigationModule'         => 1,
    'CustomerFrontend::Module'           => 1,
    'Loader::Agent::CommonJS'            => 1,
    'Loader::Agent::CommonCSS'           => 1,
    'Loader::Customer::CommonJS'         => 1,
    'Loader::Customer::CommonCSS'        => 1,
    'PreferencesGroups'                  => 1,
    'Ticket::Article::Backend::MIMEBase' => 1,
);

# These entries are hashes of hashes
my %CheckSubEntriesElements = (
    'Frontend::Navigation###Admin' => 1,
);

my %IgnoreEntries = (
    'Frontend::CommonParam'         => 1,
    'CustomerFrontend::CommonParam' => 1,
    'PublicFrontend::CommonParam'   => 1,

    # These settings are modified in framework.xml and needs to be excluded from this test.
    'Loader::Module::Admin'                    => 1,
    'Loader::Module::AdminLog'                 => 1,
    'Loader::Module::AdminSystemConfiguration' => 1,
    'Loader::Module::CustomerLogin'            => 1,

    # These settings is modified in daemon.xml and needs to be excluded from this test.
    'DaemonModules' => 1,

    # These settings may have been adapted for the UnitTest
    'HttpType' => 1,
);

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

DEFAULTCONFIGENTRY:
for my $DefaultConfigEntry ( sort keys %{$DefaultConfig} ) {

    # There is a number of settings that are only in Defaults.pm, ignore these
    next DEFAULTCONFIGENTRY if !exists $ZZZAAutoConfig->{$DefaultConfigEntry};

    next DEFAULTCONFIGENTRY if $IgnoreEntries{$DefaultConfigEntry};

    if ( $CheckSubEntries{$DefaultConfigEntry} ) {

        DEFAULTCONFIGSUBENTRY:
        for my $DefaultConfigSubEntry ( sort keys %{ $DefaultConfig->{$DefaultConfigEntry} } ) {

            # There is a number of settings that are only in Defaults.pm, ignore these
            if ( !exists $ZZZAAutoConfig->{$DefaultConfigEntry}->{$DefaultConfigSubEntry} ) {
                next DEFAULTCONFIGSUBENTRY;
            }

            my $SettingName          = $DefaultConfigEntry . '###' . $DefaultConfigSubEntry;
            my $DefaultConfigSetting = $DefaultConfig->{$DefaultConfigEntry}->{$DefaultConfigSubEntry};

            # Check for a third level settings
            if ( $CheckSubEntriesElements{$SettingName} ) {

                DEFAULTCONFIGSUBENTRYELEMENT:
                for my $DefaultConfigSubEntryElement ( sort keys %{$DefaultConfigSetting} ) {

                    if (
                        !exists $ZZZAAutoConfig->{$DefaultConfigEntry}->{$DefaultConfigSubEntry}
                        ->{$DefaultConfigSubEntryElement}
                        )
                    {
                        next DEFAULTCONFIGSUBENTRYELEMENT;
                    }

                    my %Setting = $SysConfigObject->SettingGet(
                        Name => $DefaultConfigEntry . '###'
                            . $DefaultConfigSubEntry . '###'
                            . $DefaultConfigSubEntryElement,
                        Default => 1,
                    );

                    is(
                        \$DefaultConfigSetting->{$DefaultConfigSubEntryElement},
                        \$Setting{EffectiveValue},
                        "$DefaultConfigEntry->$DefaultConfigSubEntry->$DefaultConfigSubEntryElement must be the same in Defaults.pm and setting default value",
                    );
                }
            }
            else {

                my %Setting = $SysConfigObject->SettingGet(
                    Name    => $SettingName,
                    Default => 1,
                );

                is(
                    \$DefaultConfigSetting,
                    \$Setting{EffectiveValue},
                    "$DefaultConfigEntry->$DefaultConfigSubEntry must be the same in Defaults.pm and setting default value",
                );
            }
        }
    }
    else {

        my %Setting = $SysConfigObject->SettingGet(
            Name    => $DefaultConfigEntry,
            Default => 1,
        );

        is(
            \$DefaultConfig->{$DefaultConfigEntry},
            \$Setting{EffectiveValue},
            "$DefaultConfigEntry must be the same in Defaults.pm and and setting default value",
        );
    }
}

done_testing;
