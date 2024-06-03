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

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $CacheObject       = $Kernel::OM->Get('Kernel::System::Cache');
my $CommandObject     = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Config::FixInvalid');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');
my $MainObject        = $Kernel::OM->Get('Kernel::System::Main');
my $Home              = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $RunCommand = sub {
    my @Args = @_;
    my ( $ResultErr, $ResultOut, $ExitCode );

    $ResultErr = '';
    $ResultOut = '';

    {
        local *STDERR;
        local *STDOUT;
        open STDERR, '>:utf8', \$ResultErr;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
        open STDOUT, '>:utf8', \$ResultOut;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
        $ExitCode = $CommandObject->Execute( '--non-interactive', @Args, );
    }

    return ( $ResultErr . $ResultOut, $ExitCode );
};

my $RandomID = $Helper->GetRandomID();

my $PerlModule = $MainObject->FileWrite(
    Directory => "${Home}/Kernel",
    Filename  => "FixInvalid$RandomID.pm",
    Content   => \"package Kernel::FixInvalid$RandomID; 1;",
);

$Self->True(
    $PerlModule,
    'Created dummy Perl module: ' . $PerlModule
);

my $XML = <<"EOS";
<?xml version="1.0" encoding="utf-8" ?>
<otobo_config version="2.0" init="Application">
    <Setting Name="UnitTest::DummyModule::$RandomID" Required="1" Valid="1">
        <Description Translatable="1">Dummy module registration for a unit test</Description>
        <Navigation>UnitTest</Navigation>
        <Value>
            <Item ValueType="PerlModule" ValueFilter="Kernel/*.pm">Kernel::FixInvalid$RandomID</Item>
        </Value>
    </Setting>
</otobo_config>
EOS

my $XMLFile = $MainObject->FileWrite(
    Directory => "${Home}/Kernel/Config/Files/XML",
    Filename  => "FixInvalid$RandomID.xml",
    Content   => \$XML,
);

$Self->True(
    $XMLFile,
    'Created dummy XML config file: ' . $XMLFile,
);

# Rebuild the configuration.
$SysConfigObject->ConfigurationXML2DB(
    UserID => 1,
    Force  => 1,
);

my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
    Comments    => 'FixInvalidSkipMissing.t - Configuration Rebuild',
    AllSettings => 1,
    UserID      => 1,
    Force       => 1,
);

$Self->True(
    $DeploymentResult{Success},
    'Configuration rebuilt successfully',
);

my $XMLFileDeleted = $MainObject->FileDelete(
    Directory => "${Home}/Kernel/Config/Files/XML",
    Filename  => "FixInvalid$RandomID.xml",
);
$Self->True(
    $XMLFileDeleted,
    'Deleted dummy XML config file: ' . $XMLFile,
);

my $PerlModuleDeleted = $MainObject->FileDelete(
    Directory => "${Home}/Kernel",
    Filename  => "FixInvalid$RandomID.pm",
);
$Self->True(
    $PerlModuleDeleted,
    'Deleted dummy Perl module: ' . $PerlModule,
);

my ( $Result, $ExitCode ) = $RunCommand->();

$Self->True(
    $Result,
    'Found invalid settings'
);
$Self->False(
    $ExitCode,
    'Exit code OK'
);
$Self->True(
    (
        $Result
            =~ m{Following settings were not fixed:.*UnitTest::DummyModule::$RandomID.*Please use console command \(bin/otobo\.Console\.pl Admin::Config::Update --help\) or GUI to fix them\.}ms
    ) // 0,
    'Check expected command output'
);

( $Result, $ExitCode ) = $RunCommand->('--skip-missing');

$Self->True(
    $Result,
    'No invalid settings found (skipped missing)'
);
$Self->False(
    $ExitCode,
    'Exit code OK'
);

# cleanup cache is done by RestoreDatabase

$Self->DoneTesting();
